{pkgs, ...}:
pkgs.writeShellApplication {
  name = "check-ssh-key";

  runtimeInputs =
    [
      pkgs.openssh
      pkgs.sops
      pkgs.ssh-to-age
    ]
    ++ pkgs.lib.optional pkgs.stdenv.isDarwin pkgs._1password-cli;

  runtimeEnv = {
    SOPS_CONFIG = "${../../.sops.yaml}";
    SOPS_FILE = "${../../secrets.yaml}";
    PUBLIC_KEY = "${../../../id_ed25519.pub}";
  };

  text = builtins.readFile ./main.sh;
}
