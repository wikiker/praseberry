{ lib, pkgs, config, ... }:

with lib;
let
  mympd_port = config.songs.port;
in
{
  options = {
    songs.port = mkOption {
      type = with types; int;
    };
  };
  
  config = {
    environment.systemPackages = with pkgs [
      mpd
      unstable.mympd #There is no services.mympd on stable branch
    ];

    services.mpd.enable = true;
    services.mympd = {
      enable = true;
      settings.http_port = mympd_port;
    };
  };
}
