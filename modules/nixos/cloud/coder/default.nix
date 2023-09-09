{ lib, ... }:

{
  fileSystems."/home" = {
    device = lib.mkDefault "/dev/nvme1n1";
    fsType = "ext4";
    autoFormat = true;
  };
}
