{ pkgs, ... }:
{
  services.swayidle =
    let
      lock = "${pkgs.swaylock}/bin/swaylock --daemonize";
      display = status: "${pkgs.niri}/bin/niri msg action power-${status}-monitors";
    in
    {
      enable = true;
      timeouts = [
        {
          timeout = 270;
          command = "${pkgs.libnotify}/bin/notify-send 'Locking in 30 seconds' -t 5000";
        }
        {
          timeout = 300;
          command = lock;
        }
        {
          timeout = 305;
          command = display "off";
          resumeCommand = display "on";
        }
      ];
      events = [
        {
          event = "before-sleep";
          command = (display "off") + "; " + lock;
        }
        {
          event = "after-resume";
          command = display "on";
        }
        {
          event = "lock";
          command = (display "off") + "; " + lock;
        }
        {
          event = "unlock";
          command = display "on";
        }
      ];
    };
}
