{config, ...}: {
  imports = [
    ./cinnamon.nix
    ./hyprland.nix
    ./xserver.nix
  ];

  services.displayManager.defaultSession = "hyprland-uwsm";
  services.xserver.displayManager.lightdm.extraSeatDefaults = ''
    user-session = ${config.services.displayManager.defaultSession}
  '';

  # KDE Plasma 5
  # services.xserver.desktopManager.plasma5.enable = true;
}
