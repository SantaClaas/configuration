{ config, pkgs, ... }:

{
  home = {
    username = "claas";
    homeDirectory = "/Users/claas";
    stateVersion = "24.05";
    packages = [
      pkgs.python3
      # Fast Node (Version) Manager
      pkgs.fnm
      # Faster Node Package Manager
      pkgs.pnpm
      # Might not be necessary seems to be included with fnm?
      # pkgs.pnpm
      # Probe-rs used for embedded Rust development using embassy in fan-control project
      pkgs.probe-rs
      # Cloudflared for tunneling local development services to other devices
      pkgs.cloudflared
      # libcrux Rust cate needs this for building
      pkgs.cmake
    ];
  };

  programs = {
    # Let Home Manager install and manage itself.
    home-manager.enable = true;
    git = {
      enable = true;
      userName = "Claas";
      userEmail = "claas@claas.dev";
      extraConfig = {
        commit.gpgsign = true;
        gpg.format = "ssh";
        user.signingkey = "~/.ssh/id_ed25519.pub";
      };
    };
    # htop alternative
    btop.enable = true;
    # Fish shell
    fish = {
      enable = true;
      # Fast node manager (FNM) setup https://discourse.nixos.org/t/how-to-set-startup-script-in-fish-shell-using-home-manager/24739
      interactiveShellInit = ''
        fnm env --use-on-cd | source
      '';
    };
    # GitHub CLI
    gh = {
      enable = true;
      gitCredentialHelper.enable = true;
    };
    # Starship
    starship = {
      enable = true;

      # settings = {
      #     # Set the prompt theme to "minimal".
      #     prompt = "minimal";
      #     # Set the character used to prefix the prompt.
      #     symbol = "➜";
      #     # Set the character used to prefix the git branch.
      #     prefix = "[";
      #     # Set the character used to suffix the git branch.
      #     suffix = "]";
      # };
    };
  };
}
