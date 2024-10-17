{ config, pkgs, inputs, ... }: rec {
  scheme = {
    slug = "solarized-dark"; scheme = "Solarized Dark"; author = "Ethan Schoonover";
    base00 = "002b36"; base01 = "073642"; base02 = "586e75"; base03 = "657b83";
    base04 = "839496"; base05 = "93a1a1"; base06 = "eee8d5"; base07 = "fdf6e3";
    base08 = "dc322f"; base09 = "cb4b16"; base0A = "b58900"; base0B = "859900";
    base0C = "2aa198"; base0D = "268bd2"; base0E = "2aa198"; base0F = "6c71c4";
  };

  stylix = {
    enable = true;
    cursor = {
      name = "phinger-cursors-light";
      package = pkgs.phinger-cursors;
    };
    image = ./nixos-wallpaper.png;
    polarity = "dark";
    fonts.monospace = {
      package = pkgs.victor-mono;
      name = "Victor Mono";
    };
    base16Scheme = ./solarized-dark.yaml;
  };

  home-manager.sharedModules = [{
    stylix.targets = {
      vim.enable = false;
      rofi.enable = false;
    };
  }];
}
