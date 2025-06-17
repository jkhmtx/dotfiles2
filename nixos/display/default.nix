{...}: {
  imports = [
    ./hyprland.nix
    ./plasma5.nix
  ];

  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "jakeh";
}
