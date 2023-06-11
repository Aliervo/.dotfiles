{ config, pkgs, lib, inputs, ... }:
{

  home-manager = {
    #extraSpecialArgs = { inherit pkgs; };

    useGlobalPkgs = true;
    users.aliervo = { config, pkgs, ... }: {
      imports = [
        inputs.nixvim.homeManagerModules.nixvim
      ];
  
      home = {
        username = "aliervo";
        homeDirectory = "/home/aliervo";

	packages = with pkgs; [
	  anki-bin
	  brave
	  discord
	  exercism
	  grafx2
	  inkscape
	  ledger
	  rpg-cli
	  spectre-cli
	  steam
	  swaynotificationcenter
	  todo-txt-cli
	];

        stateVersion = "23.05";
      };
  
      programs = {
        alacritty = {
	  enable = true;
          settings = {
            env.TERM = "xterm-256color";
            window.dynamic_title = true;
            font = {
              normal = {
                family = "Victor Mono";
                style = "Regular";
              };
              bold.style = "Bold";
              italic.style = "Italic";
              bold_italic.style = "Bold Italic";
              # size = 11.0;
            };
          };
	};
    
        direnv = {
          enable = true;
	  nix-direnv.enable = true;
        };
  
        git = {
          enable = true;
          aliases = { co = "checkout"; };
          userEmail = "aliervo@wingedvengeance.net";
          userName = "Aliervo";
        };
    
        home-manager.enable = true;
  
        nixvim = import ./nixvim.nix { inherit pkgs; };

        rofi = {
          enable = true;
	  package = pkgs.rofi-wayland;
	  theme = "dmenu";
        };
    
        zsh = {
          enable = true;
          autocd = true;
          dotDir = ".config/zsh";

          envExtra = ''
            export TERMINAL="alacritty"
            export QT_QPA_PLATFORMTHEME=gtk2
            export NPM_CONFIG_USERCONFIG="${config.xdg.configHome}/npm/npmrc"
            export _JAVA_OPTIONS=-Djava.util.prefs.userRoot="${config.xdg.configHome}"/java
            export GTK2_RC_FILES="${config.xdg.configHome}"/gtk-2.0/gtkrc
            export GRADLE_USER_HOME="${config.xdg.dataHome}"/gradle
            export PNPM_HOME="${config.xdg.dataHome}/pnpm"
          '';

          history.path = "${config.xdg.dataHome}/zsh/histfile";

          initExtra = ''
            # Initialise the prompt system and set prompt to Pure.
            autoload -U promptinit; promptinit
            prompt pure
  
            # Adjust $PATH
            typeset -U path PATH
            path=($PNPM_HOME $HOME/.local/bin $path)
            export PATH
          '';

	  loginExtra = ''
	    # If running from tty1 start start sway
	    [ "$(tty)" = "/dev/tty1" ] && exec sway
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
	    {
              name = "zshrpg";
	      file = "rpg.plugin.zsh";
              src = pkgs.fetchgit {
                url = "https://github.com/aliervo/zshrpg";
                sha256 = "sQEl6TPzHJ0GeV7JFE6OJk/opABREjiDeArn/N2WlEw=";
              };
            }
	    {
              name = "ztap";
	      file = "ztap3.zsh";
              src = pkgs.fetchgit {
                url = "https://github.com/mattmc3/ztap";
                sha256 = "4IuXZ3BZio+hmKxYGdPdVyAE97RMHhFX/HBM9czMpVk=";
              };
            }
          ];

          shellAliases = {
            dotfiles = "$(which git) --git-dir=$HOME/.dotfiles/ --work-tree=$HOME";
            todo = "$(which todo.sh)";
          };
        };
      };  
  
      services = {
        syncthing.enable = true;
        swayidle = {
          enable = true;
          events = [
            { event = "before-sleep"; command = "${pkgs.swaylock}/bin/swaylock"; }
          ];
        };
      };
  
      wayland.windowManager.sway = import ./sway.nix { inherit lib pkgs; };

      # Let Home Manager control XDG Base Dirs
      xdg.enable = true;
    };
  };
}
