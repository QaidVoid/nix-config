{ pkgs, lib, config, ... } :
{
  options = {
    mako.enable = lib.mkEnableOption "Enable mako notification service";
  };

  config = lib.mkIf config.mako.enable {
    services.mako = {
      enable = true;
      sort = "-time";
      layer = "overlay";
      width = 300;
      height = 110;
      borderSize = 2;
      borderRadius = 16;
      icons = true;
      iconPath = pkgs.papirus-icon-theme + "/share/icons/Papirus";
      maxIconSize = 64;
      defaultTimeout = 5000;
      ignoreTimeout = true;
      font = "monospace 14";
      backgroundColor = "#1e1e2e";
      textColor = "#cdd6f4";
      borderColor = "#89b4fa";
      progressColor = "over #313244";

      extraConfig = ''
        [urgency=low]
        border-color=#cccccc

        [urgency=normal]
        border-color=#6c7086

        [urgency=high]
        border-color=#fab387

        [category=mpd]
        default-timeout=2000
        group-by=category
      '';
    };
  };
}
