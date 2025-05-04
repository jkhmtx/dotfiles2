{pkgs, ...}: {
  config = {
    programs.hyprland = {
      enable = true;
      nvidiaPatches = true;
      xwayland.enable = true;
    };

    environment.sessionVariables = {
      WLR_NO_HARDWARE_CURSORS = "1";
      NIXOS_OZONE_WL = "1";
    };

    environment.systemPackages = [
      pkgs.dunst
      (pkgs.waybar.overrideAttrs (oldAttrs: {
        mesonFlags = oldAttrs.mesonFlags ++ ["-Dexperimental=true"];
      }))
      pkgs.libnotify
    ];

    xdg.portal.enable = true;
    xdg.portal.extraPortals = [pkgs.xdg-desktop-portal-gtk];

    sound.enable = true;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };
  };

  hardware = {
    opengl.enable = true;
    nvidia.modesetting.enable = true;
    pulseaudio.enable = true;
  };
}
