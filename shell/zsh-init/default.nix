{
  pkgs,
  lib,
  config,
  ...
}: let
  direnv = lib.optionals config.programs.direnv.enable [pkgs.direnv];
in
  pkgs.writeShellApplication {
    name = "zsh-init";

    bashOptions = [];

    runtimeInputs = [pkgs.oh-my-posh] ++ direnv;

    runtimeEnv = {
      COMPLETIONS_DIR = "${../completions}";
      OH_MY_POSH_CONFIG = "${../oh-my-posh/conf.toml}";
    };

    text = builtins.readFile ./init.sh;
  }
