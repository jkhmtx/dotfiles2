{pkgs, ...}: {
  config = {
    home.packages = [
      pkgs.psmisc
    ];
  };
}
