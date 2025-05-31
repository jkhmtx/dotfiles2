{
  consts,
  pkgs,
  ...
}:
pkgs.writeShellApplication
{
  name = "record-home-manager-flake-metadata";

  runtimeInputs = [
    pkgs.git
    pkgs.jq
  ];

  runtimeEnv = {
    FLAKE_INFO = consts.flakeInfo;
  };

  text = builtins.readFile ./main.sh;
}
