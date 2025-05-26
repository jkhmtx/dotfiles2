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
    config = host: let
      inherit (import host) system;
      pkgs = nixpkgs.legacyPackages.${system};

      inherit (pkgs.lib.lists) flatten;

      flatMap = fn: list: flatten (builtins.map fn list);

      homeManagerConfiguration = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        extraSpecialArgs = {
          inherit (self) inputs;
        };

        modules = [
          (import host).module

          ./dev/direnv
          ./dev/git
          ./dev/github
          ./dev/nvim
          ./home-manager
          ./nix
          ./secrets
          ./shell
          ./term
        ];
      };

      secrets = homeManagerConfiguration.config.sops.secrets;
      devShell = let
        importEach = flatMap (module:
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
    in {
      inherit devShell;
      inherit homeManagerConfiguration;
    };

    personal = config ./hosts/nixos.nix;
    work = config ./hosts/SB-US-B0E2-jhamilton.nix;
  in {
    devShell."x86_64-linux" = personal.devShell;
    devShell."aarch64-darwin" = work.devShell;

    homeConfigurations."jakeh" = personal.homeManagerConfiguration;
    homeConfigurations."jake" = work.homeManagerConfiguration;

    nixosDir = ./nixos;
  };
}
