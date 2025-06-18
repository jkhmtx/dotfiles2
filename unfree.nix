({
  pkgs,
  unfree,
  ...
}: let
  utils = import ./lib/utils {inherit pkgs;};
  allowUnfreePredicate = pkg:
    builtins.elem (pkgs.lib.getName pkg) (utils.flatMap (path: import path {}) unfree);
in {
  config = {
    nixpkgs.config.allowUnfreePredicate = allowUnfreePredicate;
  };
})
