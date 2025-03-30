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
    # It's also possible to use a ssh key, but only when it has no password:
    age.sshKeyPaths = ["${wellKnown.homeDirectory}/.ssh/id_ed25519"];
    defaultSopsFile = ./secrets.yaml;
    # secrets.test = {
    #   # sopsFile = ./secrets.yml.enc; # optionally define per-secret files
    #
    #   # %r gets replaced with a runtime directory, use %% to specify a '%'
    #   # sign. Runtime dir is $XDG_RUNTIME_DIR on linux and $(getconf
    #   # DARWIN_USER_TEMP_DIR) on darwin.
    #   path = "%r/test.txt";
    # };
  };
}
# The secrets are decrypted in a systemd user service called sops-nix, so other services needing secrets must order after it:
#
# {
#   systemd.user.services.mbsync.unitConfig.After = [ "sops-nix.service" ];
# }

