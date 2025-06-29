{pkgs, ...}:
pkgs.writeShellApplication {
  name = "find-age-recipient";

  runtimeInputs = [
    pkgs.ssh-to-age
    pkgs._1password-cli
  ];

  text = builtins.readFile ./main.sh;
}
