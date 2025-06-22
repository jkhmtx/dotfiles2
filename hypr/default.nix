{config, ...}: {
  config = {
    home.file = {
      "${config.home.homeDirectory}/.config/hypr/hyprland.conf" = {
        enable = true;
        force = true;
        text = builtins.readFile ./hyprland.conf;
      };
      "${config.home.homeDirectory}/.config/hypr/hypridle.conf" = {
        enable = true;
        force = true;
        text = builtins.readFile ./hypridle.conf;
      };
    };
  };
}
