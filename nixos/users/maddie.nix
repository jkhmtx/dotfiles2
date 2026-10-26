{...}: {
  config = {
    users.users.maddie = {
      isNormalUser = true;
      description = "Maddie";
      extraGroups = ["networkmanager"];
    };

    systemd.tmpfiles.settings.accountsservice-maddie."/var/lib/AccountsService/users/maddie"."f+" = {
      mode = "0600";
      argument = "[User]\nXSession=cinnamon\n";
    };
  };
}
