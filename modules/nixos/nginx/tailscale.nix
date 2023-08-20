addr: {
  listen = [
    {
      inherit addr;
      port = 443;
      ssl = true;
    }
    {
      inherit addr;
      port = 80;
    }
  ];
}
