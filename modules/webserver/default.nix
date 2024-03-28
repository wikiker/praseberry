{ lib, pkgs, config, ... }:

with lib;
let
  cfg = config.webserver;
  ports = cfg.ports;

  homepage-config = builtins.path {
    path = ./homepage-config;
    name = "homepage-config";
  };
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
    systemd.services.homepage-dashboard.environment.HOMEPAGE_CONFIG_DIR = lib.mkForce homepage-config;
  };
}
