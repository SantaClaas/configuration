# Bootstrapping nix and configuring nix to the point it can configure the rest
# `chmod u+x` after git clone (change mode) to make file executable (+x) for current user (u)
echo "Copying nix.conf to ~/.config/nix/"
mkdir -p ~/.config/nix/
cp ./nix.conf ~/.config/nix/

echo "Downloading & verifying nix install script"
NIX_VERSION = "2.24.6"
# --location follow redirect
# --fail fail on bad HTTP code
INSTALL_SCRIPT = $(curl --location --fail -v https://releases.nixos.org/nix/nix-$NIX_VERSION/install)
ACTUAL_HASH = $(echo "$INSTALL_SCRIPT" | openssl dgst -sha256)
EXPECTED_HASH = "idk"
if ["$ACTUAL_HASH" != "$EXPECTED_HASH"]; then
    echo "Error: Invalid hash for nix install script. Expected: $EXPECTED_HASH Got: $ACTUAL_HASH"
    exit 1
else
    echo "Hash matches"
fi

echo "Running nix install script"
echo "$INSTALL_SCRIPT" | sh

echo "Resetting shell"
source /etc/profile

echo "Installing nix-darwin"
SCRIPT_DIRECTORY=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
nix run nix-darwin -- switch --flake $SCRIPT_DIRECTORY

echo "`darwin-rebuild switch --flake $SCRIPT_DIRECTORY` should not work"
