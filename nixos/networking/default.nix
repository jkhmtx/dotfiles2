{...}: {
  imports = [./firewall.nix ./network-manager.nix ./udev.nix];

  networking.hostName = "nixos";
}
