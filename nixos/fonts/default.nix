{pkgs, ...}: {
  fonts.packages = (import ../../fonts) {inherit pkgs;};
}
