{pkgs, ...}: {
  config = {
    home.packages = [pkgs.musescore];
  };
}
