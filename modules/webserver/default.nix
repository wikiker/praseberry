{ inputs, lib, pkgs, config, ... }:

with lib;
let
  cfg = config.webserver;
  ports = cfg.ports;

  app = "prasesous";
  dataDir = "/srv/http/${app}";
in
{
  options = {
    webserver.ports = mkOption {
      type = with types; attrsOf int;
    };
  };

  config = {
    services.phpfpm.pools.${app} = {
      user = app;
      settings = {
        "listen.owner" = config.services.nginx.user;
        "pm" = "dynamic";
        "pm.max_children" = 32;
        "pm.max_requests" = 500;
        "pm.start_servers" = 2;
        "pm.min_spare_servers" = 2;
        "pm.max_spare_servers" = 5;
        "php_admin_value[error_log]" = "stderr";
        "php_admin_flag[log_errors]" = true;
        "catch_workers_output" = true;
      };
      phpEnv."PATH" = lib.makeBinPath [ pkgs.php ];
    };

    services.nginx = {
      enable = true;
      virtualHosts.localhost = {
        root = dataDir;
        locations."/" = {
          tryFiles = "$uri $uri/ /index.php";
        };

        locations."~ \\.php$" = {
          extraConfig = ''
            fastcgi_split_path_info ^(.+\.php)(/.+)$;
            fastcgi_pass unix:${config.services.phpfpm.pools.${app}.socket};
            include ${pkgs.nginx}/conf/fastcgi.conf;
          '';
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

    users.users.${app} = {
      isSystemUser = true;
      createHome = true;
      home = dataDir;
      group  = app;
    };
    users.groups.${app} = {
      members = [
        config.services.nginx.user
      ];
    };
  };
}
