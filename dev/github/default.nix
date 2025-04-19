{pkgs, ...}: {
  config = {
    home.packages = [
      pkgs.renovate
    ];
  };
}
