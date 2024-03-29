{}:

let
  static_ip = "192.168.17.11";
in
{
  networking = {
    useDHCP = false;
    defaultGateway.address = static_ip;
  };
}
