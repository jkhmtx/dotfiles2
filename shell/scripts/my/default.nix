{
  pkgs,
  mySpecialArgs,
  ...
}: let
  inherit (mySpecialArgs) lib;
in
  pkgs.writeShellApplication
  {
    name = "my";

    runtimeInputs = [
      lib.scripts.record-home-manager-flake-metadata
      lib.scripts.find-dotfiles-dir
      pkgs.hostname
      pkgs.home-manager
    ];

    text = builtins.readFile ./main.sh;
  }
