{pkgs}:
pkgs.writeShellApplication {
  name = "steam-compatdata-binds";

  runtimeInputs = [
    pkgs.coreutils
    pkgs.gnugrep
  ];

  text = builtins.readFile ./main.sh;
}
