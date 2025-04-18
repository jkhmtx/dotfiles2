{
  description = "Home Manager configuration of jakeh";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
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
    wellKnown = (pkgs.callPackage ./well-known/default.nix) {};
  in {
    homeConfigurations."jakeh" = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;

      extraSpecialArgs = {
        inherit (self) inputs;
        inherit wellKnown;
      };

      # Specify your home configuration modules here, for example,
      # the path to your home.nix.
      modules = [
        ./home.nix
        ./nvim/default.nix
        ./sops/default.nix
      ];

      # Optionally use extraSpecialArgs
      # to pass through arguments to home.nix
    };

    nixosDir = ./nixos;
  };
}
