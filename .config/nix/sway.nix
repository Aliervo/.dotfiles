{ lib, pkgs }:
{
  enable = true;
  extraOptions = [ "--unsupported-gpu" ];
  config = rec {
    modifier = "Mod4";
    terminal = "${pkgs.alacritty}/bin/alacritty";
    input = {
      "type:touchpad" = {
        tap = "enabled";
        natural_scroll = "enabled";
      };
      "type:keyboard" = {
        xkb_numlock = "enabled";
      };
    };
    bars = [ {
      position = "top";
      statusCommand = "${pkgs.i3status}/bin/i3status";
    } ];
    keybindings = let controller = "${pkgs.wireplumber}/bin/wpctl";
    in lib.mkOptionDefault {
      "XF86AudioRaiseVolume" = "exec ${controller} set-volume @DEFAULT_SINK@ 5%+";
      "XF86AudioLowerVolume" = "exec ${controller} set-volume @DEFAULT_SINK@ 5%-";
      "XF86AudioMute" = "exec ${controller} set-mute @DEFAULT_SINK@ toggle";
      "XF86AudioMicMute" = "exec ${controller} set-mute @DEFAULT_SOURCE@ toggle";
      "F12" = ''[title="Alacritty Dropdown"] scratchpad show'';
      "${modifier}+Shift+n" = "exec ${pkgs.swaynotificationcenter}/bin/swaync-client -t -sw";
      "Print" = "exec ${pkgs.grim}/bin/grim /tmp/$(date +'%H:%M:%S.png')";
      "${modifier}+Print" = ''exec ${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp)" /tmp/$(date +'%H:%M:%S.png')'';
    };
    menu = "${pkgs.rofi-wayland}/bin/rofi -show drun -modi 'drun,run'";
    startup = [
      { command = "${pkgs.alacritty}/bin/alacritty --config-file ~/.config/alacritty/dropdown.toml -t 'Alacritty Dropdown'"; }
      { command = "${pkgs.swaynotificationcenter}/bin/swaync"; }
    ];
    window = {
      border = 1;
      commands = [
        {
	  command = "floating enable, resize set 100 ppt 50 ppt, move position 0 0, move scratchpad";
	  criteria = { title = "Alacritty Dropdown"; };
        }
      ];
      titlebar = false;
    };
  };
}
