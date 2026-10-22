{
  description = "jkhmtx's HM";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # nixpkgs-local.url = "git+file:///home/jakeh/projects/nixpkgs";
    nixpkgs-work.url = "github:nixos/nixpkgs/nixos-unstable";

    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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
    inherit (self) inputs;

    mkConfiguration = {
      nixOs,
      nixpkgs,
      system,
      users,
      ...
    }: let
      pkgs = import nixpkgs {
        inherit system;
        overlays = [inputs.fenix.overlays.default];
      };

      mkSpecialArgs = args: let
        lib = import ./lib ({inherit pkgs;} // specialArgs);

        specialArgs = {
          mySpecialArgs =
            {
              rootPath = toString self;
              inherit system;
              inherit inputs;
              inherit lib;
            }
            // args;
        };
      in
        specialArgs;

      mkUser = {
        modules,
        repoPath,
        unfree,
        user,
        ...
      }: let
        specialArgs = mkSpecialArgs {inherit user unfree repoPath;};
        inherit (specialArgs.mySpecialArgs) lib;

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
        scripts = import ./shell/scripts {
          inherit pkgs;
          inherit (specialArgs) mySpecialArgs;
        };
      in {
        inherit devShell;
        inherit homeManagerConfiguration;
        inherit scripts;
      };

      nixosConfiguration =
        if nixOs != null
        then
          nixpkgs.lib.nixosSystem {
            inherit system;
            specialArgs = mkSpecialArgs {unfree = nixOs.unfree or [];};
            modules = nixOs.modules ++ [./unfree.nix];
          }
        else null;
    in {
      inherit nixosConfiguration;
      users = builtins.mapAttrs (_: mkUser) users;
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
    devShell.x86_64-linux = configs.nixos.users.jakeh.devShell;
    devShell.aarch64-darwin = configs.SB-US-B0E2-jhamilton.users.jake.devShell;

    homeConfigurations = nixpkgs.lib.concatMapAttrs (host: config:
      nixpkgs.lib.mapAttrs' (name: user: nixpkgs.lib.nameValuePair "${name}@${host}" user.homeManagerConfiguration) config.users)
    configs;
    nixosConfigurations = nixpkgs.lib.filterAttrs (_: config: config != null) (builtins.mapAttrs (_: config: config.nixosConfiguration) configs);

    scripts.x86_64-linux.default = configs.nixos.users.jakeh.scripts;
    scripts.aarch64-darwin.default = configs.SB-US-B0E2-jhamilton.users.jake.scripts;
  };
}
