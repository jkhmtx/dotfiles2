{
  pkgs,
  secrets,
  ...
}:
pkgs.writeShellApplication
{
  name = "github-apply";

  runtimeInputs = [pkgs.git pkgs.opentofu];

  runtimeEnv = {
    GITHUB_TOKEN_FILE = secrets.githubToken.path;
  };

  text = builtins.readFile ./main.sh;
}
