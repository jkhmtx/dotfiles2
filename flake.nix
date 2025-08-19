{
  description = "jkhmtx's HM";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nixCats = {
      url = "github:BirdeeHub/nixCats-nvim";
    };

    hyprlang-fmt = {
      url = "github:jkhmtx/hyprlang-fmt";
      inputs.nixpkgs.follows = "nixpkgs";
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
    inherit (self) inputs;

    mkConfiguration = {
      hostKind,
      modules,
      nixosModules,
      repoPath,
      system,
      unfree,
      user,
      ...
    }: let
      pkgs = nixpkgs.legacyPackages.${system};

      lib = import ./lib ({inherit pkgs;} // specialArgs);

      specialArgs = {
        mySpecialArgs = {
          rootPath = toString self;
          inherit system;
          inherit inputs;
          inherit lib;
          inherit user unfree repoPath hostKind;
        };
      };

      homeManagerConfiguration = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [./unfree.nix] ++ modules;
        extraSpecialArgs = specialArgs;
      };

      secrets = homeManagerConfiguration.config.sops.secrets;
      devShell = let
        importEach = lib.utils.flatMap (module:
          import module {
            inherit secrets;
            inherit pkgs;
          });
      in
        pkgs.mkShell {
          name = "dev";
          packages = importEach [.github/terraform/shell.nix];
          shellHook = ''
            exec zsh --login
          '';
        };
      nixosConfiguration = nixpkgs.lib.nixosSystem {
        inherit system;
        inherit specialArgs;
        modules = nixosModules ++ [./unfree.nix];
      };
    in {
      inherit devShell;
      inherit homeManagerConfiguration;
      inherit nixosConfiguration;
    };

    personal = mkConfiguration (import ./hosts/nixos.nix {inherit inputs;});
    work = mkConfiguration (import ./hosts/SB-US-B0E2-jhamilton.nix {inherit inputs;});
  in {
    devShell.x86_64-linux = personal.devShell;
    devShell.aarch64-darwin = work.devShell;

    homeConfigurations.nixos = personal.homeManagerConfiguration;
    homeConfigurations.SB-US-B0E2-jhamilton = work.homeManagerConfiguration;

    nixosConfigurations.nixos = personal.nixosConfiguration;
  };
}
