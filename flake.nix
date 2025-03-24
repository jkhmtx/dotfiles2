{
  description = "Home Manager configuration of jakeh";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nixCats.url = "github:BirdeeHub/nixCats-nvim";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      homeConfigurations."jakeh" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

	extraSpecialArgs = {
	  inherit (self) inputs;
	};

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [
	  ./home.nix
	  ./nvim/default.nix
	];

        # Optionally use extraSpecialArgs
        # to pass through arguments to home.nix
      };
    };
}
