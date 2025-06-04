{ inputs, pkgs, ... }:
{
  # Configuration shared by laptop and server
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  environment = {
    # Set zsh as default shell
    shells = [pkgs.zsh];
    systemPackages = with pkgs; [
      htop
      zellij
    ];
  };

  home-manager = {
    backupFileExtension = ".bak";

    useGlobalPkgs = true;
    users.aliervo = { config, pkgs, ...}: {
      imports = [
        inputs.nixvim.homeManagerModules.nixvim
      ];

      home = {
        username = "aliervo";
        preferXdgDirectories = true;
        shellAliases.dotfiles = "${pkgs.git}/bin/git --git-dir=${config.home.homeDirectory}/.dotfiles/ --work-tree=${config.home.homeDirectory}";
        stateVersion = "23.05";
      };

      programs = {
        direnv = {
          enable = true;
          nix-direnv.enable = true;
        };

        git = {
          enable = true;
          aliases.co = "checkout";
          userEmail = "samfritz@proton.me";
          userName = "Aliervo";
        };

        home-manager.enable = true;

        nixvim = import ./nixvim.nix { inherit pkgs; };

        zsh = {
          enable = true;
          autocd = true;
          dotDir = ".config/zsh";
          history.path = "${config.xdg.dataHome}/zsh/histfile";

          loginExtra = ''
            # If running from tty1 start sway
            [ "$(tty)" = "/dev/tty1" ] && exec sway
          '';

          plugins = [
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
        };

      };

      services.syncthing.enable = true;
    };
  };

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_US.UTF-8";

    extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };
  };

  nix = {
    # Garbage Collector settings
    gc = {
      automatic = true;
      options = "--delete-older-than 30d";
      randomizedDelaySec = "45min";
    };

    extraOptions = ''
      keep-outputs = true
      keep-derivations = true
    '';

    # Enable flakes
    settings = {
      experimental-features = [ "nix-command flakes" ];
      trusted-users = [ "root" "aliervo" ];
    };
  };

  programs = {
    nano.enable = false;
    neovim = {
      enable = true;
      defaultEditor = true;
    };
    zsh.enable = true;
  };

  time.timeZone = "America/Chicago";
 
  virtualisation = {
    # Enable common container config files in /etc/containers
    containers = {
      enable = true;
      storage.settings.storage.driver = "btrfs";
    };

    podman = {
      enable = true;

      # Create a "docker" alias for podman to use it as a drop in replacement
      dockerCompat = true;

      # Required for containers under podman-compose to be able to talk to each other
      defaultNetwork.settings.dns_enabled = true;
    };
  };
}
