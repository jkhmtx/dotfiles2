{pkgs, ...} @ args: {
  imports = [./secrets.nix];
  home.packages = [
    pkgs.gnupg
    pkgs.sops
    (import ./scripts/edit args)
    (import ./scripts/find-age-recipient args)
  ];
}
