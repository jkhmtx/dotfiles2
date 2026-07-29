{...}: {
  config = {
    programs.kitty = {
      enable = true;

      shellIntegration.enableZshIntegration = true;

      themeFile = "Catppuccin-Macchiato";

      extraConfig = builtins.readFile ./kitty.conf;
    };
  };
}
