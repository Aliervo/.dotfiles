{ ... }:
{ # Server specific configuration

  imports = [
    ./hardware-server.nix
  ];

  networking = {
    hostName = "nixBrick";
    wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  };

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
  };

  # https://nixos.org/manual/nixos/stable/options#opt-system.state
  system.stateVersion = "24.05";
}
