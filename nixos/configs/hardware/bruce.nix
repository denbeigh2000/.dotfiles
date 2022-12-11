{ modulesPath, lib, config, ... }:

let
  ssdOptions = {
    options = [ "noatime" "nodiratime" "discard" ];
  };
in
{
  imports = [
    ("${modulesPath}/installer/scan/not-detected.nix")
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sr_mod" ];
  boot.initrd.kernelModules = [ "dm-snapshot" ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems = {
    "/" = {
      device = "/dev/vg-root/root";
      fsType = "ext4";
    } // ssdOptions;
    "/data" = {
      device = "/dev/vg-data/data";
      fsType = "ext4";
    } // ssdOptions;
    "/boot" = {
      device = "/dev/disk/by-uuid/D057-779C";
      fsType = "vfat";
    } // ssdOptions;
  };

  boot.initrd.luks.devices = {
    root = {
      name = "root";
      device = "/dev/disk/by-uuid/31a70e48-3cec-483a-894c-93464d939cb7";
      preLVM = true;
      allowDiscards = true;
    };
    data = {
      name = "data";
      device = "/dev/disk/by-uuid/2e980a78-2c9c-4274-a2e1-d51c859b5a52";
      preLVM = true;
      allowDiscards = true;
    };
  };

  swapDevices = [ ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.eno1.useDHCP = lib.mkDefault true;
  # networking.interfaces.eno2.useDHCP = lib.mkDefault true;

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
