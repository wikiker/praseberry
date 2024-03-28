{ inputs, lib, pkgs, config, ... }:

with lib;
let
  mympd_port = config.songs.port;
in
{
  imports = [
    "${inputs.nixpkgs-unstable}/nixos/modules/services/audio/mympd.nix"
  ];

  options = {
    songs.port = mkOption {
      type = with types; int;
    };
  };

  config = {
    services.mpd.enable = true;
    services.mympd = {
      enable = true;
      package = pkgs.unstable.mympd;
      settings.http_port = mympd_port;
    };
  };
}
