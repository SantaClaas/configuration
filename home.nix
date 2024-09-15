{ config, pkgs, ...}:

{
    home.username = "claas";
    home.homeDirectory = "/Users/claas";
    home.stateVersion = "24.05";

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
        fish.enable = true;
        # GitHub CLI
        gh = {
            enable = true;
            gitCredentialHelper.enable = true;
        };
    };
}