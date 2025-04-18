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
    pkgs = nixpkgs.legacyPackages.${system};
    system = "x86_64-linux";
    allowUnfreePredicate = pkg:
      builtins.elem (pkgs.lib.getName pkg) (nixpkgs.lib.callPackage ./secrets/unfree.nix {});
  in {
    homeConfigurations."jakeh" = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;

      extraSpecialArgs = {
        inherit (self) inputs;
      };

      # Specify your home configuration modules here, for example,
      # the path to your home.nix.
      modules = [
        ./dev/direnv
        ./dev/git
        ./dev/nvim
        ./home-manager
        ./hosts/nixos.nix
        ./shell
        ./secrets
        ./term
      ];

      # Optionally use extraSpecialArgs
      # to pass through arguments to home.nix
    };

    nixpkgs.config.allowUnfreePredicate = allowUnfreePredicate;

    nixosDir = ./nixos;
  };
}
