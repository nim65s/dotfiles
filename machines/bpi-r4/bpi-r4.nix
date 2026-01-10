# Thanks https://gitlab.com/K900/nix/-/blob/master/shared/platform/bpi-r4.nix
{
  lib,
  pkgs,
  pkgsHost,
  uboot-bpi-r4,
  linux-bpi-r4,
  ...
}:
let
  crossPkgs = pkgsHost.pkgsCross.aarch64-multiplatform;

  uboot = crossPkgs.buildUBoot {
    src = uboot-bpi-r4;
    version = "2025.07-bpi";
    defconfig = "mt7988a_bananapi_bpi-r4-bootstd_defconfig";
    filesToInstall = [ "u-boot.bin" ];
  };

  tfA = crossPkgs.buildArmTrustedFirmware {
    platform = "mt7988";
    extraMakeFlags = [
      "BL33=${uboot}/u-boot.bin" # FIP-ify our uboot
      "BOOT_DEVICE=spim-nand" # boot from NAND flash
      "DRAM_USE_COMB=1" # you're supposed to use this one, sayeth mediatek
      "DDR4_4BG_MODE=0" # disable large RAM support, for some reason this breaks things
      "USE_MKIMAGE=1" # use uboot mkimage instead of vendor mtk tool
      "bl2"
      "fip"
    ];
    filesToInstall = [
      "build/mt7988/release/bl2.img"
      "build/mt7988/release/fip.bin"
    ];
  };

  tfA' = tfA.overrideAttrs (old: {
    src = pkgsHost.fetchFromGitHub {
      owner = "mtk-openwrt";
      repo = "arm-trusted-firmware";
      rev = "e090770684e775711a624e68e0b28112227a4c38";
      hash = "sha256-VI5OB2nWdXUjkSuUXl/0yQN+/aJp9Jkt+hy7DlL+PMg=";
    };
    nativeBuildInputs =
      old.nativeBuildInputs
      ++ (with pkgsHost; [
        dtc
        openssl
        ubootTools
        which
      ]);
  });

  uboot-combined = pkgsHost.runCommand "uboot.img" { } ''
    dd if=${tfA'}/bl2.img of=uboot.img
    # magic offset hardcoded in BL2 by default
    dd if=${tfA'}/fip.bin of=uboot.img conv=notrunc bs=512 seek=$((0x580000 / 512))

    mkdir $out
    mv uboot.img $out/
  '';

  kernel = crossPkgs.buildLinux {
    version = "6.18.3";
    modDirVersion = "6.18.3";
    src = linux-bpi-r4;

    kernelPatches = [
      {
        name = "fix-build-with-phylink-builtin";
        patch = null;
        structuredExtraConfig = {
          FWNODE_PCS = lib.kernel.yes;
          PCS_MTK_USXGMII = lib.kernel.yes;
        };
      }
    ];
  };
in
{
  boot = {
    kernelPackages = crossPkgs.linuxPackagesFor kernel;

    kernelParams = [
      "clk_ignore_unused" # FIXME: fix the clock tree ffs
      "cma=256M" # Needed to fit NVMe buffers
      "mt7996e.wed_enable=1"
    ];
    consoleLogLevel = 7;

    initrd.kernelModules = [
      "mmc_block"
      "pcie-mediatek-gen3"
      "nvme"
    ];

    loader = {
      grub.enable = false;
      generic-extlinux-compatible.enable = true;
    };

    growPartition = true;
  };

  hardware = {
    firmware = [
      pkgs.linux-firmware
    ];

    deviceTree.overlays = [
      {
        name = "bpi-r4-emmc";
        dtsText = ''
          /dts-v1/;
          /plugin/;

          / {
            compatible = "bananapi,bpi-r4";
          };

          &mmc0 {
            pinctrl-names = "default", "state_uhs";
            pinctrl-0 = <&mmc0_pins_emmc_51>;
            pinctrl-1 = <&mmc0_pins_emmc_51>;
            bus-width = <8>;
            max-frequency = <200000000>;
            cap-mmc-highspeed;
            mmc-hs200-1_8v;
            mmc-hs400-1_8v;
            hs400-ds-delay = <0x12814>;
            vqmmc-supply = <&reg_1p8v>;
            vmmc-supply = <&reg_3p3v>;
            non-removable;
            no-sd;
            no-sdio;
            status = "okay";
          };
        '';
      }
    ];
  };

  boot.supportedFilesystems.zfs = false;
  systemd.network.enable = true;
  services.irqbalance.enable = true;
  nixpkgs.hostPlatform = "aarch64-linux";
  powerManagement.cpuFreqGovernor = "ondemand";

  system.build = {
    uboot = uboot-combined;
  };
}
