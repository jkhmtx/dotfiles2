{...}: {
  imports = [
    ./cinnamon.nix
    ./hyprland.nix
    ./xserver.nix
  ];

  services.displayManager.defaultSession = "hyprland-uwsm";

  # KDE Plasma 5
  # services.xserver.desktopManager.plasma5.enable = true;
}
