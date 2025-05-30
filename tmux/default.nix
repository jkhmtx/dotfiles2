{
  pkgs,
  config,
  ...
}: let
  zshPackage = config.programs.zsh.package;

  shell = "${zshPackage}/bin/zsh";
in {
  config = {
    programs.tmux = {
      enable = true;

      baseIndex = 1;

      aggressiveResize = true;

      # Automatically spawn a session if trying to attach and none are running.
      newSession = true;

      shortcut = "a";

      # Recommended by `require(vim.health).check()`
      focusEvents = true;

      keyMode = "vi";

      inherit shell;
      terminal = "tmux-256color";
      historyLimit = 100000;

      escapeTime = 10;

      plugins = [
        pkgs.tmuxPlugins.vim-tmux-navigator
        {
          plugin = pkgs.tmuxPlugins.catppuccin;
          extraConfig = builtins.readFile ./tmux.catppuccin.conf;
        }
        pkgs.tmuxPlugins.continuum
        {
          plugin = pkgs.tmuxPlugins.resurrect;
          extraConfig = "set -g @resurrect-strategy-nvim 'session'";
        }
      ];

      extraConfig = builtins.readFile ./tmux.conf;
    };
  };
}
