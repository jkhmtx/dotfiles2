{
  pkgs,
  scripts,
  ...
}:
pkgs.writeShellApplication
{
  name = "my";

  runtimeInputs = [
    pkgs.home-manager
    scripts.record-home-manager-flake-metadata
    scripts.find-dotfiles-dir
  ];

  text = builtins.readFile ./main.sh;
}
