{...}: {
  config = {
    programs.git = {
      enable = true;

      userEmail = "jakehamtexas@gmail.com";
      userName = "Jake Hamilton";

      ignores = [
        "*~"
        "*.swp"
      ];
    };
  };
}
