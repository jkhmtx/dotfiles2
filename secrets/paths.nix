{home}:
builtins.listToAttrs (map (name: {
    inherit name;
    value = "${home}/.config/sops-nix/secrets/${name}";
  }) [
    "githubToken"
    "master-gpg-secret-key"
    "master-gpg-public-key"
    "nixos-ssh-cloudflare-access-client-id"
    "nixos-ssh-cloudflare-access-client-secret"
  ])
// {
  ssh-private-key = "${home}/.ssh/id_ed25519-sops";
}
