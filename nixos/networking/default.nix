{...}: {
  imports = [./sshd.nix ./firewall.nix ./network-manager.nix ./udev.nix ./tunnel.nix];

  networking.hostName = "nixos";
}
