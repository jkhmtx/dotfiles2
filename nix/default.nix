{pkgs, ...}: {
  config = {
    home.packages = [
      pkgs.nix-search-cli
    ];
  };
}
