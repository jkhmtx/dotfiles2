{...}: {
  config = {
    programs.kitty = {
      enable = true;

      shellIntegration.enableZshIntegration = true;

      themeFile = "Catppuccin-Macchiato";

      keybindings = {
        "ctrl+shift+q" = "no_op";
      };
    };
  };
}
