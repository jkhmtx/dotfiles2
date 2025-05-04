{...}: {
  config = {
    programs.steam = {
      enable = true;
    };

    hardware = {
      graphics.enable = true;
      nvidia.modesetting.enable = true;
    };
  };
}
