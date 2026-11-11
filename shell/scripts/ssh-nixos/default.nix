{
  pkgs,
  mySpecialArgs,
  ...
}:
pkgs.writeShellApplication {
  name = "ssh-nixos";

  runtimeInputs = [
    pkgs.cloudflared
    pkgs.openssh
  ];

  runtimeEnv = {
    CLIENT_ID_FILE = mySpecialArgs.secrets.nixos-ssh-cloudflare-access-client-id;
    CLIENT_SECRET_FILE = mySpecialArgs.secrets.nixos-ssh-cloudflare-access-client-secret;
  };

  text = builtins.readFile ./main.sh;
}
