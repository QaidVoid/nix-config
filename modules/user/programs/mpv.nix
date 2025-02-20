{ lib, config, pkgs, ... }:
{
  options = {
    mpv.enable = lib.mkEnableOption "Enable mpv";
  };

  config = lib.mkIf config.mpv.enable {
    programs.mpv = {
      enable = true;
      scripts = with pkgs; [
        mpvScripts.autosub
        mpvScripts.autosubsync-mpv
        mpvScripts.modernx
        mpvScripts.smartskip
        mpvScripts.mpv-discord
        mpvScripts.sponsorblock-minimal
        mpvScripts.youtube-upnext
        mpvScripts.quality-menu
        mpvScripts.mpris
        mpvScripts.mpv-notify-send
      ];
    };

    xdg.desktopEntries.mpv = {
      name = "mpv";
      noDisplay = true;
    };
  };
}
