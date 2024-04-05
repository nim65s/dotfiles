{
  description = "My dotfiles";

  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://nim65s-dotfiles.cachix.org"
      "https://nim65s-nur.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "nim65s-dotfiles.cachix.org-1:6vuY5z8YGzfjrssfcxb3DuH50DC1l562U0BIGMxnClg="
      "nim65s-nur.cachix.org-1:V3uaUnDnkWYgPDZaXpoe/KIbX5913GWfkazhHVDYPoU="
    ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nur.url = "github:nix-community/nur";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      nur,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        localSystem = system;
        config.allowUnfree = true;
      };
    in
    {
      homeConfigurations = {
        "gsaurel@asahi" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./nix/asahi/home.nix ];
        };
        "gsaurel@upepesanke" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./nix/upepesanke/home.nix ];
        };
        "nim@yupa" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./nix/yupa/home.nix ];
        };
      };
      nixosConfigurations = {
        loon = nixpkgs.lib.nixosSystem {
          inherit pkgs;
          modules = [
            ./nix/loon/configuration.nix
            nur.nixosModules.nur
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.users.nim = import ./nix/loon/home.nix;
            }
          ];
        };
        hattorixos = nixpkgs.lib.nixosSystem {
          inherit pkgs;
          modules = [
            ./nix/hattorixos/configuration.nix
            nur.nixosModules.nur
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.users.nim = import ./nix/loon/home.nix; # follow loon cfg
            }
          ];
        };
      };
    };
}
