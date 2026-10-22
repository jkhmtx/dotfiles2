{
  pkgs,
  config,
  ...
}: {
  config = {
    programs.hyprland = {
      enable = true;
      withUWSM = true;
    };

    xdg.portal.enable = true;
    xdg.portal.extraPortals = [pkgs.xdg-desktop-portal-gtk];
  };
}
