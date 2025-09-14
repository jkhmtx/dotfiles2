{pkgs, ...} @ args: {
  imports = [./secrets.nix];
  services.gpg-agent = {
    enable = true;
    pinentry.package = pkgs.pinentry;
    enableZshIntegration = true;
  };
  home.packages = [
    pkgs.gnupg
    pkgs.sops
    (import ./scripts/edit args)
    (import ./scripts/find-age-recipient args)
  ];
}
