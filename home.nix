{
  config,
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
    pkgs.ssh-to-age
    pkgs.sops
    pkgs.xclip
    pkgs._1password-cli
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
  };

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

  programs.oh-my-posh = {
    enable = true;

    # Managed in programs.zsh.initExtra
    enableZshIntegration = false;
  };

  home.sessionPath = [
    "${config.home.homeDirectory}/dotfiles/shell/path"
  ];

  programs.zsh = {
    enable = true;

    initExtra = ''
      # Prompt theming
      eval "$(${pkgs.oh-my-posh}/bin/oh-my-posh init zsh --config ${./shell/oh-my-posh/conf.toml})"

      # Completions
      source ${./shell/completions/op.sh}
    '';
  };

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (pkgs.lib.getName pkg) [
      "1password-cli"
    ];
}
