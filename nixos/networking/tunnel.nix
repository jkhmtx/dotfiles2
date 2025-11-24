{config, ...}: {
  services.cloudflared = {
    enable = true;
    tunnels = {
      "2c37bd15-9bf3-4919-9e61-3595f9f69c5c" = {
        credentialsFile = "${config.sops.secrets.cloudflared.path}";
        default = "http_status:404";
      };
    };
  };

  # Required for ssh browser rendering
  services.openssh.settings.Macs = [
    # Current defaults:
    "hmac-sha2-512-etm@openssh.com"
    "hmac-sha2-256-etm@openssh.com"
    "umac-128-etm@openssh.com"
    # Added:
    "hmac-sha2-256"
  ];
}
