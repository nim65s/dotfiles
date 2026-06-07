# https://git.clan.lol/clan/clan-core/src/branch/main/nixosModules/installer/zfs-latest.nix
{
  lib,
  pkgs,
  config,
  ...
}:

let
  isUnstable = config.boot.zfs.package == pkgs.zfs_unstable;
  zfsCompatibleKernelPackages = lib.filterAttrs (
    name: kernelPackages:
    (builtins.match "linux_[0-9]+_[0-9]+" name) != null
    && (builtins.tryEval kernelPackages).success
    && (
      let
        zfsPackage =
          if isUnstable then
            kernelPackages.zfs_unstable
          else
            kernelPackages.${pkgs.zfs.kernelModuleAttribute};
      in
      !(zfsPackage.meta.broken or false)
    )
  ) pkgs.linuxKernel.packages;
  latestKernelPackage = lib.last (
    lib.sort (a: b: (lib.versionOlder a.kernel.version b.kernel.version)) (
      builtins.attrValues zfsCompatibleKernelPackages
    )
  );
in
{
  # Note this might jump back and worth as kernel get added or removed.
  boot.kernelPackages = lib.mkIf (lib.meta.availableOn pkgs.stdenv.hostPlatform pkgs.zfs) latestKernelPackage;

  # evaluation warning: `boot.zfs.forceImportRoot` is using the default value of `true`. It is highly recommended to set it to `false`, the new default from 26.11 on, to reduce the risk of data loss. Alternatively, you can silence this warning by explicitly setting it to `true`.
  boot.zfs.forceImportRoot = false;
}
