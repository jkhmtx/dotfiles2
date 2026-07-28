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
      pkgs.bat
      pkgs.fzf
      pkgs.tmux
      pkgs.parallel
    ];

    text = builtins.readFile ./main.sh;
  }
