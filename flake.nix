{
  description = "Home Manager configuration of jakeh";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

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
    config = host: modules: let
      inherit (import host) system;
      pkgs = nixpkgs.legacyPackages.${system};

      inherit (import ./lib {inherit pkgs;}) scripts utils;

      homeManagerConfiguration = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        extraSpecialArgs = {
          inherit (self) inputs;
          inherit scripts utils;
        };

        modules =
          [
            (import host).module
          ]
          ++ modules;
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
    in {
      inherit devShell;
      inherit homeManagerConfiguration;
    };

    personal = config ./hosts/nixos.nix [
      ./audio/daw.nix
      ./dev/direnv
      ./dev/git
      ./dev/github
      ./dev/nvim
      ./borg
      ./home-manager
      ./secrets
      ./shell
      ./term
      ./tmux
    ];
    work = config ./hosts/SB-US-B0E2-jhamilton.nix [
      ./dev/direnv
      ./dev/git
      ./dev/github
      ./dev/nvim
      ./home-manager
      ./secrets
      ./shell
      ./term
      ./tmux
    ];
  in {
    devShell."x86_64-linux" = personal.devShell;
    devShell."aarch64-darwin" = work.devShell;

    homeConfigurations."nixos" = personal.homeManagerConfiguration;
    homeConfigurations."work" = work.homeManagerConfiguration;

    nixosDir = ./nixos;
  };
}
