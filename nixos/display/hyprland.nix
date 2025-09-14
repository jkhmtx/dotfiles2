{
  pkgs,
  config,
  ...
}: {
  config = {
    programs.hyprland = {
      enable = true;
      withUWSM = true;
    };

    services.hypridle.enable = true;

    environment.sessionVariables = {
      WLR_NO_HARDWARE_CURSORS = "1";
      NIXOS_OZONE_WL = "1";
    };

    environment.systemPackages = [
      pkgs.wl-clipboard
      # https://wiki.hypr.land/Useful-Utilities/Clipboard-Managers/#cliphist
      pkgs.cliphist
      pkgs.kdePackages.dolphin
      # https://wiki.hypr.land/Useful-Utilities/Must-have/#a-notification-daemon
      pkgs.dunst
      pkgs.hypridle
      # notify-send
      pkgs.libnotify
      # https://wiki.hypr.land/Useful-Utilities/App-Launchers/#rofi-wayland-fork
      pkgs.rofi
      # https://wiki.hypr.land/Useful-Utilities/Status-Bars/#waybar
      (pkgs.waybar.overrideAttrs (oldAttrs: {
        mesonFlags = oldAttrs.mesonFlags ++ ["-Dexperimental=true"];
      }))
    ];

    xdg.portal.enable = true;
    xdg.portal.extraPortals = [pkgs.xdg-desktop-portal-gtk];

    services.xserver.videoDrivers = ["nvidia"];
    hardware = {
      graphics.enable = true;
      nvidia = {
        modesetting.enable = true;
        open = true;

        # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
        # Enable this if you have graphical corruption issues or application crashes after waking
        # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead
        # of just the bare essentials.
        powerManagement.enable = true;

        # Fine-grained power management. Turns off GPU when not in use.
        # Experimental and only works on modern Nvidia GPUs (Turing or newer).
        powerManagement.finegrained = false;
        nvidiaSettings = true;

        package = config.boot.kernelPackages.nvidiaPackages.beta;
      };
    };
  };
}
