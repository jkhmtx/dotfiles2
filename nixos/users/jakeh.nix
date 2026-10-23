{pkgs, ...}: {
  config = {
    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users.jakeh = {
      isNormalUser = true;
      description = "Jake Hamilton";
      extraGroups = ["networkmanager" "wheel"];
      shell = pkgs.zsh;
      openssh.authorizedKeys.keys = [
        (builtins.readFile ../../id_ed25519.pub)
      ];
    };

    services.openssh.settings.AllowUsers = ["jakeh"]; # Allows all users by default. Can be [ "user1" "user2" ]

    # Certain features, including CLI integration and system authentication support,
    # require enabling PolKit integration on some desktop environments (e.g. Plasma).
    programs._1password-gui.polkitPolicyOwners = ["jakeh"];

    systemd.tmpfiles.settings.accountsservice-jakeh."/var/lib/AccountsService/users/jakeh"."f+" = {
      mode = "0600";
      argument = "[User]\nXSession=hyprland-uwsm\n";
    };
  };
}
