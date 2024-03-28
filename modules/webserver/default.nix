{ pkgs, ... }:

let
  ports = {
    homepage = 8010;
  };
in
{
  environment.systemPackages = with pkgs; [
    homepage-dashboard
    nginx
  ];

  services.nginx = {
    enable = true;
    virtualHosts.localhost = {
      locations."/" = {
        proxyPass = "http://localhost:${ports.homepage}";
      };
    };
  };

  services.homepage-dashboard = {
    enable = true;
    listenPort = ports.homepage;
  };
}
