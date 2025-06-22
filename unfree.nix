({
  pkgs,
  mySpecialArgs,
  ...
}: let
  inherit (mySpecialArgs) utils unfree;
  allowUnfreePredicate = pkg:
    builtins.elem (pkgs.lib.getName pkg) (utils.flatMap (path: import path {}) unfree);
in {
  config = {
    nixpkgs.config.allowUnfreePredicate = allowUnfreePredicate;
  };
})
