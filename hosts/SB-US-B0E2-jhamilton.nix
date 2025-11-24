{inputs, ...}: let
  user = {
    name = "jake";

    home = "/Users/jake";
    description = null;
  };
in {
  system = "aarch64-darwin";
  hostKind = "work";
  inherit user;
  repoPath = "${user.home}/dotfiles2";
  modules = [
    ../dev/direnv
    ../dev/git
    ../dev/github
    ../dev/nvim
    ../dev/ssh
    ../home-manager
    ../secrets/home-manager.nix
    ../shell
    ../term
    ../tmux
    inputs.sops-nix.homeManagerModules.sops
  ];
  unfree = [
    ../secrets/scripts/find-age-recipient/unfree.nix
  ];
  nixosModules = [];
}
