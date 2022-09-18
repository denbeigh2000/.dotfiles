{ host, ... }:

{
  imports = [
    ../.      # modules/cloud/aws
    ../../.   # modules/cloud
  ];

  fileSystems."/home/${host.username}" = {
    # NOTE: This is tied to an EBS mount at this path defined in Coder templates.
    device = "dev/xvdb";
    fsType = "ext4";
    autoFormat = true;
  };
}
