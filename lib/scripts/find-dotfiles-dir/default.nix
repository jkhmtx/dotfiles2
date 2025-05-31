{
  consts,
  pkgs,
  ...
}:
pkgs.writeShellApplication
{
  name = "find-dotfiles-dir";

  runtimeInputs = [
    pkgs.coreutils
    pkgs.findutils
  ];

  runtimeEnv = {
    FLAKE_INFO = consts.flakeInfo;
  };

  text = builtins.readFile ./main.sh;
}
