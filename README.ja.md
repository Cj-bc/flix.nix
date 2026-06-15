# flix.nix

[Flix](https://flix.dev/) プログラミング言語用の Nix flake です。

## Why not nixpkgs#flix?

[nixpkgs 公式にもflixは存在する](https://search.nixos.org/packages?channel=unstable&query=flix#show=flix)ものの、大きくて権威あるが故に最新版が降りてくるのがどうしても遅いです。（執筆時点での最新版flix: 0.73.0, nixpkgs.flix: 0.69.1）
flixは開発中の言語であるためバージョン違いでの変更が大きく致命的であるため、より簡単に最新版を入れられるようにするため別レポジトリを作りました。

## attributes

- packages
- apps
- devShells
- overlays

## 対応バージョン

default は最新版を指すように更新されます。

| attribute     | Flix バージョン |
|---------------|----------------|
| `flix_0_71_0` | 0.71.0         |
| `flix_0_72_0` | 0.72.0         |
| `flix_0_73_0` | 0.73.0         |

## 使い方

### flakeで使う

```nix
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flix.url = "github:Cj-bc/flix.nix";
  };

  outputs = { self, nixpkgs, flix }: {
    packages.x86_64.default = packages.x86_64.stdenv.mkDerivation {
      ...
      buildInputs = [ flix.x86_64.flix_0_73_0 ];
    };
  };
}
```

### Flix 直接実行

```bash
# 最新版
nix run github:Cj-bc/flix.nix

# バージョンを指定して実行
nix run github:Cj-bc/flix.nix#flix_0_71_0
nix run github:Cj-bc/flix.nix#flix_0_72_0
```

### 開発シェルに入る

```bash
# 最新版
nix develop github:Cj-bc/flix.nix

# バージョンを指定して入る
nix develop github:Cj-bc/flix.nix#flix_0_71_0
```

### 自分の flake でオーバーレイを使う

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
      # pkgs.flix が Flix 0.73.0 になります
    };
}
```
