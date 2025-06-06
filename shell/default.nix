{
  pkgs,
  config,
  ...
} @ inputs: let
  fzf = pkgs.fzf;
in {
  config = {
    home.packages = [
      fzf
      pkgs.jq
      pkgs.nix-search-cli
      pkgs.ripgrep
      pkgs.tree
      pkgs.xclip
      (import ./scripts/my inputs)
    ];

    home.file = {
      "${config.home.homeDirectory}/shellcheckrc" = {
        enable = true;
        force = true;
        source = "${./shellcheckrc}";
      };
    };

    programs.fzf = {
      enable = true;
      enableZshIntegration = true;
      package = fzf;
    };

    programs.oh-my-posh = {
      enable = true;

      # Managed in programs.zsh.initExtra
      enableZshIntegration = false;
    };

    programs.zsh = {
      enable = true;

      initContent = builtins.readFile "${pkgs.callPackage ./zsh-init inputs}/bin/zsh-init";

      historySubstringSearch.enable = true;
      syntaxHighlighting.enable = true;
    };
  };
}
