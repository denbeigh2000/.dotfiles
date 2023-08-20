{ standard
, aws
, cloud
}:

{
  system = "x86_64-linux";
  config = {
    modules = [
      standard
      aws
      cloud
      {
        denbeigh.machine.hostname = "dev";
      }
    ];
  };
}
