{ pkgs, ... }:
{
  programs.mpv = {
    enable = true;
    scripts = with pkgs; [
      # mpvScripts.autosub
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
      # Force using CPU instead of GPU
      vulkan-device = "AMD Radeon Graphics (RADV RAPHAEL_MENDOCINO)";
    };
  };
}
