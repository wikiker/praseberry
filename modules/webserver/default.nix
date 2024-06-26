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
      phpOptions = ''
        display_errors = on;
        display_startup_errors = on;
      '';
      phpEnv."PATH" = "${pkgs.php}:/run/current-system/sw/bin";
    };

    services.nginx = {
      enable = true;
      virtualHosts.localhost = {
        root = dataDir;

        serverAliases = [
          "sous.dlaza.cz"
        ];

        locations."/" = {
          tryFiles = "$uri $uri/ /index.php";
          index = "index.php";
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
            rewrite ^/znelky(.*) $1 break;
            proxy_set_header X-Real-IP  $remote_addr;
            proxy_set_header X-Forwarded-For $remote_addr;
            proxy_set_header Host $host;
            proxy_redirect off;
          '';
        };
      };
    };

    users.users.${app} = {
      isSystemUser = true;
      createHome = true;
      home = dataDir;
      homeMode = "770";
      group  = app;
      # useDefaultShell = true;
    };
    # users.users.${config.services.nginx.user}.useDefaultShell = true;
    users.groups.${app} = {
      members = [
        config.services.nginx.user
        "prase"
      ];
    };
  };
}
