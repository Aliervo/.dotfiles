{ config, pkgs, ... }:

with pkgs;{
  targets.genericLinux.enable = true;

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

  # Allow unfree pkgs to be installed.
  nixpkgs.config.allowUnfree = true;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Git configuration
  programs.git = {
    enable = true;
    aliases = { co = "checkout"; };
    userEmail = "aliervo@wingedvengeance.net";
    userName = "Aliervo";
  };

  # Zsh configuration
  programs.zsh = {
    enable = true;
    autocd = true;
    dotDir = ".config/zsh";
    envExtra = ''
      export TERMINAL="alacritty"
      export QT_QPA_PLATFORMTHEME=gtk2
      export EDITOR=$(which nvim)
      export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"
      export _JAVA_OPTIONS=-Djava.util.prefs.userRoot="$XDG_CONFIG_HOME"/java
      export GTK2_RC_FILES="$XDG_CONFIG_HOME"/gtk-2.0/gtkrc
      export GRADLE_USER_HOME="$XDG_DATA_HOME"/gradle
      export NIX_PATH=$HOME/.nix-defexpr/channels:/nix/var/nix/profiles/per-user/root/channels''${NIX_PATH:+:$NIX_PATH}
    '';
    history.path = "${config.xdg.dataHome}/zsh/histfile";
    initExtra = ''
      # Initialise the prompt system and set prompt to Pure.
      autoload -U promptinit; promptinit
      prompt pure
    '';
    plugins = [
      {
        name = "pure";
        src = pkgs.fetchFromGitHub {
            owner = "sindresorhus";
            repo = "pure";
            rev = "v1.20.1";
            sha256 = "iuLi0o++e0PqK81AKWfIbCV0CTIxq2Oki6U2oEYsr68=";
          };
      }
    ];
    shellAliases = {
      dotfiles = "$(which git) --git-dir=$HOME/.dotfiles/ --work-tree=$HOME";
    };
  };
}
