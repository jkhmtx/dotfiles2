{pkgs, ...}: {
  config = {
    home.packages = [pkgs.delta];
    home.file = {
      ".ssh/allowed_signers".text = "* ${builtins.readFile ../../id_ed25519.pub}";
    };
    programs.git = {
      enable = true;

      signing.format = "ssh";

      ignores = [
        "*.swp"
        "*~"
        ".DS_Store"
        ".direnv"
        ".terraform"
        "result"
      ];

      includes = [{path = ./.gitconfig;}];
    };
  };
}
