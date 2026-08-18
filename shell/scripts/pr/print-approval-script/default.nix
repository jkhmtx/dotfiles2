{
  pkgs,
  mySpecialArgs,
  ...
}: let
  inherit (mySpecialArgs) lib;
in
  pkgs.writeShellApplication
  {
    name = "pr.print-approval-script";

    runtimeInputs = [
      pkgs.coreutils
      pkgs.findutils
    ];

    text = builtins.readFile ./main.sh;
  }
