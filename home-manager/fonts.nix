{pkgs, ...}: {
  home.packages = (import ../fonts) {inherit pkgs;};
}
