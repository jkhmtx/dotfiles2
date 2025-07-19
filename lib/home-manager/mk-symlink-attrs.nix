# Attribution: https://github.com/urob/dotfiles/blob/af7e2f325b4c1b6197278d6e15253c6f7976721d/lib/mkSymlinkAttrs.nix#L1
#
# This function adds and interpretes outOfStoreSymlink option to home.file attribute sets.
#
# Usage:
#   home.file = mkSymlinkAttrs {
#     .foo = { source = "foo"; outOfStoreSymlink = true; recursive = true; };
#     .bar = { source = "foo/bar"; outOfStoreSymlink = true; };
#   };
{
  pkgs,
  myLib,
  mySpecialArgs,
  ...
}: let
  inherit (mySpecialArgs) rootPath repoPath;
  inherit (pkgs) lib;

  # Swap a path inside the nix store with the same path in runtimeRoot
  runtimePath = path: let
    pathStr = toString path;
  in
    assert lib.assertMsg (lib.hasPrefix rootPath pathStr)
    "${pathStr} does not start with ${rootPath}";
      repoPath + lib.removePrefix rootPath pathStr;

  # Make outOfStoreSymlink against runtimeRoot. This replicates
  # config.lib.file.mkOutOfStoreSymlink as_mkOutOfStoreSymlink and wraps it to
  # replace the target path in the nix store with the original target path
  # inside runtimeRoot. This is necessary because flakes live in the nix store.
  mkOutOfStoreSymlink = let
    _mkOutOfStoreSymlink = path: let
      pathStr = toString path;
      name = myLib.home-manager.storeFileName (baseNameOf pathStr);
    in
      pkgs.runCommandLocal name {} ''ln -s ${lib.strings.escapeShellArg pathStr} $out'';
  in
    file: _mkOutOfStoreSymlink (runtimePath file);

  # Recursively make OutOfStoreSymlinks for all files inside path.
  mkRecursiveOutOfStoreSymlink = path: link:
    builtins.listToAttrs (
      map
      (file: {
        name = link + "${lib.removePrefix (toString path) (toString file)}";
        value = {source = mkOutOfStoreSymlink file;};
      })
      (lib.filesystem.listFilesRecursive path)
    );

  # Remove custom attributes from attribute set.
  rmopts = attrs: builtins.removeAttrs attrs ["source" "recursive" "outOfStoreSymlink"];
in
  fileAttrs:
    lib.attrsets.concatMapAttrs
    (
      name: value:
      # Make outOfStoreSymlinks
        if value.outOfStoreSymlink or false
        then
          if value.recursive or false
          then
            lib.attrsets.mapAttrs
            (_: attrs: attrs // rmopts value)
            (mkRecursiveOutOfStoreSymlink value.source name)
          else {"${name}" = {source = mkOutOfStoreSymlink value.source;} // rmopts value;}
        # Handle all other cases as usual
        else {"${name}" = value;}
    )
    fileAttrs
