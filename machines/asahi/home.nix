{ pkgs, ... }:
{
  my-username = "gsaurel";
  home = {
    sessionVariables = {
      LD_PRELOAD = "/lib/x86_64-linux-gnu/libnss_sss.so.2";
      SCCACHE_REDIS = "redis://asahi";
    };
  };
  nix.package = pkgs.lix;
}
