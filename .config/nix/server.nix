{ pkgs, ... }:
{ # Server specific configuration

  imports = [
    ./hardware-server.nix
  ];

  networking = {
    hostName = "nixBrick";
    wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  };

  programs.git.enable = true;

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
  };

  users.users.aliervo = {
    isNormalUser = true;
    description = "Sam";
    extraGroups = ["wheel"];
    shell = pkgs.zsh;
  };
  
  virtualisation = {
    # Enable common container config files in /etc/containers
    containers = {
      enable = true;
      storage.settings.driver = "btrfs";
    };

    podman = {
      enable = true;

      # Create a "docker" alias for podman to use it as a drop in replacement
      docker-compat = true;

      # Required for containers under podman-compose to be able to talk to each other
      defaultNetwork.settings.dns_enabled = true;
    };
  };
  
  # https://nixos.org/manual/nixos/stable/options#opt-system.state
  system.stateVersion = "24.05";
}
