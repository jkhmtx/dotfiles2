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
    mkConfiguration = {
      system,
      user,
      modules,
      unfree,
      nixosModules,
      ...
    }: let
      pkgs = nixpkgs.legacyPackages.${system};

      inherit (import ./lib {inherit pkgs;}) scripts;

      utils = import ./lib/utils {inherit pkgs;};
      specialArgs = {
        inherit (self) inputs;
        inherit scripts utils;
        inherit user unfree;
      };

      homeManagerConfiguration = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [./unfree.nix] ++ modules;
        extraSpecialArgs = specialArgs;
      };

      secrets = homeManagerConfiguration.config.sops.secrets;
      devShell = let
        importEach = utils.flatMap (module:
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
        specialArgs = {
          inherit (self) inputs;
          inherit user unfree;
        };
        modules = nixosModules ++ [./unfree.nix];
      };
    in {
      inherit devShell;
      inherit homeManagerConfiguration;
      inherit nixosConfiguration;
    };

    personal = mkConfiguration (import ./hosts/nixos.nix);
    work = mkConfiguration (import ./hosts/SB-US-B0E2-jhamilton.nix);
  in {
    devShell.x86_64-linux = personal.devShell;
    devShell.aarch64-darwin = work.devShell;

    homeConfigurations.nixos = personal.homeManagerConfiguration;
    homeConfigurations.SB-US-B0E2-jhamilton = work.homeManagerConfiguration;

    nixosConfigurations.nixos = personal.nixosConfiguration;
  };
}
