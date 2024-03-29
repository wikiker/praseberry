{...}:

let
  static_ip = "192.168.17.11";
in
{
  networking = {
    useDHCP = false;

    interfaces = {
      enu1u1.ipv4.addresses = [{
        address = static_ip;
        # prefixLength = 24;
      }];
      wlan0.ipv4.addresses = [{
        address = static_ip;
        # prefixLength = 24;
      }];
    };
  };
}
