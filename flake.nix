{
  description = "jkhmtx's HM";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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
      pkgs = import nixpkgs {
        inherit system;
        overlays = [inputs.fenix.overlays.default];
      };

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

    configs = let
      hosts = let
        content = builtins.attrNames (builtins.readDir ./hosts);
      in
        map (nixpkgs.lib.removeSuffix ".nix") content;
    in
      nixpkgs.lib.genAttrs hosts (
        host:
          mkConfiguration (import (./hosts + "/${host}" + ".nix") {inherit inputs;})
      );
  in {
    devShell.x86_64-linux = configs.nixos.devShell;
    devShell.aarch64-darwin = configs.SB-US-B0E2-jhamilton.devShell;

    homeConfigurations = builtins.mapAttrs (_: config: config.homeManagerConfiguration) configs;
    nixosConfigurations = builtins.mapAttrs (_: config: config.nixosConfiguration) configs;
  };
}
