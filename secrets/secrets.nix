{mySpecialArgs, ...}: let
  inherit (mySpecialArgs.user) home;
in {
  config = {
    sops = {
      age.sshKeyPaths = ["${home}/.ssh/id_ed25519"];
      defaultSopsFile = ./secrets.yaml;
      secrets = builtins.mapAttrs (_: path: {inherit path;}) mySpecialArgs.secrets;
    };
  };
}
# The secrets are decrypted in a systemd user service called sops-nix, so other services needing secrets must order after it:
#
# {
#   systemd.user.services.mbsync.unitConfig.After = [ "sops-nix.service" ];
# }

