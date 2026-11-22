{
  pkgs,
  mySpecialArgs,
  ...
}: let
  sfkUpdate = pkgs.writeShellApplication {
    name = "sfk.update";
    runtimeInputs = [pkgs.curl pkgs.jq];

    runtimeEnv = {
      DOTFILES_DIR = mySpecialArgs.repoPath;
    };

    text = builtins.readFile ./main.sh;
  };
in {
  config = {
    home.packages = [sfkUpdate];
  };
}
