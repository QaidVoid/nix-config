{ pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/system
  ];

  systemd.services.makemecool = {
    enable = true;
    description = "Fix CPU heating issue";
    unitConfig = { Type = "oneshot"; };
    serviceConfig = {
      ExecStart = "-${pkgs.bash}/bin/bash -c 'echo 3 > /sys/class/thermal/cooling_device0/cur_state'";
      RemainAtExit = "yes";
    };
    wantedBy = [ "multi-user.target" ];
  };

  systemd.user.extraConfig = "DefaultLimitNOFILE=65535";
  security.pam.loginLimits = [
    { domain = "*"; item = "nofile"; type = "-"; value = "524288"; }
  ];

  bluetooth.enable = true;
  wifi.enable = true;
  dbus.enable = true;
  docker.enable = true;
  pipewire.enable = true;
  swaylock.enable = true;
  vaultwarden.enable = true;

  gpg.enable = true;
  ssh.enable = true;

  services.libinput.enable = true;

  environment.systemPackages = with pkgs; [
    android-tools
  ];

  networking.firewall.allowedTCPPorts = [ 2222 ];

  services.postgresql = {
    enable = true;
    authentication = pkgs.lib.mkOverride 10 ''
      local all       all     trust
    '';
  };
}
