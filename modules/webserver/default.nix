{ lib, pkgs, config, ... }:

with lib;
let
  cfg = config.webserver;
  ports = cfg.ports;
in
{
  options = {
    webserver.ports = mkOption {
      type = with types; attrsOf int;
    };
  };

  config = {
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
  };
}
