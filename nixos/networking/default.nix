{...}: {
  imports = [
    ./sshd.nix
    ./firewall.nix
    ./network-manager.nix
    ./tunnel.nix
  ];

  networking.hostName = "nixos";
}
