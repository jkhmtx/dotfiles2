{
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
    ../hyprland
    ../secrets
    ../shell
    ../term
    ../tmux
  ];
  unfree = [
    ../secrets/unfree.nix
    ../nixos/password-manager/unfree.nix
    ../nixos/games/unfree.nix
  ];
  nixosModules = [../nixos/configuration.nix];
}
