{pkgs, ...}: let
  inherit (pkgs.lib.lists) flatten;
in
  fn: list: flatten (map fn list)
