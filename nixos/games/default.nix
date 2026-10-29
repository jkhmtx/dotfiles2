{...}: {
  config = {
    programs.steam = {
      enable = true;
    };

    users.groups.steamlibrary = {};
  };
}
