{inputs, ...}: {
  system = "aarch64-darwin";
  user = {
    name = "jake";

    home = "/Users/jake";
    description = null;
  };
  modules = [
    ../dev/direnv
    ../dev/git
    ../dev/github
    ../dev/nvim
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
