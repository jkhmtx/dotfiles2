{pkgs, ...}:
pkgs.writeShellApplication
{
  name = "aliased.git.rebase";

  runtimeInputs = [
    pkgs.git
  ];

  text = builtins.readFile ./main.sh;
}
