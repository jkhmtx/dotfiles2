{pkgs, ...}: let
  inherit (pkgs.lib.lists) flatten;
  inherit (builtins) map;
in
  fn: list: flatten (map fn list)
