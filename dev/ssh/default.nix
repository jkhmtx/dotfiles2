{
  pkgs,
  config,
  ...
}: {
  config = {
    home.packages = [pkgs.cloudflared];
    home.file = {
      ".ssh/id_ed25519.pub".text = builtins.readFile ../../id_ed25519.pub;
    };

    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;
      includes = [
        (builtins.toString (pkgs.replaceVars ./config {
          cloudflared = pkgs.lib.getExe pkgs.cloudflared;
          identityFile = config.sops.secrets.ssh-private-key.path;
          port = 8899;
        }))
      ];
    };
  };
}
