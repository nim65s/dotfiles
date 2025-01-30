{
  description = "<Put your description here>";

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
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:danth/stylix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
        systems.follows = "clan-core/systems";
      };
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      clan-core,
      home-manager,
      self,
      stylix,
      ...
    }:
    let
      clan = clan-core.lib.buildClan {
        directory = self;
        specialArgs = { inherit home-manager stylix; };
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
    in
    {
      inherit (clan) nixosConfigurations clanInternals;
      devShells =
        clan-core.inputs.nixpkgs.lib.genAttrs
          [
            "x86_64-linux"
            #"aarch64-linux"
            #"aarch64-darwin"
            #"x86_64-darwin"
          ]
          (system: {
            default = clan-core.inputs.nixpkgs.legacyPackages.${system}.mkShell {
              CLAN_DIR = "/home/nim/ashitaka";
              packages = [ clan-core.packages.${system}.clan-cli ];
            };
          });
    };
}
