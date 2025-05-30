{pkgs, ...}:
pkgs.writeShellApplication
{
  name = "hm";

  runtimeInputs = [
    pkgs.coreutils
    pkgs.findutils
    pkgs.home-manager
    pkgs.jq
  ];

  text = builtins.readFile ./main.sh;
}
