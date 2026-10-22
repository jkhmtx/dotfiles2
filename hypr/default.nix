{
  pkgs,
  config,
  mySpecialArgs,
  ...
}: let
  inherit (mySpecialArgs) lib;
  inherit (config.home) homeDirectory;
in {
  config = {
    home.sessionVariables = {
      NIXOS_OZONE_WL = "1";
    };

    home.packages = [
      pkgs.wl-clipboard
      # https://wiki.hypr.land/Useful-Utilities/Clipboard-Managers/#cliphist
      pkgs.cliphist
      pkgs.kdePackages.dolphin
      # https://wiki.hypr.land/Useful-Utilities/Must-have/#a-notification-daemon
      pkgs.dunst
      pkgs.hypridle
      pkgs.hyprlock
      # notify-send
      pkgs.libnotify
      # https://wiki.hypr.land/Useful-Utilities/App-Launchers/#rofi-wayland-fork
      pkgs.rofi
      # https://wiki.hypr.land/Useful-Utilities/Status-Bars/#waybar
      (pkgs.waybar.overrideAttrs (oldAttrs: {
        mesonFlags = oldAttrs.mesonFlags ++ ["-Dexperimental=true"];
      }))
      pkgs.swayimg
      pkgs.grimblast
    ];

    home.file = lib.home-manager.mkSymlinkAttrs {
      "${homeDirectory}/.config/hypr/hyprlock.conf" = {
        enable = true;
        force = true;
        outOfStoreSymlink = true;
        source = ./hyprlock.conf;
      };
      "${homeDirectory}/.config/hypr/hypridle.conf" = {
        enable = true;
        force = true;
        outOfStoreSymlink = true;
        source = ./hypridle.conf;
      };
      "${homeDirectory}/.config/hypr/hyprland.lua" = {
        enable = true;
        force = true;
        outOfStoreSymlink = true;
        source = ./hyprland.lua;
      };
    };
  };
}
