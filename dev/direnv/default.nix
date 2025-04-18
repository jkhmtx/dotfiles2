{pkgs, ...}: {
  config = {
    home.packages = [
      pkgs.direnv
    ];
  };
}
