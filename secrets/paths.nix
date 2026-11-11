{home}:
builtins.listToAttrs (map (name: {
    inherit name;
    value = "${home}/.config/sops-nix/secrets/${name}";
  }) [
    "githubToken"
    "master-gpg-secret-key"
    "master-gpg-public-key"
  ])
// {
  ssh-private-key = "${home}/.ssh/id_ed25519-sops";
}
