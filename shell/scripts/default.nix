{pkgs, ...} @ inputs: let
  inherit (pkgs.lib.attrsets) recursiveUpdate;
  inherit (pkgs.lib.lists) fold;

  load = path: import path ({inherit self load;} // inputs);

  index = import ./index.nix;

  merge = fold recursiveUpdate {};

  loadDeep = attrs:
    builtins.mapAttrs (
      _: value:
        if builtins.isAttrs value
        then loadDeep value
        else load value
    )
    attrs;

  loadEach = map loadDeep;

  self = merge (loadEach index);

  flattened = let
    inherit (builtins) concatStringsSep removeAttrs;
    inherit (pkgs.lib.attrsets) foldlAttrs isAttrs isDerivation optionalAttrs;

    collectDerivations = path: value:
      if isDerivation value
      then {${concatStringsSep "." path} = value;}
      else optionalAttrs (isAttrs value) (flattenDerivations path value);

    flattenDerivations = path:
      foldlAttrs
      (flattenedOutputs: name: value:
        flattenedOutputs // (collectDerivations (path ++ [name]) value))
      {};
  in
    flattenDerivations [] (removeAttrs self ["utils"]);
in
  self // {inherit flattened;}
