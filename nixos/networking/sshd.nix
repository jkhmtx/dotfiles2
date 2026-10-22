{...}: {
  config = {
    services.openssh = {
      enable = true;
      ports = [8899];
      settings = {
        LogLevel = "VERBOSE";
        PasswordAuthentication = false;
        UseDns = true;
        X11Forwarding = false;
        PermitRootLogin = "no"; # "yes", "without-password", "prohibit-password", "forced-commands-only", "no"
      };
    };
  };
}
