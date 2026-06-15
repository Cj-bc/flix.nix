[日本語](./README.ja.md)

---

# flix.nix

Nix flake providing packages for the [Flix](https://flix.dev/) programming language.

## Why not nixpkgs#flix?

There's [flix package in official nixpkgs repo](https://search.nixos.org/packages?channel=unstable&query=flix#show=flix), but it's currently out of date (it's 0.69.1, whereas latest is 0.73.0 as of writing this) and I understand it's difficult to keep it up-to-date in such a big and trusted repository.

Flix is actively under development and publishes new versions constantly, which sometimes contains breaking-changes. Thus it's vital to stay using the latest release.

I choose to create this repository to fill that
gap.

## Attributes

- packages
- apps
- devShells
- overlays

## Supported Versions

The default will be symlinked to the latest version.

| Attribute     | Flix version |
|---------------|--------------|
| `flix_0_71_0` | 0.71.0       |
| `flix_0_72_0` | 0.72.0       |
| `flix_0_73_0` | 0.73.0       |

## Usage

### Add to your flake inputs

```nix
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flix.url = "github:Cj-bc/flix.nix";
  };

  outputs = { self, nixpkgs, flix }: {
    packages.x86_64.default = packages.x86_64.stdenv.mkDerivation {
      buildInputs = [ flix.x86_64.flix_0_73_0 ];
    };
  };
}
```

### Run Flix directly

```bash
# Latest
nix run github:Cj-bc/flix.nix

# Specific version
nix run github:Cj-bc/flix.nix#flix_0_71_0
nix run github:Cj-bc/flix.nix#flix_0_72_0
```

### Start a dev shell

```bash
# Latest
nix develop github:Cj-bc/flix.nix

# Specific version
nix develop github:Cj-bc/flix.nix#flix_0_71_0
```

### Use an overlay in your flake

```nix
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flix.url = "github:Cj-bc/flix.nix";
  };

  outputs = { self, nixpkgs, flix, ... }:
    let
      pkgs = import nixpkgs {
        system = "x86_64-linux";
        overlays = [ flix.overlays.flix_0_73_0 ];
      };
    in {
      # pkgs.flix is now Flix 0.73.0
    };
}
```