{inputs, ...}: {
  system = "x86_64-linux";
  user = {
    name = "jakeh";

    home = "/home/jakeh";
    description = "Jake Hamilton";
  };
  modules = [
    ../audio/daw.nix
    ../dev/direnv
    ../dev/git
    ../dev/github
    ../dev/nvim
    ../borg
    ../home-manager
    ../hypr
    ../secrets/home-manager.nix
    ../shell
    ../term
    ../tmux
    inputs.sops-nix.homeManagerModules.sops
  ];
  unfree = [
    ../secrets/scripts/find-age-recipient/unfree.nix
    ../nixos/password-manager/unfree.nix
    ../nixos/games/unfree.nix
  ];
  nixosModules = [
    ../nixos/configuration.nix
    ../secrets
    inputs.sops-nix.nixosModules.sops
  ];
}
