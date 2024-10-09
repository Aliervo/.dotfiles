{ pkgs, ... }:
{
  # Configuration shared by laptop and server
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
    ];
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
    settings.experimental-features = [ "nix-command flakes" ];
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
}
