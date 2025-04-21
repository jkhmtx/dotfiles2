{
  inputs,
  pkgs,
  lib,
  config,
  ...
} @ args: {
  imports = [
    inputs.sops-nix.homeManagerModules.sops
  ];

  options = {
    secrets.enable = lib.mkIf config.secrets.enable "enable secrets";
  };

  config = {
    sops = {
      age.sshKeyPaths = ["${config.home.homeDirectory}/.ssh/id_ed25519"];
      defaultSopsFile = ./secrets.yaml;
      secrets.test = {};
      secrets.githubToken = {};
    };
    home.packages = [
      pkgs.sops
      pkgs.ssh-to-age
      pkgs._1password-cli
      (import ./scripts/edit args)
    ];
  };
}
# The secrets are decrypted in a systemd user service called sops-nix, so other services needing secrets must order after it:
#
# {
#   systemd.user.services.mbsync.unitConfig.After = [ "sops-nix.service" ];
# }

