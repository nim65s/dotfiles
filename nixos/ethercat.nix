{
  config,
  lib,
  pkgs,
  ...
}:
let

  cfg = config.services.ethercat;

in

{

  options = {

    services.ethercat = {

      enable = lib.mkEnableOption "the IgH EtherCAT Master for Linux";

      package = lib.mkPackageOption pkgs "ethercat" { };

      group = lib.mkOption {
        type = lib.types.str;
        description = "Group owning /dev/EtherCAT*";
        default = "ethercat";
      };

      master0Device = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        description = ''
          Main Ethernet devices.

          The MASTER<X>_DEVICE variable specifies the Ethernet device for a master
          with index 'X'.

          Specify the MAC address (hexadecimal with colons) of the Ethernet device to
          use. Example: "00:00:08:44:ab:66"

          Alternatively, a network interface name can be specified. The interface
          name will be resolved to a MAC address using the 'ip' command.
          Example: "eth0"

          The broadcast address "ff:ff:ff:ff:ff:ff" has a special meaning: It tells
          the master to accept the first device offered by any Ethernet driver.

          The MASTER<X>_DEVICE variables also determine, how many masters will be
          created: A non-empty variable MASTER0_DEVICE will create one master, adding a
          non-empty variable MASTER1_DEVICE will create a second master, and so on.
        '';
        example = ''"00:00:08:44:ab:66" or "eth0"'';
        default = null;
      };

      master1Device = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        description = ''
          Main Ethernet devices.

          The MASTER<X>_DEVICE variable specifies the Ethernet device for a master
          with index 'X'.

          Specify the MAC address (hexadecimal with colons) of the Ethernet device to
          use. Example: "00:00:08:44:ab:66"

          Alternatively, a network interface name can be specified. The interface
          name will be resolved to a MAC address using the 'ip' command.
          Example: "eth0"

          The broadcast address "ff:ff:ff:ff:ff:ff" has a special meaning: It tells
          the master to accept the first device offered by any Ethernet driver.

          The MASTER<X>_DEVICE variables also determine, how many masters will be
          created: A non-empty variable MASTER0_DEVICE will create one master, adding a
          non-empty variable MASTER1_DEVICE will create a second master, and so on.
        '';
        example = ''"00:00:08:44:ab:66" or "eth0" or "ff:ff:ff:ff:ff:ff"'';
        default = null;
      };

      master0Backup = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        description = ''
          Backup Ethernet devices

          The MASTER<X>_BACKUP variables specify the devices used for redundancy. They
          behaves nearly the same as the MASTER<X>_DEVICE variable, except that it
          does not interpret the ff:ff:ff:ff:ff:ff address.
        '';
        example = ''"00:00:08:44:ab:66" or "eth0"'';
        default = null;
      };

      deviceModules = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        description = ''
          Ethernet driver modules to use for EtherCAT operation.

          Specify a non-empty list of Ethernet drivers, that shall be used for
          EtherCAT operation.

          Except for the generic Ethernet driver module, the init script will try to
          unload the usual Ethernet driver modules in the list and replace them with
          the EtherCAT-capable ones. If a certain (EtherCAT-capable) driver is not
          found, a warning will appear.

          Possible values: 8139too, e100, e1000, e1000e, r8169, generic, ccat, igb, igc, genet, dwmac-intel, stmmac-pci.
          Separate multiple drivers with spaces.
          A list of all matching kernel versions can be found here:
          https://docs.etherlab.org/ethercat/1.6/doxygen/devicedrivers.html
        '';
        example = ''"generic"'';
        default = null;
      };

      updownInterfaces = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        description = ''
          List of interfaces to bring up and down automatically.

          Specify a space-separated list of interface names (such as eth0 or
          enp0s1) that shall be brought up on `ethercatctl start` and down on
          `ethercatctl stop`.

          When using the generic driver, the corresponding Ethernet device has to be
          activated before the master is started, otherwise all frames will time out.
          This the perfect use-case for `UPDOWN_INTERFACES`.
        '';
        example = ''"eth0"'';
        default = null;
      };

      modprobeFlags = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        description = ''
          Flags for loading kernel modules.

          This can usually be left empty. Adjust this variable, if you have problems
          with module loading.
        '';
        example = ''"-b"'';
        default = null;
      };

      extraConfig = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        description = ''
          These lines go to the end of ethercat.conf verbatim
        '';
        default = null;
      };

    };

  };

  config = lib.mkIf cfg.enable {

    boot.extraModulePackages = with config.boot.kernelPackages; [ ethercat ];

    environment.systemPackages = [ cfg.package ];

    environment.etc."ethercat.conf".text =
      lib.optionalString (cfg.master0Device != null) ''
        MASTER0_DEVICE="${cfg.master0Device}"
      ''
      + lib.optionalString (cfg.master1Device != null) ''
        MASTER1_DEVICE="${cfg.master1Device}"
      ''
      + lib.optionalString (cfg.master0Backup != null) ''
        MASTER0_BACKUP="${cfg.master0Backup}"
      ''
      + lib.optionalString (cfg.deviceModules != null) ''
        DEVICE_MODULES="${cfg.deviceModules}"
      ''
      + lib.optionalString (cfg.updownInterfaces != null) ''
        UPDOWN_INTERFACES="${cfg.updownInterfaces}"
      ''
      + lib.optionalString (cfg.modprobeFlags != null) ''
        MODPROBE_FLAGS="${cfg.modprobeFlags}"
      ''
      + lib.optionalString (cfg.modprobeFlags != null) cfg.extraConfig;

    systemd.services.ethercat = {
      description = "EtherCAT Master Kernel Modules";
      after = [ "network-online.target" ];
      requires = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = "yes";
        ExecStart = "${lib.getExe' cfg.package "ethercatctl"} -c /etc/ethercat.conf start";
        ExecStop = "${lib.getExe' cfg.package "ethercatctl"} -c /etc/ethercat.conf stop";
      };
    };

    users.groups."${cfg.group}" = { };
    services.udev.extraRules = ''
      KERNEL=="EtherCAT[0-9]*", GROUP="${cfg.group}", MODE="0660"
    '';

  };

  meta.maintainers = with lib.maintainers; [ nim65s ];
}
