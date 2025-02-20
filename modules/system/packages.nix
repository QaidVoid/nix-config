{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    acpi
    clang
    ffmpeg
    git
    mold
    tmux
    papirus-icon-theme
    p7zip
    qemu
    wireguard-tools
  ];

  services.redis.servers."".enable = true;
  services.minio = {
    enable = true;
    browser = true;
    secretKey = "homesecretkey";
    accessKey = "homeaccesskey";
  };
}
