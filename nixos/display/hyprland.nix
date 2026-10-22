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

    security.pam.services.hyprlock = {};

    xdg.portal.enable = true;
    xdg.portal.extraPortals = [pkgs.xdg-desktop-portal-gtk];
  };
}
