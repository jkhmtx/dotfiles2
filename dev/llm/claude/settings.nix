{
  pkgs,
  ccstatusline,
}:
pkgs.writeText "claude-settings.json" (builtins.toJSON {
  statusLine = {
    type = "command";
    command = pkgs.lib.getExe ccstatusline;
    padding = 0;
  };
})
