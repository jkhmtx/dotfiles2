{pkgs, ...}: {
  flatMap = import ./flat-map.nix {inherit pkgs;};
}
