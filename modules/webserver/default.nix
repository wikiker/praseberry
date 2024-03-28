{ pkgs, ... }:

let
  ports = {
    homepage = 8010;
    mympd = 8020;
  };
in
{
  imports = [
    ../songs
  ];
  environment.systemPackages = with pkgs; [
    homepage-dashboard
    nginx
  ];

  services.nginx = {
    enable = true;
    virtualHosts.localhost = {
      locations."/" = {
        proxyPass = "http://localhost:${builtins.toString ports.homepage}";
      };
    };
  };

  services.homepage-dashboard = {
    enable = true;
    listenPort = ports.homepage;
  };
}
