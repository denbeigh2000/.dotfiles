{ standard
, cloud
, aws-aarch64
, ...
}:

{
  config = {
    system = "aarch64-linux";
    modules = [
      standard
      cloud
      aws-aarch64
      {
        denbeigh.machine.hostname = "plain";
        denbeigh.user.enable = false;
      }
    ];
  };
}
