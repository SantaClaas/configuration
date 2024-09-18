# Bootstrapping nix and configuring nix to the point it can configure the rest
# `chmod u+x` after git clone (change mode) to make file executable (+x) for current user (u)
echo "Copying nix.conf to ~/.config/nix/"
mkdir -p ~/.config/nix/
cp ./nix.conf ~/.config/nix/

echo "Running nix install script"
curl -L https://nixos.org/nix/install | bash

echo "Installing nix-darwin"
SCRIPT_DIRECTORY=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
nix run nix-darwin -- switch --flake $SCRIPT_DIRECTORY

echo "`darwin-rebuild switch --flake $SCRIPT_DIRECTORY` should not work"
