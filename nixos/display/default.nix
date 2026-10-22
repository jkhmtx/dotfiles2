{...}: {
  imports = [
    ./hyprland.nix
    ./xserver.nix
  ];

  services.displayManager.sddm.enable = true;

  # Hyprland
  services.displayManager.sddm.wayland.enable = true;

  # KDE Plasma 5
  # services.xserver.desktopManager.plasma5.enable = true;
}
