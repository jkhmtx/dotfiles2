{...}: {
  config = {
    sops = {
      age.sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
      defaultSopsFile = ./machine.yaml;
      secrets.home-wifi-password = {};
      secrets.cloudflared = {};
    };
  };
}
