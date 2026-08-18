{pkgs, ...}:
pkgs.writeShellApplication
{
  name = "aliased.git.rebase.interactive";

  runtimeInputs = [
    pkgs.git
  ];

  text = builtins.readFile ./main.sh;
}
