{ lib, ... }:
{
  networking.networkmanager.ensureProfiles.profiles = {
    laas_secure_gsaurel = {
      wifi-security = {
        key-mgmt = lib.mkForce "wpa-eap";
      };
      "802-1x" = {
        ca-cert = "/etc/ssl/certs/wifi-laas.crt";
        eap = "ttls";
        identity = "gsaurel";
        password = "$pw_laas_secure_gsaurel";
        phase2-auth = "pap";
      };
    };
    eduroam_gsaurel = {
      wifi-security = {
        key-mgmt = lib.mkForce "wpa-eap";
      };
      "802-1x" = {
        anonymous-identity = "gsaurel-anonymous@laas.fr";
        ca-cert = "/etc/ssl/certs/wifi-laas.crt";
        eap = "ttls";
        identity = "gsaurel@laas.fr";
        password = "$pw_eduroam_gsaurel";
        phase2-auth = "pap";
      };

    };
  };
}
