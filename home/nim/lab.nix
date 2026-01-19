{
  pkgs,
  ...
}:
let
  nss = "${pkgs.sssd}/lib/libnss_sss.so.2";
in
{
  imports = [
    ./home-manager.nix
  ];

  laasProxy.enable = false;

  nim-home.username = "gsaurel";
  home.sessionVariables = {
    # LD_PRELOAD = "/lib/x86_64-linux-gnu/libnss_sss.so.2";
    LD_PRELOAD = nss;
  };
  programs.ssh.package = pkgs.openssh_gssapi;
  systemd.user.services.nim-sync.Service.Environment = [
    "LD_PRELOAD=${nss}"
    "SSH_ASKPASS=${../../bin/ask_rbw.py}"
  ];
}
