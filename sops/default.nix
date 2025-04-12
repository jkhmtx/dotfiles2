{
  config,
  lib,
  inputs,
  wellKnown,
  ...
}: {
  imports = [
    inputs.sops-nix.homeManagerModules.sops
  ];

  sops = {
    age.sshKeyPaths = ["${wellKnown.homeDirectory}/.ssh/id_ed25519"];
    defaultSopsFile = ./secrets.yaml;
    secrets.test = {};
  };
}
# The secrets are decrypted in a systemd user service called sops-nix, so other services needing secrets must order after it:
#
# {
#   systemd.user.services.mbsync.unitConfig.After = [ "sops-nix.service" ];
# }

