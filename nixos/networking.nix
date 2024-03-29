{...}:

{
  networking = {
    firewall.enable = false;
    useDHCP = false;

    interfaces = {
      enu1u1.ipv4.addresses = [{
        address = "192.168.68.17";
        prefixLength = 24;
      }];
    };
    defaultGateway = {
      address = "192.168.68.1";
      interface = "enu1u1";
    };
  };
}
