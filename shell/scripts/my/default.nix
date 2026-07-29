{
  pkgs,
  mySpecialArgs,
  ...
}: let
  inherit (mySpecialArgs) lib;
in
  pkgs.writeShellApplication
  {
    name = "my";

    runtimeEnv = {
      DOTFILES_DIR = mySpecialArgs.repoPath;
    };

    runtimeInputs = [
      pkgs.hostname
      pkgs.home-manager
    ];

    text = builtins.readFile ./main.sh;
  }
