{...}: {
  config = {
    users.users.sara = {
      isNormalUser = true;
      description = "Sara";
      extraGroups = ["networkmanager"];
    };

    systemd.tmpfiles.settings.accountsservice-sara."/var/lib/AccountsService/users/sara"."f+" = {
      mode = "0600";
      argument = "[User]\nXSession=cinnamon\n";
    };
  };
}
