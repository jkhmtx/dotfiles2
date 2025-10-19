{...}: {
  imports = [
    ./hyprland.nix
    ./plasma5.nix
    ./screenshot.nix
  ];

  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "jakeh";

  services.displayManager.sddm.enable = true;

  # Hyprland
  services.displayManager.sddm.wayland.enable = true;

  # KDE Plasma 5
  # services.xserver.desktopManager.plasma5.enable = true;
}
