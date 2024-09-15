# This configuration configures the system.
# Use home manager configuration to configure user specific settings
{
  # Documentation https://daiderd.com/nix-darwin/manual/index.html
  description = "Darwin System Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Import home manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # Export home manager (and other stuff)
  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager }:
  let
    configuration = { pkgs, ... }: {
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages =
        [ pkgs.vim
        ];

      # Auto upgrade nix package and the daemon service.
      services.nix-daemon.enable = true;
      # nix.package = pkgs.nix;

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Create /etc/zshrc that loads the nix-darwin environment.
      programs.zsh.enable = true;  # default shell on catalina
      # programs.fish.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 5;

      # Allow use of TouchId for sudo actions
      security.pam.enableSudoTouchIdAuth = true;

      system.defaults = {
        dock.autohide = true;
        screencapture.location = "~/Pictures/Screencaptures";
      };

      homebrew.enable = true;
      homebrew.casks = [
        # "google-chrome"
        # Fix mouse scroll direction and acceleration for non apple mice
        "linearmouse"
        # Terminal
        # "warp"
      ];

      # Tell nix wher the home directory is for hom manager
      users.users.claas.home = "/Users/claas";

      # Tell nix to build users that are currently not in the system
      nix.configureBuildUsers = true;


      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";

      programs.fish = {
        enable = true;
      };

      programs.shh.knownHosts = [
        {
          hostNames = [ "202.61.243.115" ];
          publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIDyx6oHz1jloUPfyt/Gp5Tt0vmk212YVj3+LeHwe20u";
        }
      ];
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#Kayak
    darwinConfigurations."Kayak" = nix-darwin.lib.darwinSystem {
      modules = [
        configuration
        # Calling the home manager function with a set
        home-manager.darwinModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.claas = import ./home.nix;
        }
      ];
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."Kayak".pkgs;
  };
}
