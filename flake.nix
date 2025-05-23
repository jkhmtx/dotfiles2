{
  description = "Home Manager configuration of jakeh";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nixCats = {
      url = "github:BirdeeHub/nixCats-nvim";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  }: let
    pkgsOf = system: nixpkgs.legacyPackages.${system};

    homeManagerConfigurationOf = system: host:
      home-manager.lib.homeManagerConfiguration {
        pkgs = pkgsOf system;

        extraSpecialArgs = {
          inherit (self) inputs;
        };

        modules = [
          ./dev/direnv
          ./dev/git
          ./dev/github
          ./dev/nvim
          ./home-manager
          host
          ./nix
          ./secrets
          ./shell
          ./term
        ];
      };

    mkZshShell = system: shell: let
      pkgs = pkgsOf system;
    in
      pkgs.mkShell {
        shellHook = ''
          ${shell}/bin/${shell.name}

          exec zsh --login
        '';
      };

    flatMapOf = system: let
      pkgs = pkgsOf system;
      inherit (pkgs.lib.lists) flatten;
    in
      fn: list: flatten (builtins.map fn list);

    mkDirenv = {
      system,
      inputs,
    }: shellModules: let
      pkgs = pkgsOf system;
      flatMap = flatMapOf system;
      modulesOf = module:
        import module (inputs
          // {
            pkgs = pkgsOf system;
          });
      paths = flatMap modulesOf shellModules;
    in
      pkgs.symlinkJoin {
        name = "direnv";
        inherit paths;
      };

    personalSecretsOf = system: (homeManagerConfigurationOf system).config.sops.secrets;
    mkDirenvOf = system:
      mkDirenv {
        inherit system;
        inputs = {secrets = personalSecretsOf system;};
      } [.github/terraform/shell.nix];

    personalHomeManagerConfiguration = homeManagerConfigurationOf "x86_64-linux" ./hosts/nixos.nix;
    workHomeManagerConfiguration = homeManagerConfigurationOf "aarch64-darwin" ./hosts/SB-US-B0E2-jhamilton.nix;
  in {
    packages."x86_64-linux".dotfiles = mkZshShell "x86_64-linux" personalHomeManagerConfiguration.activationPackage;

    packages."x86_64-linux".direnv = mkDirenvOf "x86_64-linux";

    packages."aarch64-darwin".dotfiles = mkZshShell "aarch64-darwin" workHomeManagerConfiguration.activationPackage;

    packages."aarch64-darwin".direnv = mkDirenvOf "aarch64-darwin";

    homeConfigurations."jakeh" = personalHomeManagerConfiguration;
    homeConfigurations."jake" = workHomeManagerConfiguration;

    nixosDir = ./nixos;
  };
}
