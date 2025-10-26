{ config, inputs, ... }:
{
  imports = [
    inputs.zen-browser.homeModules.beta
  ];

  programs.zen-browser = {
    enable = true;
    policies = {
      AutoFillAddressEnabled = true;
      AutoFillCreditCardEnabled = false;
      DisableAppUpdate = true;
      DisableFeedbackCommands = true;
      DisableFirefoxStudies = true;
      DisablePocket = true;
      DisableTelemetry = true;
      OfferToSaveLogins = false;
      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
      };
    };
    profiles.default = {
      containersForce = true;
      containers = {
        Personal = {
          color = "blue";
          icon = "fingerprint";
          id = 1;
        };
        Work = {
          color = "green";
          icon = "briefcase";
          id = 2;
        };
      };
      spacesForce = true;
      spaces =
        let
          containers = config.programs.zen-browser.profiles.default.containers;
        in
        {
          Personal = {
            id = "7deea877-f5f5-4ddb-a871-15f1b862e4b2";
            container = containers.Personal.id;
            position = 1000;
            theme = {
              type = "gradient";
              colors = [
                {
                  red = 26;
                  green = 27;
                  blue = 38;
                  algorithm = "floating";
                  type = "explicit-lightness";
                }
              ];
            };
          };
          Work = {
            id = "34258d6c-4589-437d-8312-165787664c3a";
            container = containers.Work.id;
            position = 1001;
            theme = {
              type = "gradient";
              colors = [
                {
                  red = 89;
                  green = 131;
                  blue = 120;
                  algorithm = "floating";
                  type = "explicit-lightness";
                }
              ];
            };
          };
        };
    };
  };
}
