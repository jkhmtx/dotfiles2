{config, ...}: {
  networking.networkmanager = {
    enable = true;

    ensureProfiles = {
      secrets.entries = [
        {
          file = config.sops.secrets.home-wifi-password.path;
          key = "psk";

          matchId = "home-wifi";
        }
      ];

      profiles.home-wifi = {
        connection = {
          type = "wifi";
          id = "home-wifi";
        };

        wifi.ssid = "Hamilton-5G";
        wifi-security = {
          key-mgmt = "wpa-psk";
        };
      };
    };
  };
}
