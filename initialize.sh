# Bootstrapping nix and configuring nix to the point it can configure the rest

echo "Copying nix.conf to ~/.config/nix/"
cp ./nix.conf ~/.config/nix/

echo "Running nix install script"
sh <(curl -L https://nixos.org/nix/install)

echo "Installing nix-darwin"
nix run nix-darwin -- switch --flake ~/.config/nix-darwin
