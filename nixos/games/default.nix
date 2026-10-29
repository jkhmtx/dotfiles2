{pkgs, ...}: let
  compatdata = import ./compatdata {inherit pkgs;};
in {
  config = {
    programs.steam = {
      enable = true;
      package = pkgs.steam.override {
        extraPreBwrapCmds = ''
          mapfile -t compatdata_binds < <(${pkgs.lib.getExe compatdata})
        '';
        extraBwrapArgs = [
          "\"\${compatdata_binds[@]}\""
        ];
      };
    };

    users.groups.steamlibrary = {};
  };
}
