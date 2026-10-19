{
  pkgs,
  mySpecialArgs,
  ...
}: let
  inherit (mySpecialArgs) lib;
in
  pkgs.writeShellApplication
  {
    name = "tmux-window-move-session";

    runtimeInputs = [
      pkgs.coreutils
      pkgs.tmux
    ];

    text = builtins.readFile ./main.sh;
  }
