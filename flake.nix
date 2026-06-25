{
  description = "Nix flake codes for flix language";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    my-nix-utils.url = "github:Cj-bc/my-nix-utils";
  };

  outputs = { self, nixpkgs, my-nix-utils }:
    let mkFlixOverlay = version: hash: final: prev: {
          flix = prev.flix.overrideAttrs(finalAttrs: previousAttrs: {
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
        flix_0_71_0 = mkFlixOverlay "0.71.0" "sha256-Ha5oRDpQ7YuGsaF/ZNx8b+HjTSroxZEjzI3zR3g7NXI=";
        flix_0_72_0 = mkFlixOverlay "0.72.0" "sha256-87WDphvCBJf5M46NtKGCTEu6k0g6SF/yttmRrEA8Nis=";
        flix_0_73_0 = mkFlixOverlay "0.73.0" "sha256-X2kiXS4qXAKau1qJswbJfi/gsty49RMW355+yYaBGUM=";
        flix_0_74_0 = mkFlixOverlay "0.74.0" "sha256-hHu5EXDF7PphruFuyY000M5JZqmRcyuv7g4i60T6YvM=";
    in my-nix-utils.lib.eachSystems nixpkgs.lib.systems.flakeExposed (system:
    {
      overlays = { inherit flix_0_71_0; inherit flix_0_72_0; inherit flix_0_73_0; inherit flix_0_74_0; };

      apps.${system} = {
        flix_0_71_0 = mkApp self.packages.${system}.flix_0_71_0;
        flix_0_72_0 = mkApp self.packages.${system}.flix_0_72_0;
        flix_0_73_0 = mkApp self.packages.${system}.flix_0_73_0;
        flix_0_74_0 = mkApp self.packages.${system}.flix_0_74_0;
        default = self.apps.${system}.flix_0_73_0;
      };

      packages.${system} = {
        flix_0_71_0 = (pkgsForSystemWithOverlays system [ flix_0_71_0 ]).flix;
        flix_0_72_0 = (pkgsForSystemWithOverlays system [ flix_0_72_0 ]).flix;
        flix_0_73_0 = (pkgsForSystemWithOverlays system [ flix_0_73_0 ]).flix;
        flix_0_74_0 = (pkgsForSystemWithOverlays system [ flix_0_74_0 ]).flix;
      };

      devShells.${system} = {
        flix_0_71_0 = mkDevShell system [ flix_0_71_0 ];
        flix_0_72_0 = mkDevShell system [ flix_0_72_0 ];
        flix_0_73_0 = mkDevShell system [ flix_0_73_0 ];
        flix_0_74_0 = mkDevShell system [ flix_0_74_0 ];
        default = self.devShells.${system}.flix_0_73_0;
      };
    });
}
