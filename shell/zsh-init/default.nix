{pkgs, ...}:
pkgs.writeShellApplication {
  name = "zsh-init";

  bashOptions = [];

  runtimeInputs = [pkgs.oh-my-posh];

  runtimeEnv = {
    COMPLETIONS_DIR = "${../completions}";
    OH_MY_POSH_CONFIG = "${../oh-my-posh/conf.toml}";
  };

  text = builtins.readFile ./init.sh;
}
