{
  pkgs,
  secrets,
  ...
}:
pkgs.writeShellApplication
{
  name = "github-plan";

  runtimeInputs = [pkgs.git pkgs.opentofu];

  runtimeEnv = {
    GITHUB_TOKEN_FILE = secrets.githubToken.path;
  };

  text = builtins.readFile ./main.sh;
}
