{ inputs, pkgs, ... }:
{
  nix = {
    nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
    package = pkgs.lix;
    settings = {
      extra-substituters = [
        "https://gepetto.cachix.org"
        "https://nim65s.cachix.org"
        "https://nix-community.cachix.org"
        "https://rycee.cachix.org"
      ];
      extra-trusted-public-keys = [
        "gepetto.cachix.org-1:toswMl31VewC0jGkN6+gOelO2Yom0SOHzPwJMY2XiDY="
        "nim65s.cachix.org-1:aycmWbuJijDcr9npRLM/2X76kY86iToBI2tlkpp2BLE="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "rycee.cachix.org-1:TiiXyeSk0iRlzlys4c7HiXLkP3idRf20oQ/roEUAh/A="
      ];
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
  };
}