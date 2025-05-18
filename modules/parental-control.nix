# Thanks https://archtemis.readthedocs.io/en/latest/network.html#parental-controls
{ config, pkgs, ... }:
let
  inherit (config.users.groups.kids) gid;
  inherit (config.services.squid) proxyPort;
  ip = "192.168.8.209"; # TODO
in
{
  users.groups.kids.gid = 10000;
  networking.nftables = {
    enable = true;
    ruleset = ''
      table inet filter {
          chain output {
              type filter hook output priority filter; policy accept;
              tcp dport ${builtins.toString proxyPort} ip daddr { 127.0.0.1, ${ip} } meta skgid ${builtins.toString gid} counter log prefix "[Nftables] accept kids on proxy: " flags all accept
              meta skgid ${builtins.toString gid} counter log prefix "[Nftables] deny kids access: " flags all drop
          }
      }
    '';
  };
  services.squid = {
    enable = true;
    extraConfig = ''
      auth_param basic program ${config.services.squid.package}/libexec/basic_pam_auth
      auth_param basic realm Squid proxy-caching web server
      auth_param basic kids 5 startup=5 idle=1
      auth_param basic credentialsttl 2 hours
      acl pam_auth proxy_auth REQUIRED
      http_access deny !pam_auth
    '';
    package = pkgs.squid.overrideAttrs {
      postInstall = ''
        cp src/auth/basic/PAM/basic_pam_auth $out/libexec
      '';
    };
  };
}
