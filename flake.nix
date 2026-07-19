{
  description = "Nix flake codes for flix language";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      flixData = builtins.fromJSON (builtins.readFile ./versions.json);
      flixVersions = builtins.removeAttrs flixData [ "latest" ];
      latestVersion = flixData.latest;

      # "0.75.1" → "flix_0_75_1"
      attrName = version: "flix_${builtins.replaceStrings ["."] ["_"] version}";

      mkFlixOverlay = version: hash: final: prev: {
        flix = prev.flix.overrideAttrs (finalAttrs: previousAttrs: {
          version = version;
          src = prev.fetchurl {
            url = "https://github.com/flix/flix/releases/download/v${version}/flix.jar";
            sha256 = hash;
          };
        });
      };

      pkgsForSystemWithOverlays = system: overlays: import nixpkgs { inherit system; inherit overlays; };

      mkDevShell = system: overlays:
        let pkgs = pkgsForSystemWithOverlays system overlays;
        in pkgs.mkShell {
          packages = [ pkgs.flix ];
        };

      mkApp = flix: { type = "app"; program = "${flix}/bin/flix"; };

      # Overlays keyed by attribute name (e.g. flix_0_75_1)
      flixOverlays = builtins.listToAttrs (
        map (version: {
          name = attrName version;
          value = mkFlixOverlay version flixVersions.${version};
        }) (builtins.attrNames flixVersions)
      );

      # Generate { flix_0_71_0 = f "0.71.0"; ... } for each version
      forEachVersion = f: builtins.listToAttrs (
        map (version: {
          name = attrName version;
          value = f version;
        }) (builtins.attrNames flixVersions)
      );
    in
    # Build per-system outputs by folding over nixpkgs' system list.
    # `acc.<category> or {} // { ${system} = ...; }` is needed because `//`
    # is a shallow merge — nesting the merge per-category prevents each
    # iteration from overwriting the accumulated attrset for other systems.
    builtins.foldl' (acc: system: acc // {
      apps = acc.apps or {} // {
        ${system} =
          forEachVersion (version: mkApp self.packages.${system}.${attrName version})
          // { default = self.apps.${system}.${attrName latestVersion}; };
      };
      packages = acc.packages or {} // {
        ${system} =
          forEachVersion (version: (pkgsForSystemWithOverlays system [ flixOverlays.${attrName version} ]).flix)
          // { default = self.packages.${system}.${attrName latestVersion}; };
      };
      devShells = acc.devShells or {} // {
        ${system} =
          forEachVersion (version: mkDevShell system [ flixOverlays.${attrName version} ])
          // { default = self.devShells.${system}.${attrName latestVersion}; };
      };
    }) { overlays = flixOverlays; } nixpkgs.lib.systems.flakeExposed;
}
