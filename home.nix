{ config, pkgs, ...}:

{
    home = {
        username = "claas";
        homeDirectory = "/Users/claas";
        stateVersion = "24.05";
        packages = [
            pkgs.python3
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
        fish.enable = true;
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
