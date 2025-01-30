{
  description = "My dotfiles";

  inputs = {
    clan-core = {
      url = "https://git.clan.lol/clan/clan-core/archive/main.tar.gz";
      inputs = {
        flake-parts.follows = "flake-parts";
        nixpkgs.follows = "nixpkgs";
        treefmt-nix.follows = "treefmt-nix";
      };
    };
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    stylix = {
      url = "github:danth/stylix";
      inputs = {
        home-manager.follows = "home-manager";
        nixpkgs.follows = "nixpkgs";
        systems.follows = "clan-core/systems";
      };
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } (
      { self, ... }:
      {
        imports = [
          inputs.clan-core.flakeModules.default
          inputs.treefmt-nix.flakeModule
        ];

        clan = {
          directory = self;
          specialArgs = { inherit (inputs) home-manager stylix; };
          meta.name = "ashitakaclanim";
          inventory.services.mycelium.default = {
            roles.peer.machines = [
              "ashitaka"
              "hattori"
              "perseverance"
              "yupa"
            ];
            config = {
              topLevelDomain = "m";
              openFirewall = true;
            };
          };
        };
        perSystem =
          { pkgs, system, ... }:
          {
            devShells = {
              default = pkgs.mkShell {
                packages = [
                  inputs.clan-core.packages.${system}.clan-cli
                ];
                CLAN_DIR = "/home/nim/ashitaka";
              };
            };
          };
        systems = [ "x86_64-linux" ];
      }
    );
}
