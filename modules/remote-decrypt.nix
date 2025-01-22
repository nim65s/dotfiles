{ config, ... }:
{
  boot.initrd = {
    availableKernelModules = [
      "xhci_pci"
    ];
    kernelModules = [
      "r8169"
    ];
    network = {
      enable = true;
      ssh = {
        enable = true;
        port = 7172;
        authorizedKeys = config.users.users.root.openssh.authorizedKeys.keys;
        hostKeys = [
          "/var/lib/initrd-ssh-key"
        ];
      };
    };
  };
}
