{ lib, ... }:

{
  options.theme = {
    description = "Global theme configuration";
    name = lib.mkOption {
      description = "Name of the theme to use.";
      type = lib.types.str;
      default = "catppuccinMocha";
    };
    dark = lib.mkOption {
      description = "Whether the theme is dark mode.";
      type = lib.types.bool;
      default = true;
    };
  };

  config = {
    theme = {
      name = "catppuccinMocha";
      dark = true;
    };

    specialisation.light-theme.configuration = {
      theme = lib.mkForce {
        name = "catppuccinLatte";
        dark = false;
      };
    };
  };
}
