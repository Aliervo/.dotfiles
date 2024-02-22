{ config, pkgs, lib, ... }:
{

  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Additional hardware mounting configuration
  fileSystems = {
    "/" =   {
      fsType = "btrfs";
      options = [ "compress=zstd" "autodefrag" ];
    };

    "/home" = {
      label = "hdd";
      fsType = "btrfs";
      options = [ "subvol=/HOME" "compress=zstd" "autodefrag" ];
    };
    
    "/games" = {
      label = "hdd";
      fsType = "btrfs";
      options = [ "subvol=/GAMES" "compress=zstd" "autodefrag" "noauto" ];
    };
  };

  boot = {
    # Tell the kernel to use appimage-run as the interpreter for appimage binary
    # files with the magic number "AI" + 0x02
    binfmt.registrations.appimage = {
      wrapInterpreterInShell = false;
      interpreter = "${pkgs.appimage-run}/bin/appimage-run";
      recognitionType = "magic";
      offset = 0;
      mask = ''\xff\xff\xff\xff\x00\x00\x00\x00\xff\xff\xff'';
      magicOrExtension = ''\x7fELF....AI\x02'';
    };

    loader = {
      systemd-boot.enable = true;
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot/efi";
      };
    };

    # Use Zen Kernel
    kernelPackages = pkgs.linuxPackages_zen;

    tmp.useTmpfs = true;
  };

  hardware = {
    bluetooth.enable = true;
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
      extraPackages = with pkgs; [
        vaapiIntel
        vaapiVdpau
        libvdpau-va-gl
      ];
    };

    nvidia = {
      modesetting.enable = true;

      # Hybrid Graphics Settings
      prime = {
        offload = {
          enable = true;
          enableOffloadCmd = true;
        };

        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };
  };

  # Networking
  networking = {
    firewall = {
      enable = false;
      allowedTCPPorts = [ 5173 ];
    };

    hostName = "nixClam";

    # Only enable this OR NetworkManager, not both
    # Use NetworkManager to play with WiDi
    wireless.iwd = {
      enable = true;
      settings = {
        Network.EnableIPv6 = true;
        Settings.AutoConnect = true;
      };
    };
    # If using NetworkManager, add users to the networkmanager group
    networkmanager.enable = false;
  };

  nix = {
    # Garabage Collector settings
    gc = {
      automatic = true;
      options = "--delete-older-than 30d";
      randomizedDelaySec = "45min";
    };

    extraOptions = ''
      keep-outputs = true
      keep-derivations = true
    '';
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Set your time zone.
  time.timeZone = "America/Chicago";

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

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.aliervo = {
    isNormalUser = true;
    description = "Sam";
    extraGroups = [ "wheel" /* "networkmanager" */ "video" ];
    shell = pkgs.zsh;
  };

  environment = {
    sessionVariables = {
      NIXOS_OZONE_WL = "1";
    };

    # Set zsh as default shell
    shells = [ pkgs.zsh ];

    systemPackages = with pkgs; [
      htop
      # gnome-network-displays
    ];
  };

  # Configure Fonts
  fonts = with pkgs; {
    enableDefaultPackages = true;
    fontconfig.defaultFonts = {
      monospace = [ "Victor Mono" ];
      emoji = [ "Noto Color Emoji" ];
    };
    packages = [ victor-mono noto-fonts-emoji ];
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  programs = {
    # Enable light for getting current brightness from terminal
    light.enable = true;

    neovim = {
      enable = true;
      defaultEditor = true;
    };

    zsh.enable = true;
  };

  security = {
    pam.services.swaylock= {};
    polkit.enable = true;
    rtkit.enable = true;
  };

  # List services that you want to enable:
  services = {
    # Enable session agnostic keybindings
    actkbd = {
      enable = true;
      bindings = [
        { keys = [ 224 ]; events = [ "key" ]; command = "${pkgs.light}/bin/light -U 10"; }
        { keys = [ 225 ]; events = [ "key" ]; command = "${pkgs.light}/bin/light -A 10"; }
      ];
    };

    # Enable automatic login for the user.
    getty.autologinUser = "aliervo";

    # Enable IPFS Node
    #kubo = {
      #enable = true;
      #autoMount = true;
      #enableGC = true;
      #user = "aliervo";
    #};

    # Enable pipewire for audio
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    # Power management with TLP and Upower
    tlp.enable = true;

    upower.enable = true;

    # Enable NVIDIA Drivers
    xserver.videoDrivers = [ "nvidia" ];
  };

  system.activationScripts = {
    # Unblock wifi and bluetooth
    rfkillUnblock = {
      text = ''
        rfkill unblock all
      '';
      deps = [];
    };
  };

  xdg.portal = {
    enable = true;
    config.common.default = "*";
    wlr.enable = true;
    # gtk portal needed to make gtk apps happy
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?

}
