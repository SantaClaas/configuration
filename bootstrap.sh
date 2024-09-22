#!/bin/bash
# Bootstrapping nix and configuring nix to the point it can configure the rest
# `chmod u+x` after git clone (change mode) to make file executable (+x) for current user (u)
echo "Copying nix.conf to ~/.config/nix/"
mkdir -p ~/.config/nix/
cp ./nix.conf ~/.config/nix/

echo "Downloading & verifying nix install script"
NIX_VERSION=2.24.6
# --location follow redirect
# --fail fail on bad HTTP code
URL=https://releases.nixos.org/nix/nix-$NIX_VERSION/install

INSTALL_SCRIPT=$(curl --location --fail -v "$URL")
ACTUAL_HASH=$(echo "$INSTALL_SCRIPT" | openssl dgst -sha256)

EXPECTED_HASH=9f4535a9e90ab72874cf20ee1f9d41a130b16a56519dc3eec729540fcc78316f
# The whitespace in bash matters
if [ "$ACTUAL_HASH" != "$EXPECTED_HASH" ]; then
    echo "Error: Invalid hash for nix install script. Version: $NIX_VERSION Expected: $EXPECTED_HASH Got: $ACTUAL_HASH"
    exit 1
else
    echo "Hash matches"
fi

echo "Running nix install script"
echo "$INSTALL_SCRIPT" | sh

echo "Resetting shell"
source /etc/zshrc

echo "Installing nix-darwin"
SCRIPT_DIRECTORY=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
nix run nix-darwin -- switch --flake $SCRIPT_DIRECTORY

echo "darwin-rebuild switch --flake $SCRIPT_DIRECTORY should now work"
