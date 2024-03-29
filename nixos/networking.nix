{...}:

let
  static_ip = "192.168.68.11";
in
{
  networking = {
    firewall.enable = false;
    useDHCP = false;

    interfaces = {
      enu1u1.ipv4.addresses = [{
        address = static_ip;
        prefixLength = 16;
      }];
      wlan0.ipv4.addresses = [{
        address = static_ip;
        prefixLength = 16;
      }];
    };
    defaultGateway = {
      address = "192.168.68.1";
      interface = "enu1u1";
    };
  };
}
