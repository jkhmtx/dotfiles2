{pkgs, ...} @ inputs: let
  inherit (pkgs.lib.attrsets) recursiveUpdate;

  load = path: import path ({inherit self load;} // inputs);

  index = import ./index.nix;

  # Flatten index entries into {attrPathParts = [string]; fsPath = path;} records
  flattenEntries = entries: let
    flattenEntries' = pathNameParts: attrs:
      builtins.concatLists (
        pkgs.lib.attrsets.mapAttrsToList (
          name: value: let
            nextParts = pathNameParts ++ [name];
          in
            if builtins.isAttrs value
            then flattenEntries' nextParts value
            else [
              {
                attrPathParts = nextParts;
                fsPath = value;
              }
            ]
        )
        attrs
      );
  in
    builtins.concatLists (map (flattenEntries' []) entries);

  # Set value at attrPathParts in acc, preserving siblings at intermediate levels
  setPath = attrPath: value: acc:
    if attrPath == []
    then value
    else let
      head = builtins.head attrPath;
      tail = builtins.tail attrPath;
    in
      acc // {${head} = setPath tail value (acc.${head} or {});};

  # Build self bottom-up: sort deepest paths first so children are placed
  # before parents; when a parent derivation is encountered, merge it with
  # any children already at that path via recursiveUpdate drv children.
  self = builtins.foldl' (
    acc: entry: let
      existing = pkgs.lib.attrsets.attrByPath entry.attrPathParts null acc;
      drv = load entry.fsPath;
      merged =
        if builtins.isAttrs existing
        then recursiveUpdate drv existing
        else drv;
    in
      setPath entry.attrPathParts merged acc
  ) {} (builtins.sort (a: b: builtins.length a.attrPathParts > builtins.length b.attrPathParts) (flattenEntries index));

  # Build flattened directly from index entries so nested derivations
  # (e.g. aliased.git.rebase.interactive) are included without recursing
  # into derivation internals.
  flattened = let
    nonUtils = builtins.filter (e: builtins.head e.attrPathParts != "utils") (flattenEntries index);
  in
    builtins.listToAttrs (
      map (entry: {
        name = builtins.concatStringsSep "." entry.attrPathParts;
        value = pkgs.lib.attrsets.attrByPath entry.attrPathParts null self;
      })
      nonUtils
    );
in
  self // {inherit flattened;}
