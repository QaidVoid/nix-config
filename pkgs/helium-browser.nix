{
  lib,
  stdenv,
  fetchurl,
  addDriverRunpath,
  autoPatchelfHook,
  copyDesktopItems,
  makeDesktopItem,
  makeWrapper,
  wrapGAppsHook3,
  alsa-lib,
  at-spi2-atk,
  at-spi2-core,
  cairo,
  cups,
  dbus,
  expat,
  fontconfig,
  freetype,
  gdk-pixbuf,
  glib,
  gtk3,
  libdrm,
  libgbm,
  libglvnd,
  libpulseaudio,
  libva,
  libX11,
  libXcomposite,
  libXdamage,
  libXext,
  libXfixes,
  libXrandr,
  libXScrnSaver,
  libxcb,
  libxkbcommon,
  mesa,
  nspr,
  nss,
  pango,
  pipewire,
  qt6,
  systemd,
  vulkan-loader,
  wayland,
  xdg-utils,
  commandLineArgs ? "",
}:

stdenv.mkDerivation rec {
  pname = "helium-browser";
  version = "0.11.7.1";

  src = fetchurl {
    url = "https://github.com/imputnet/helium-linux/releases/download/${version}/helium-${version}-x86_64_linux.tar.xz";
    hash = "sha256-V0drAliKB8HFkxDG9I+bPThLH0I/cJpG92v3aORaX/Y=";
  };

  sourceRoot = "helium-${version}-x86_64_linux";

  nativeBuildInputs = [
    autoPatchelfHook
    copyDesktopItems
    makeWrapper
    wrapGAppsHook3
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    alsa-lib
    at-spi2-atk
    at-spi2-core
    cairo
    cups
    dbus
    expat
    fontconfig
    freetype
    gdk-pixbuf
    glib
    gtk3
    libdrm
    libgbm
    libglvnd
    libpulseaudio
    libva
    libX11
    libXcomposite
    libXdamage
    libXext
    libXfixes
    libXrandr
    libXScrnSaver
    libxcb
    libxkbcommon
    mesa
    nspr
    nss
    pango
    pipewire
    qt6.qtbase
    systemd
    vulkan-loader
    wayland
    xdg-utils
  ];

  autoPatchelfIgnoreMissingDeps = [
    "libQt5Core.so.5"
    "libQt5Gui.so.5"
    "libQt5Widgets.so.5"
  ];

  dontWrapGApps = true;
  dontWrapQtApps = true;

  desktopItems = [
    (makeDesktopItem {
      name = "helium-browser";
      exec = "helium-browser %U";
      icon = "helium-browser";
      desktopName = "Helium";
      genericName = "Web Browser";
      categories = [ "Network" "WebBrowser" ];
      mimeTypes = [
        "application/pdf"
        "application/xhtml+xml"
        "text/html"
        "text/xml"
        "x-scheme-handler/http"
        "x-scheme-handler/https"
      ];
      actions = {
        new-window = { name = "New Window"; exec = "helium-browser"; };
        new-private-window = { name = "New Incognito Window"; exec = "helium-browser --incognito"; };
      };
    })
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/opt/helium
    cp -r * $out/opt/helium/

    # Replace bundled Vulkan loader with system one
    # Keep bundled libEGL.so/libGLESv2.so — they are ANGLE for GPU rendering
    rm -f $out/opt/helium/libvulkan.so.1
    ln -s ${vulkan-loader}/lib/libvulkan.so.1 $out/opt/helium/libvulkan.so.1

    # Add RUNPATH for dlopen'd libs (EGL/DMA-BUF screen capture, PipeWire, VA-API)
    # autoPatchelfHook only handles directly linked deps, not dlopen'd ones
    patchelf --add-rpath "${lib.makeLibraryPath [ libglvnd mesa pipewire libpulseaudio wayland libva ]}" $out/opt/helium/helium

    # Icon
    install -Dm644 $out/opt/helium/product_logo_256.png $out/share/icons/hicolor/256x256/apps/helium-browser.png

    # Wrapper
    mkdir -p $out/bin
    makeWrapper $out/opt/helium/helium $out/bin/helium-browser \
      "''${gappsWrapperArgs[@]}" \
      "''${qtWrapperArgs[@]}" \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ libglvnd mesa vulkan-loader pipewire libpulseaudio libva wayland ]}:${addDriverRunpath.driverLink}/lib" \
      --add-flags "--ozone-platform-hint=auto --enable-features=WebRTCPipeWireCapturer,WaylandWindowDecorations --disable-gpu-rasterization" \
      --add-flags "--disable-component-update --disable-background-networking" \
      ${lib.optionalString (commandLineArgs != "") ''--add-flags "${commandLineArgs}"''}

    runHook postInstall
  '';

  meta = {
    description = "Private, fast, and honest web browser based on Chromium";
    homepage = "https://github.com/imputnet/helium-linux";
    mainProgram = "helium-browser";
    platforms = [ "x86_64-linux" ];
    license = with lib.licenses; [ gpl3Only bsd3 ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
