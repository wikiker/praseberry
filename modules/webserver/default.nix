{ inputs, lib, pkgs, config, ... }:

with lib;
let
  cfg = config.webserver;
  ports = cfg.ports;
in
{
  disabledModules = [
    "services/misc/homepage-dashboard.nix"
  ];

  imports = [
    "${inputs.nixpkgs-unstable}/nixos/modules/services/misc/homepage-dashboard.nix"
  ];

  options = {
    webserver.ports = mkOption {
      type = with types; attrsOf int;
    };
  };

  config = {
    services.nginx = {
      enable = true;
      virtualHosts.localhost = {
        locations."/" = {
          proxyPass = "http://localhost:${builtins.toString ports.homepage}";
        };
        locations."/znelky" = {
          proxyPass = "http://localhost:${builtins.toString ports.mympd}";
          extraConfig = ''
          internal;
          proxy_set_header X-Real-IP  $remote_addr;
          proxy_set_header X-Forwarded-For $remote_addr;
          proxy_set_header Host $host;
          proxy_redirect / /znelky/;
          '';
        };
      };
    };

    services.homepage-dashboard = {
      enable = true;
      listenPort = ports.homepage;

      settings = {
        title = "Praseberry";
      };

      services = [
        {
          "Sous" = [
            {
              "mympd" = {
                description = "znělky";
                href = "http://localhost/znelky";
              };
            }
          ];
        }
      ];
    };
  };
}
