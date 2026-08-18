{
  pkgs,
  mySpecialArgs,
  ...
}: let
  inherit (mySpecialArgs) lib;
in
  pkgs.writeShellApplication
  {
    name = "claude.hooks.post-tool-use";

    runtimeInputs = [
      pkgs.jq
      pkgs.tmux
    ];

    text = builtins.readFile ./main.sh;
  }
