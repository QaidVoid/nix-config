{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.mpv.enable = lib.mkEnableOption "Enable mpv";

  config = lib.mkIf config.mpv.enable {
    programs.mpv = {
      enable = true;
      scripts = with pkgs; [
        mpvScripts.autosub
        mpvScripts.autosubsync-mpv
        mpvScripts.smartskip
        mpvScripts.sponsorblock-minimal
        mpvScripts.youtube-upnext
        mpvScripts.quality-menu
        mpvScripts.mpris
      ];
      config = {
        save-position-on-quit = true;
        gpu-api = "vulkan";
        hwdec = "vaapi";
        vo = "wlshm";
      };
    };
  };
}
