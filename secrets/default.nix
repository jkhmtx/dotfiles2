{...}: {
  config = {
    sops = {
      age.sshKeyPaths = ["/home/jakeh/.ssh/id_ed25519"];
      defaultSopsFile = ./secrets.yaml;
      secrets.home-wifi-password = {};
      secrets.cloudflared = {};
    };
  };
}
