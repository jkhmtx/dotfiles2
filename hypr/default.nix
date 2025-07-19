{
  config,
  mySpecialArgs,
  ...
}: let
  inherit (mySpecialArgs) lib;
  inherit (config.home) homeDirectory;
in {
  config = {
    home.file = lib.home-manager.mkSymlinkAttrs {
      "${homeDirectory}/.config/hypr/hyprland.conf" = {
        enable = true;
        force = true;
        outOfStoreSymlink = true;
        source = ./hyprland.conf;
      };
      "${homeDirectory}/.config/hypr/hypridle.conf" = {
        enable = true;
        force = true;
        outOfStoreSymlink = true;
        source = ./hypridle.conf;
      };
    };
  };
}
