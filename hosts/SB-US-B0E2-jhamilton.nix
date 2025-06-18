{
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
    ../secrets
    ../shell
    ../term
    ../tmux
  ];
  unfree = [
    ../secrets/unfree.nix
  ];
  nixosModules = [];
}
