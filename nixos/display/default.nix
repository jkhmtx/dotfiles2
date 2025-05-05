{...}: {
  imports = [
    ./hyprland.nix
    ./x11.nix
  ];

  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "jakeh";
}
