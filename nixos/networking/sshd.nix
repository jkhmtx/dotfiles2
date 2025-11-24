{...}: {
  config = {
    services.openssh = {
      enable = true;
      ports = [8899];
      settings = {
        LogLevel = "VERBOSE";
        PasswordAuthentication = false;
        AllowUsers = ["jakeh"]; # Allows all users by default. Can be [ "user1" "user2" ]
        UseDns = true;
        X11Forwarding = false;
        PermitRootLogin = "no"; # "yes", "without-password", "prohibit-password", "forced-commands-only", "no"
      };
    };

    users.users.jakeh.openssh.authorizedKeys.keys = [
      (builtins.readFile ../../id_ed25519.pub)
    ];
  };
}
