{
  system = "x86_64-linux";
  module = {pkgs, ...}: let
    unfreePnames = import ../secrets/unfree.nix {};

    allowUnfreePredicate = pkgs: pkg:
      builtins.elem (pkgs.lib.getName pkg) unfreePnames;
  in {
    config = {
      home.username = "jakeh";
      home.homeDirectory = "/home/jakeh";

      nixpkgs.config.allowUnfreePredicate = allowUnfreePredicate pkgs;
    };
  };
}
