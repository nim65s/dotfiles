{ config, pkgs, ... }:
{
  imports = [
    ../../modules/disko-zfs.nix
    ../../modules/display.nix
    ../../modules/shared.nix
    ../../modules/nixos.nix
    ../../modules/wifi.nix
    ../../modules/x86_64-linux.nix
  ];

  # TODO: this is a bad copypasta from
  # https://git.clan.lol/clan/clan-core/src/branch/main/clanModules/user-password/roles/default.nix
  # but this should instead look at iwd
  clan.core.facts.services.mimi-password = {
    secret.mimi-password = { };
    secret.mimi-password-hash = { };
    generator.prompt = "Set the password for mimi";
    generator.path = with pkgs; [
      coreutils
      xkcdpass
      mkpasswd
    ];
    generator.script = ''
      if [[ -n ''${prompt_value-} ]]; then
        echo $prompt_value | tr -d "\n" > $secrets/mimi-password
      else
        xkcdpass --numwords 3 --delimiter - --count 1 | tr -d "\n" > $secrets/mimi-password
      fi
      cat $secrets/mimi-password | mkpasswd -s -m sha-512 | tr -d "\n" > $secrets/mimi-password-hash
    '';
  };

  console = {
    useXkbConfig = false;
    keyMap = "fr";
  };
  disko.devices.disk.main.device = "/dev/disk/by-id/wwn-0x500a0751210f7632";
  home-manager.users = {
    nim = import ../../modules/nim-home.nix;
    mimi = import ../../modules/mimi-home.nix;
  };
  networking = {
    interfaces."tinc.mars".ipv4.addresses = [
      {
        address = "10.0.55.200";
        prefixLength = 24;
      }
    ];
  };
  programs.waybar.enable = false;
  services = {
    displayManager = {
      autoLogin.user = "mimi";
      defaultSession = null;
    };
    desktopManager.plasma6.enable = true;
    xserver.xkb.variant = "";
  };
  sops.secrets = {
    "${config.clan.core.settings.machine.name}-mimi-password-hash".neededForUsers = true;
  };
  stylix.image = ../../bg/hattori.jpg;
  users.users.mimi = {
    isNormalUser = true;
    hashedPasswordFile = config.clan.core.facts.services.mimi-password.secret.mimi-password-hash.path;
    shell = pkgs.fish;
  };
}
