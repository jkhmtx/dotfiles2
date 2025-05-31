{
  config,
  pkgs,
  ...
}: {
  config = {
    home.packages = [pkgs.borgbackup];

    programs.borgmatic = {
      enable = true;

      backups = {
        nixos = {
          location = {
            patterns = [
              "R ${config.home.homeDirectory}"

              # FHS
              "- **/.cache"
              "- **/.local"
              "- **/Downloads"
              "- **/Templates"

              # Terraform
              "- **/.terraform.d"
              "- **/.terraform"

              # Rust
              "- **/.cargo"
              "- **/debug"
              "- **/target"

              # Vim
              "- **/*~"
              "- **/*.swp"
              "- **/*.swo"

              # Nix
              "- **/result"
              "- **/result-*"
              "- **/.direnv"

              # NixOS
              "- /nix/store"
              "- /nix/var"

              # Node
              "- **/node_modules"
              "- **/.pnp"
              "- **/.npm"

              # Projects in VCS
              "- ${config.home.homeDirectory}/projects"

              # Misc
              "- **/*.tmp"
              "- **/coverage"
              "- **/.git"
              "- **/.mozilla"
              "- **/.tmux/resurrect/*.txt"
            ];
            repositories = [
              {
                label = "local";
                path = "/var/lib/backups/local.borg";
              }
            ];
          };
          consistency.checks = [
            {
              name = "repository";
              frequency = "2 weeks";
            }
            {
              name = "archives";
              frequency = "4 weeks";
            }
            {
              name = "data";
              frequency = "6 weeks";
            }
            {
              name = "extract";
              frequency = "6 weeks";
            }
          ];
        };
      };
    };
  };
}
