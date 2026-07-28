{
  pkgs,
  mySpecialArgs,
  ...
}: let
  inherit (mySpecialArgs) lib;
in
  pkgs.writeShellApplication
  {
    name = "pr.approve";

    runtimeInputs = [
      pkgs.gh
      pkgs.jq
    ];

    text = builtins.readFile ./main.sh;
  }
