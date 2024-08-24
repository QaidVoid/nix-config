{ ... }:
{
  imports = [
    ./mako.nix
    ./wlsunset.nix
  ];

  mako.enable = true;
  wlsunset.enable = true;
}
