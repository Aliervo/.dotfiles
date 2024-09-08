{ config, pkgs, lib, inputs, ... }:
{
  home-manager = {
    #extraSpecialArgs = { inherit pkgs; };
    backupFileExtension = ".bak";

    useGlobalPkgs = true;
    users.aliervo = { config, pkgs, ... }: {
      imports = [
        inputs.nixvim.homeManagerModules.nixvim
        inputs.ags.homeManagerModules.default
      ];
  
      home = {
        username = "aliervo";
        homeDirectory = "/home/aliervo";

        packages = with pkgs; [
          anki-bin
          brave
          # discord
          exercism
          ferium
          grafx2
          inkscape
          ledger
          # minecraft
          openscad
          rpg-cli
          spectre-cli
          steam
          swaynotificationcenter
          todo-txt-cli
          webcord # Replaces discord for better Wayland Support
          wl-clipboard
          wl-clipboard-x11
        ];
        
        # Make programs use XDG directories whenever supported.
        preferXdgDirectories = true;

        sessionVariables = {
          TERMINAL = "alacritty";
          NPM_CONFIG_USERCONFIG = "${config.xdg.configHome}/npm/npmrc";
          _JAVA_OPTIONS = ''-Djava.util.prefs.userRoot="${config.xdg.configHome}"/java'';
          GRADLE_USER_HOME = "${config.xdg.dataHome}/gradle";
          PNPM_HOME = "${config.xdg.dataHome}/pnpm";
          ZK_NOTEBOOK_DIR = "${config.home.homeDirectory}/Sync/zettelkasten";
        };

        stateVersion = "23.05";
      };
  
      gtk = {
        enable = true;

        gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
      };

      programs = {
        ags = {
          enable = true;
          # configDir = "${config.xdg.configHome}/ags"; Doesn't work here for some reason
        };

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
          userEmail = "samfritz@protonmail.com";
          userName = "Aliervo";
        };
    
        home-manager.enable = true;
  
        nixvim = import ./nixvim.nix { inherit pkgs; };

        rofi = {
          enable = true;
          package = pkgs.rofi-wayland;
          theme = "dmenu";
        };
    
        swaylock.enable = true;

        zsh = {
          enable = true;
          autocd = true;
          dotDir = ".config/zsh";
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

      qt = {
        enable = true;

        platformTheme.name = "gtk2";
      };
      
      # Let Home Manager control XDG Base Dirs and Portal
      xdg = {
        enable = true;
        portal = { 
          enable = true;
          config = {
            common.default = [ "gtk" ];
            sway.default = [ "wlr" "gtk" ];
          };
          extraPortals = with pkgs; [
            xdg-desktop-portal-wlr
            xdg-desktop-portal-gtk
          ];
          xdgOpenUsePortal = true; # Force xdg-open to use the portal
        };

      };
    };
  };
}
