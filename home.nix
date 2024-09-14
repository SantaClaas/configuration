{ config, pkgs, ...}:

{
    home.username = "claas";
    home.homeDirectory = "/Users/claas";
    home.stateVersion = "24.05";

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;
}