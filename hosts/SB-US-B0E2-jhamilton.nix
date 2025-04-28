{pkgs, ...}: let
  unfreePnames = import ../secrets/unfree.nix {};

  allowUnfreePredicate = pkgs: pkg:
    builtins.elem (pkgs.lib.getName pkg) unfreePnames;
in {
  config = {
    home.username = "jake";
    home.homeDirectory = "/Users/jake";

    nixpkgs.config.allowUnfreePredicate = allowUnfreePredicate pkgs;
  };
}
