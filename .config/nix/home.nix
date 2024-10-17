{ lib, inputs, ... }:
{
  home-manager = {
    users.aliervo = { config, pkgs, ... }: {
      imports = [
        inputs.ags.homeManagerModules.default
      ];
  
      home = {
        packages = with pkgs; [
          anki-bin
          brave
          # discord
          exercism
          ferium # cli-minecraft mod manager
          grafx2 # pixel art program
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
        
        sessionPath = [
          "$PNPM_HOME"
          "$HOME/.local/bin"
        ];

        sessionVariables = {
          TERMINAL = "alacritty";
          NPM_CONFIG_USERCONFIG = "${config.xdg.configHome}/npm/npmrc";
          _JAVA_OPTIONS = ''-Djava.util.prefs.userRoot="${config.xdg.configHome}"/java'';
          GRADLE_USER_HOME = "${config.xdg.dataHome}/gradle";
          PNPM_HOME = "${config.xdg.dataHome}/pnpm";
          ZK_NOTEBOOK_DIR = "${config.home.homeDirectory}/Sync/zettelkasten";
        };

        shellAliases.todo = "$(which todo.sh)";
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

        rofi = {
          enable = true;
          package = pkgs.rofi-wayland;
          theme = "dmenu";
        };

        swaylock.enable = true;
      };
  
      services = {
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
