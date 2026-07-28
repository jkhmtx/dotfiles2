{
  pkgs,
  mySpecialArgs,
  ...
}: let
  inherit (mySpecialArgs) lib;
in
  pkgs.writeShellApplication
  {
    name = "pr.sync";

    runtimeInputs = [
      pkgs.git
      pkgs.gh
      pkgs.jq
    ];

    text = builtins.readFile ./main.sh;
  }
