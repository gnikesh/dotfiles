#!/usr/bin/env bash
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
ln -sfn "$DIR" "$HOME/.dotfiles"

case "$(uname -s):$(uname -m)" in
  Darwin:*)
    exec sudo darwin-rebuild switch --flake "$DIR#mac"
    ;;
  Linux:x86_64|Linux:amd64)
    export NIX_CONFIG="${NIX_CONFIG-}
experimental-features = nix-command flakes"
    TARGET="linux-x86_64"
    ;;
  Linux:aarch64|Linux:arm64)
    export NIX_CONFIG="${NIX_CONFIG-}
experimental-features = nix-command flakes"
    TARGET="linux-aarch64"
    ;;
  *)
    echo "Unsupported platform: $(uname -s) $(uname -m)" >&2
    exit 1
    ;;
esac

if command -v home-manager >/dev/null 2>&1; then
  exec home-manager switch --flake "$DIR#$TARGET"
fi

# Bootstrap standalone Home Manager on a server where its command is not yet
# installed. The configuration itself remains pinned by this repository.
exec nix --extra-experimental-features 'nix-command flakes' run github:nix-community/home-manager/release-26.05 -- switch --flake "$DIR#$TARGET"
