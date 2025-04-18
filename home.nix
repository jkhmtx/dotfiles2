{
  pkgs,
  wellKnown,
  ...
}: {
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home = {
    inherit (wellKnown) username homeDirectory;
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.11"; # Please read the comment before changing.

  home.packages = [
    pkgs.direnv
  ];

  programs.kitty = {
    enable = true;

    shellIntegration.enableZshIntegration = true;

    themeFile = "Catppuccin-Macchiato";
  };

  programs.git = {
    enable = true;

    userEmail = "jakehamtexas@gmail.com";
    userName = "Jake Hamilton";

    ignores = [
      "*~"
      "*.swp"
    ];
  };

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (pkgs.lib.getName pkg) [
      "1password-cli"
    ];
}
