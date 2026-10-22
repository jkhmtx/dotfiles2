{
  pkgs,
  nodeModules,
}:
pkgs.writeShellApplication {
  name = "claude.statusline";
  runtimeInputs = [pkgs.nodejs];
  runtimeEnv = {
    NODE_MODULES = "${nodeModules}";
  };
  text = builtins.readFile ./main.sh;
}
