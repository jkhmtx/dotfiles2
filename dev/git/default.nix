{pkgs, ...}: {
  config = {
    home.packages = [pkgs.delta];
    home.file = {
      ".ssh/id_ed25519.pub".text = builtins.readFile ./id_ed25519.pub;
      ".ssh/allowed_signers".text = "* ${builtins.readFile ./id_ed25519.pub}";
    };
    programs.git = {
      enable = true;

      userEmail = "jakehamtexas@gmail.com";
      userName = "Jake Hamilton";

      ignores = [
        "*~"
        "*.swp"
      ];

      includes = [{path = ./.gitconfig;}];
    };
  };
}
