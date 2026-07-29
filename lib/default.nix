{
  pkgs,
  mySpecialArgs,
  ...
} @ inputs: let
  inherit (pkgs.lib.attrsets) mapAttrs;

  consts = {
    flakeInfo = "home-manager-flake-info";
  };

  home-manager = {
    mkSymlinkAttrs = ./home-manager/mk-symlink-attrs.nix;
    storeFileName = ./home-manager/store-file-name.nix;
  };

  utils = {
    flatMap = ./utils/flat-map.nix;
  };

  importWithInputs = path:
    import path (inputs
      // {
        inherit consts;
        myLib = lib;
      });
  lib = {
    utils = mapAttrs (_: importWithInputs) utils;
    home-manager = mapAttrs (_: importWithInputs) home-manager;
  };
in
  lib
