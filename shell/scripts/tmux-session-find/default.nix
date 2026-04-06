{
  pkgs,
  mySpecialArgs,
  ...
}: let
  inherit (mySpecialArgs) lib;
in
  pkgs.writeShellApplication
  {
    name = "tmux-session-find";

    runtimeInputs = [
      pkgs.fzf
      pkgs.tmux
    ];

    text = builtins.readFile ./main.sh;
  }
