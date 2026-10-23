{pkgs, ...} @ args:
pkgs.writeShellApplication {
  name = "find-age-recipient";

  runtimeInputs =
    [
      pkgs.ssh-to-age
      (import ../check-ssh-key args)
    ]
    ++ pkgs.lib.optional pkgs.stdenv.isDarwin pkgs._1password-cli;

  text = builtins.readFile ./main.sh;
}
