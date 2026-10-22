{inputs, ...}: let
  user = {
    name = "jakeh";

    home = "/home/jakeh";
    description = "Jake Hamilton";
  };
in {
  inherit (inputs) nixpkgs;
  system = "x86_64-linux";
  users.${user.name} = {
    hostKind = "personal";
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
  nixOs = {
    unfree = [
      ../nixos/hardware/unfree.nix
      ../nixos/games/unfree.nix
      ../nixos/password-manager/unfree.nix
    ];
    modules = [
      ../nixos/configuration.nix
      ../nixos/users/jakeh.nix
      ../secrets
      inputs.sops-nix.nixosModules.sops
    ];
  };
}
