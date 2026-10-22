{...}: {
  config = {
    environment.sessionVariables = {
      WLR_NO_HARDWARE_CURSORS = "1";
    };

    services.xserver.videoDrivers = ["nvidia"];
    hardware = {
      graphics.enable = true;
      nvidia = {
        modesetting.enable = true;
        open = false;

        # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
        # Enable this if you have graphical corruption issues or application crashes after waking
        # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead
        # of just the bare essentials.
        powerManagement.enable = true;

        # Fine-grained power management. Turns off GPU when not in use.
        # Experimental and only works on modern Nvidia GPUs (Turing or newer).
        powerManagement.finegrained = false;
        nvidiaSettings = true;
      };
    };
  };
}
