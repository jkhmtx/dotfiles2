{...}: {
  config = {
    programs.brave = {
      enable = true;
      extensions = [
        {id = "aeblfdkhhhdcdjpifhhbdiojplfjncoa";}
        {id = "ddkjiahejlhfcafbddmgiahcphecmpfh";}
      ];
    };
  };
}
