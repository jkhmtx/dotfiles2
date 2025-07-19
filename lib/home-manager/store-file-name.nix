# Attribution: https://github.com/nix-community/home-manager/blob/7c04351a57bb36133e6cf3b609e573b9e18b8eec/modules/lib/strings.nix#L1
{pkgs, ...}:
with pkgs.lib;
  path: let
    # All characters that are considered safe. Note "-" is not
    # included to avoid "-" followed by digit being interpreted as a
    # version.
    safeChars =
      ["+" "." "_" "?" "="]
      ++ lowerChars
      ++ upperChars
      ++ stringToCharacters "0123456789";

    empties = l: genList (x: "") (length l);

    unsafeInName = stringToCharacters (
      replaceStrings safeChars (empties safeChars) path
    );

    safeName = replaceStrings unsafeInName (empties unsafeInName) path;
  in
    "hm_" + safeName
