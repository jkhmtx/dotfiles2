{pkgs, ...}: {
  config = {
    home.packages = [pkgs.delta];
    home.file = {
      ".ssh/allowed_signers".text = "* ${builtins.readFile ../../id_ed25519.pub}";
    };
    programs.git = {
      enable = true;

      settings.user = {
        email = "jakehamtexas@gmail.com";
        name = "Jake Hamilton";
      };

      ignores = [
        "*~"
        "*.swp"
      ];

      includes = [{path = ./.gitconfig;}];
    };
  };
}
