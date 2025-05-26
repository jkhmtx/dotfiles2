{pkgs, ...}: {
  config = {
    home.packages = [
      pkgs.gh
      pkgs.renovate
    ];
  };
}
