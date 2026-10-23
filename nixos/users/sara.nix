{...}: {
  config = {
    users.users.sara = {
      isNormalUser = true;
      description = "Sara";
      extraGroups = ["networkmanager"];
    };
  };
}
