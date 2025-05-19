{pkgs, ...}: {
  config = {
    home.packages = [pkgs.delta];
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
