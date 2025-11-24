{
  lib,
  config,
  mySpecialArgs,
  ...
}: let
  inherit (mySpecialArgs.user) home;
in {
  options = {
    secrets.enable = lib.mkIf config.secrets.enable "enable secrets";
  };

  config = {
    sops = {
      age.sshKeyPaths = ["${home}/.ssh/id_ed25519"];
      defaultSopsFile = ./secrets.yaml;
      secrets.githubToken = {};
      secrets.home-wifi-password = {};
      secrets.master-gpg-secret-key = {};
      secrets.master-gpg-public-key = {};
      secrets.cloudflared = {};
      secrets.ssh-private-key = {
        path = "~/.ssh/id_ed25519";
      };
    };
  };
}
# The secrets are decrypted in a systemd user service called sops-nix, so other services needing secrets must order after it:
#
# {
#   systemd.user.services.mbsync.unitConfig.After = [ "sops-nix.service" ];
# }

