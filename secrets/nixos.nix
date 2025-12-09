{pkgs, ...}: {
  config = {
    services.gpg-agent = {
      enable = true;
      pinentry.package = pkgs.pinentry-rofi;
      enableZshIntegration = true;
    };
  };
}
