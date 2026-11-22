{
  pkgs,
  lib,
  ...
}: let
  release = builtins.fromJSON (builtins.readFile ./release.json);
  platform = "darwin-aarch64";
  sfk = pkgs.stdenvNoCC.mkDerivation {
    pname = "sfk";
    inherit (release) version;
    src = pkgs.fetchurl {
      url = "https://github.com/starfolkai/cli/releases/download/v${release.version}/sfk-${platform}.tar.gz";
      inherit (release) hash;
    };
    sourceRoot = ".";
    installPhase = ''
      install -Dm755 sfk-${platform} $out/bin/sfk
    '';
  };
  urlHandlerTools = pkgs.runCommand "sfk-url-handler-tools" {} ''
    mkdir -p $out/bin
    for tool in codesign iconutil sips; do
      ln -s /usr/bin/$tool $out/bin/$tool
    done
  '';
in {
  imports = [./update];

  config = {
    home.packages = [sfk];

    home.activation.sfkUrlHandler = lib.hm.dag.entryAfter ["writeBoundary"] ''
      run env PATH="${urlHandlerTools}/bin:$PATH" ${sfk}/bin/sfk setup url --quiet
    '';
  };
}
