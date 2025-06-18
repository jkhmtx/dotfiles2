{pkgs, ...} @ inputs: let
  inherit (pkgs.lib.attrsets) mapAttrs;

  consts = {
    flakeInfo = "home-manager-flake-info";
  };

  scripts = {
    find-dotfiles-dir = ./scripts/find-dotfiles-dir;
    record-home-manager-flake-metadata = ./scripts/record-home-manager-flake-metadata;
  };

  importWithInputs = path: import path (inputs // {inherit consts;});
in {
  scripts = mapAttrs (_: importWithInputs) scripts;
}
