# flix.nix

[Flix](https://flix.dev/) プログラミング言語のパッケージ・開発シェル・オーバーレイ・アプリを提供する Nix flake です。

## 対応バージョン

| 属性名サフィックス | Flix バージョン |
|-------------------|----------------|
| `flix_0_71_0`     | 0.71.0         |
| `flix_0_72_0`     | 0.72.0         |
| `flix_0_73_0`     | 0.73.0 (デフォルト) |

## 使い方

### flake の inputs に追加する

```nix
{
  inputs = {
    flix-nix.url = "github:Cj-bc/flix.nix";
  };
}
```

### Flix を直接実行する

```bash
# 最新版 (0.73.0)
nix run github:Cj-bc/flix.nix

# バージョンを指定して実行
nix run github:Cj-bc/flix.nix#flix_0_71_0
nix run github:Cj-bc/flix.nix#flix_0_72_0
```

### 開発シェルに入る

```bash
# 最新版 (0.73.0)
nix develop github:Cj-bc/flix.nix

# バージョンを指定して入る
nix develop github:Cj-bc/flix.nix#flix_0_71_0
```

### 自分の flake でオーバーレイを使う

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
      # pkgs.flix が Flix 0.73.0 になります
    };
}
```

## 出力一覧

- `overlays.flix_0_71_0 / flix_0_72_0 / flix_0_73_0` — nixpkgs の `flix` パッケージを指定バージョンに差し替えるオーバーレイ
- `packages.<system>.flix_0_71_0 / flix_0_72_0 / flix_0_73_0` — ビルド済みの Flix パッケージ
- `devShells.<system>.flix_0_71_0 / flix_0_72_0 / flix_0_73_0 / default` — Flix が使える開発シェル
- `apps.<system>.flix_0_71_0 / flix_0_72_0 / flix_0_73_0 / default` — 実行可能な Flix CLI アプリ
