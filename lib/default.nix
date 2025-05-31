{pkgs, ...} @ inputs: let
  inherit (pkgs.lib.attrsets) mapAttrs;

  consts = {
    flakeInfo = "home-manager-flake-info";
  };

  scripts = {
    find-dotfiles-dir = ./scripts/find-dotfiles-dir;
    record-home-manager-flake-metadata = ./scripts/record-home-manager-flake-metadata;
  };

  utils = {
    flatMap = ./utils/flat-map.nix;
  };

  importWithInputs = path: import path (inputs // {inherit consts;});
in {
  utils = mapAttrs (_: importWithInputs) utils;
  scripts = mapAttrs (_: importWithInputs) scripts;
}
