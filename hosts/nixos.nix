{inputs, ...}: let
  user = {
    name = "jakeh";

    home = "/home/jakeh";
    description = "Jake Hamilton";
  };
  sara = {
    name = "sara";

    home = "/home/sara";
    description = "Sara";
  };
  lucy = {
    name = "lucy";

    home = "/home/lucy";
    description = "Lucy";
  };
  maddie = {
    name = "maddie";

    home = "/home/maddie";
    description = "Maddie";
  };
in {
  inherit (inputs) nixpkgs;
  system = "x86_64-linux";
  users.${user.name} = {
    inherit user;
    repoPath = "${user.home}/projects/dotfiles";
    modules = [
      ../audio/composition.nix
      ../audio/daw.nix
      ../dev/direnv
      ../dev/git
      ../dev/github
      ../dev/llm/claude
      ../dev/llm/claude/update
      ../dev/nvim
      ../dev/rust
      ../dev/ssh
      ../borg
      ../browser
      ../home-manager
      ../hypr
      ../secrets/home-manager.nix
      ../shell
      ../shell/linux.nix
      ../term/emulator
      ../term/multiplexer
      inputs.sops-nix.homeManagerModules.sops
    ];
    unfree = [
      ../secrets/scripts/find-age-recipient/unfree.nix
    ];
  };
  users.${sara.name} = {
    user = sara;
    repoPath = "${sara.home}/projects/dotfiles";
    modules = [
      ../browser/brave.nix
      ../home-manager
    ];
    unfree = [];
  };
  users.${lucy.name} = {
    user = lucy;
    repoPath = "${lucy.home}/projects/dotfiles";
    modules = [
      ../browser/brave.nix
      ../home-manager
    ];
    unfree = [];
  };
  users.${maddie.name} = {
    user = maddie;
    repoPath = "${maddie.home}/projects/dotfiles";
    modules = [
      ../browser/brave.nix
      ../home-manager
    ];
    unfree = [];
  };
  nixOs = {
    unfree = [
      ../nixos/hardware/unfree.nix
      ../nixos/games/unfree.nix
      ../nixos/password-manager/unfree.nix
    ];
    modules = [
      ../nixos/configuration.nix
      ../nixos/users/jakeh.nix
      ../nixos/users/sara.nix
      ../nixos/users/lucy.nix
      ../nixos/users/maddie.nix
      ../secrets
      inputs.sops-nix.nixosModules.sops
    ];
  };
}
