{ lib, config, ... }:
{
  options = {
    ssh.enable = lib.mkEnableOption "Enable SSH";
    gpg.enable = lib.mkEnableOption "Enable GnuPG";
  };

  config = lib.mkMerge [
    (lib.mkIf config.ssh.enable {
      programs.ssh.startAgent = true;
      services.openssh = {
        enable = true;
        settings = {
          PasswordAuthentication = true;
          PermitRootLogin = "no";
        };
      };
    })

    (lib.mkIf config.gpg.enable {
      programs.gnupg.agent = {
        enable = true;
      };
    })
  ];
}
