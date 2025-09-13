{
  lib,
  ...
}:
{
  networking = {
    networkmanager.ensureProfiles.profiles.baroustan.wifi-security.key-mgmt = lib.mkForce "sae";
  };
}
