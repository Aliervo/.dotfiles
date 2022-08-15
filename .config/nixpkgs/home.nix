{ config, pkgs, ... }:

with pkgs;{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "aliervo";
  home.homeDirectory = "/home/aliervo";

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    gomuks
    authy
  ];

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Allow unfree pkgs to be installed.
  nixpkgs.config.allowUnfree = true;

  # Git configuration
  programs.git = {
    enable = true;
    aliases = { co = "checkout"; };
    userEmail = "aliervo@wingedvengeance.net";
    userName = "Aliervo";
  };
}
