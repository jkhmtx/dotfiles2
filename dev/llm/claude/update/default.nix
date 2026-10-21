{
  pkgs,
  mySpecialArgs,
  ...
}: let
  claudeUpdate = pkgs.writeShellApplication {
    name = "claude.update";
    runtimeInputs = [pkgs.nodejs];

    runtimeEnv = {
      DOTFILES_DIR = mySpecialArgs.repoPath;
    };

    text = builtins.readFile ./main.sh;
  };
in {
  config = {
    home.packages = [claudeUpdate];
  };
}
