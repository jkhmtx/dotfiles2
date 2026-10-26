{...}: {
  config = {
    users.users.lucy = {
      isNormalUser = true;
      description = "Lucy";
      extraGroups = ["networkmanager"];
    };

    systemd.tmpfiles.settings.accountsservice-lucy."/var/lib/AccountsService/users/lucy"."f+" = {
      mode = "0600";
      argument = "[User]\nXSession=cinnamon\n";
    };
  };
}
