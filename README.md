# flix.nix

Nix flake providing packages, dev shells, overlays, and apps for the [Flix](https://flix.dev/) programming language.

## Supported Versions

| Attribute suffix | Flix version |
|-----------------|--------------|
| `flix_0_71_0`   | 0.71.0       |
| `flix_0_72_0`   | 0.72.0       |
| `flix_0_73_0`   | 0.73.0 (default) |

## Usage

### Add to your flake inputs

```nix
{
  inputs = {
    flix-nix.url = "github:Cj-bc/flix.nix";
  };
}
```

### Run Flix directly

```bash
# Latest (0.73.0)
nix run github:Cj-bc/flix.nix

# Specific version
nix run github:Cj-bc/flix.nix#flix_0_71_0
nix run github:Cj-bc/flix.nix#flix_0_72_0
```

### Start a dev shell

```bash
# Latest (0.73.0)
nix develop github:Cj-bc/flix.nix

# Specific version
nix develop github:Cj-bc/flix.nix#flix_0_71_0
```

### Use an overlay in your flake

```nix
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flix-nix.url = "github:Cj-bc/flix.nix";
  };

  outputs = { nixpkgs, flix-nix, ... }:
    let
      pkgs = import nixpkgs {
        system = "x86_64-linux";
        overlays = [ flix-nix.overlays.flix_0_73_0 ];
      };
    in {
      # pkgs.flix is now Flix 0.73.0
    };
}
```

## Outputs

- `overlays.flix_0_71_0 / flix_0_72_0 / flix_0_73_0` — nixpkgs overlays that override the `flix` package with the specified version
- `packages.<system>.flix_0_71_0 / flix_0_72_0 / flix_0_73_0` — pre-built Flix packages
- `devShells.<system>.flix_0_71_0 / flix_0_72_0 / flix_0_73_0 / default` — dev shells with Flix available
- `apps.<system>.flix_0_71_0 / flix_0_72_0 / flix_0_73_0 / default` — runnable Flix CLI apps
