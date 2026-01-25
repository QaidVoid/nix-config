{ config, lib, ... }:
{
  options.cli = {
    enable = lib.mkEnableOption "Enable CLI tools";
    enableStarship = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable Starship prompt";
    };
    enableYazi = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable Yazi file manager";
    };
  };

  config = lib.mkIf config.cli.enable {
    programs.starship = lib.mkIf config.cli.enableStarship {
      enable = true;
      settings = {
        add_newline = true;
        character = {
          success_symbol = "[➜](bold green)";
          error_symbol = "[➜](bold red)";
        };
      };
    };

    programs.yazi = lib.mkIf config.cli.enableYazi {
      enable = true;
      enableFishIntegration = true;
    };
  };
}
