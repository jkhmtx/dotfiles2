{
  pkgs,
  mySpecialArgs,
  ...
}: {
  name,
  drv,
}:
pkgs.writeShellApplication {
  inherit name;

  runtimeInputs = [
    drv
  ];

  runtimeEnv = {
    DRV = drv.name;
    REPO_PATH = mySpecialArgs.repoPath;
    SYSTEM = mySpecialArgs.system;
  };

  text = builtins.readFile ./run.sh;
}
