{pkgs, ...}: let
  nodeModules = pkgs.importNpmLock.buildNodeModules {
    npmRoot = ./.;
    nodejs = pkgs.nodejs;
  };
  claude = pkgs.writeShellApplication {
    name = "claude";
    runtimeInputs = [pkgs.nodejs];
    runtimeEnv = {
      DISABLE_AUTOUPDATER = "1";
      NODE_MODULES = "${nodeModules}";
    };
    text = builtins.readFile ./main.sh;
  };
in {
  config = {
    home.packages = [claude];
  };
}
