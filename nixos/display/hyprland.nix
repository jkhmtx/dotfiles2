{pkgs, ...}: {
  config = {
    programs.hyprland = {
      enable = true;
    };

    environment.sessionVariables = {
      WLR_NO_HARDWARE_CURSORS = "1";
      NIXOS_OZONE_WL = "1";
    };

    environment.systemPackages = [
      # https://wiki.hypr.land/Useful-Utilities/Clipboard-Managers/#cliphist
      pkgs.cliphist
      pkgs.kdePackages.dolphin
      # https://wiki.hypr.land/Useful-Utilities/Must-have/#a-notification-daemon
      pkgs.dunst
      # https://wiki.hypr.land/Useful-Utilities/App-Launchers/#rofi-wayland-fork
      pkgs.rofi
      # https://wiki.hypr.land/Useful-Utilities/Status-Bars/#waybar
      (pkgs.waybar.overrideAttrs (oldAttrs: {
        mesonFlags = oldAttrs.mesonFlags ++ ["-Dexperimental=true"];
      }))
    ];

    xdg.portal.enable = true;
    xdg.portal.extraPortals = [pkgs.xdg-desktop-portal-gtk];

    hardware = {
      graphics.enable = true;
      nvidia.modesetting.enable = true;
    };
  };
}
