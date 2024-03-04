{
  description = "NixOS Flake for Loon";

  nixConfig = {
    extra-substituters = [
      "https://nim65s-dotfiles.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nim65s-dotfiles.cachix.org-1:6vuY5z8YGzfjrssfcxb3DuH50DC1l562U0BIGMxnClg="
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

  outputs = { nixpkgs, home-manager, nur, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        localSystem = system;
        config.allowUnfree = true;
        overlays = [
          (final: prev: { nur = import nur { nurpkgs = prev; pkgs = prev; }; })
        ];
      };
    in {
      nixosConfigurations.loon = nixpkgs.lib.nixosSystem {
        inherit pkgs;
        modules = [
          ./configuration.nix
          nur.nixosModules.nur
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;  # to get NUR
            home-manager.users.nim = import ./../../.config/home-manager/loon/home.nix;
          }
        ];
      };
    };
}
