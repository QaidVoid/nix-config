{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.virtualization.enable = lib.mkEnableOption "Enable virtualization configuration";

  config = lib.mkIf config.virtualization.enable {
    environment.systemPackages = with pkgs; [
      dnsmasq
    ];

    virtualisation.libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = true;
        vhostUserPackages = with pkgs; [ virtiofsd ];
      };
    };

    services.spice-vdagentd.enable = true;

    networking.firewall.trustedInterfaces = [ "virbr0" ];

    programs.virt-manager.enable = true;
    users.users.qaidvoid.extraGroups = [ "libvirtd" ];
  };
}
