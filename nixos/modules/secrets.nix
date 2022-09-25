{ agenix, ... }:

{
  imports = [ agenix.nixosModules.age ];

  age.identityPaths = [
    # "/home/denbeigh/.ssh/id_rsa"
    # "/home/denbeigh/.ssh/ed_25519"
    "/var/lib/denbeigh/host_key"
  ];

  users.groups."key-access".gid = 1100;
}
