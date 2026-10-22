{
  pkgs,
  config,
  mySpecialArgs,
  ...
}: let
  inherit (mySpecialArgs) lib;
  inherit (config.home) homeDirectory;
  nodeModules = pkgs.importNpmLock.buildNodeModules {
    npmRoot = ./.;
    nodejs = pkgs.nodejs;
  };
  ccstatusline = import ./ccstatusline {inherit pkgs nodeModules;};
  settings = import ./settings.nix {inherit pkgs ccstatusline;};
  claude = pkgs.writeShellApplication {
    name = "claude";
    runtimeInputs = [pkgs.nodejs];
    runtimeEnv = {
      DISABLE_AUTOUPDATER = "1";
      NODE_MODULES = "${nodeModules}";
      CLAUDE_SETTINGS = "${settings}";
    };
    text = builtins.readFile ./main.sh;
  };
in {
  config = {
    home.packages = [claude ccstatusline];

    home.file = lib.home-manager.mkSymlinkAttrs {
      "${homeDirectory}/.config/ccstatusline/settings.json" = {
        enable = true;
        force = true;
        outOfStoreSymlink = true;
        source = ./ccstatusline/settings.json;
      };
    };
  };
}
