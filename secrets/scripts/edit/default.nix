{pkgs, ...}:
pkgs.writeShellApplication {
  name = "edit-home-secrets";

  runtimeInputs = [
    pkgs.sops
  ];

  text = builtins.readFile ./main.sh;
}
