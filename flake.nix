{
  description = "<Put your description here>";

  inputs = {
    clan-core.url = "https://git.clan.lol/clan/clan-core/archive/main.tar.gz";
    nixpkgs.follows = "clan-core/nixpkgs";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "clan-core/nixpkgs";
    };
    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "clan-core/nixpkgs";
      inputs.systems.follows = "clan-core/systems";
    };
  };

  outputs =
    { clan-core, home-manager, self, stylix, ... }:
    let
      clan = clan-core.lib.buildClan {
        directory = self;
        specialArgs = { inherit home-manager stylix; };
        meta.name = "ashitakaclanim";
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
