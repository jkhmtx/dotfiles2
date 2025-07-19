({
  pkgs,
  mySpecialArgs,
  ...
}: let
  inherit (mySpecialArgs) lib unfree;
  allowUnfreePredicate = pkg:
    builtins.elem (pkgs.lib.getName pkg) (lib.utils.flatMap (path: import path {}) unfree);
in {
  config = {
    nixpkgs.config.allowUnfreePredicate = allowUnfreePredicate;
  };
})
