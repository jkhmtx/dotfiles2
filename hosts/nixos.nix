{inputs, ...}: let
  user = {
    name = "jakeh";

    home = "/home/jakeh";
    description = "Jake Hamilton";
  };
in {
  system = "x86_64-linux";
  hostKind = "personal";
  inherit user;
  repoPath = "${user.home}/projects/dotfiles";
  modules = [
    ../audio/composition.nix
    ../audio/daw.nix
    ../dev/direnv
    ../dev/git
    ../dev/github
    ../dev/nvim
    ../dev/ssh
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
    ../nixos/display/unfree.nix
  ];
  nixosModules = [
    ../nixos/configuration.nix
    ../secrets
    inputs.sops-nix.nixosModules.sops
  ];
}
