{ pkgs, ports, ... }:

{
  environment.systemPackages = with pkgs; [
    mpd
    mympd
  ];

  services.mpd.enable = true;
  services.mympd = {
    enable = true;
    settings.http_port = ports.mympd;
  };
}
