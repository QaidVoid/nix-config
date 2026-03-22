{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  wrapGAppsHook3,
  autoPatchelfHook,
  makeWrapper,
  alsa-lib,
  atk,
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
  gnome-screenshot,
  grim,
  gtk3,
  imagemagick,
  libappindicator-gtk3,
  libcxx,
  libdrm,
  libgbm,
  libglvnd,
  libnotify,
  libpulseaudio,
  libsecret,
  libuuid,
  libX11,
  libXcomposite,
  libXcursor,
  libXdamage,
  libXext,
  libXfixes,
  libXi,
  libXrandr,
  libXrender,
  libXScrnSaver,
  libXtst,
  libxcb,
  libxkbcommon,
  mesa,
  nodePackages,
  nspr,
  nss,
  pango,
  pkg-config,
  systemd,
  vips,
  xdg-utils,
}:

stdenv.mkDerivation rec {
  pname = "scrinio";
  version = "6.20.0";

  src = fetchurl {
    url = "https://github.com/ScreenshotMonitor/scrinio-app-releases/releases/download/v6.20.0/scrinio-amd64.deb";
    sha256 = "sha256-fRZWFGnyWHFjkFouTZbEyDz7tzaVoFsI+pcmPLhhLAw=";
  };

  nativeBuildInputs = [
    dpkg
    wrapGAppsHook3
    autoPatchelfHook
    makeWrapper
    pkg-config
    nodePackages.asar
  ];

  buildInputs = [
    libcxx
    systemd
    libpulseaudio
    stdenv.cc.cc
    alsa-lib
    atk
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
    libappindicator-gtk3
    libdrm
    libgbm
    libglvnd
    libnotify
    libsecret
    libuuid
    libX11
    libXcomposite
    libXcursor
    libXdamage
    libXext
    libXfixes
    libXi
    libXrandr
    libXrender
    libXScrnSaver
    libXtst
    libxcb
    libxkbcommon
    mesa
    nspr
    nss
    pango
    vips
  ];

  libPath = lib.makeLibraryPath buildInputs;

  dontWrapGApps = true;

  # Ignore musl libc - we only need glibc variants
  autoPatchelfIgnoreMissingDeps = [ "libc.musl-x86_64.so.1" ];

  unpackPhase = ''
    dpkg-deb -x $src .
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/opt $out/share
    cp -r opt/scrin.io $out/opt/
    cp -r usr/share/* $out/share/

    # Patch asar: reorder Wayland screenshot backends + sharp error fallback
    asar extract $out/opt/scrin.io/resources/app.asar $out/opt/scrin.io/resources/app

    # Prefer grim over desktopCapturer on generic Wayland
    # desktopCapturer returns black screens on Wayland; grim captures properly
    substituteInPlace $out/opt/scrin.io/resources/app/dist-main/main/utils/platform/LinuxStrategy.js \
      --replace-fail \
        'genericWayland: [
        "desktopCapturer",
        "portalScreencast",
        "grim",
        "gnome-screenshot",
        "flameshot",
    ]' \
        'genericWayland: [
        "grim",
        "portalScreencast",
        "gnome-screenshot",
        "flameshot",
        "desktopCapturer",
    ]'

    # Fallback to raw image buffer if sharp worker crashes
    substituteInPlace $out/opt/scrin.io/resources/app/dist-main/main/utils/screenshot/takeScreenshot.js \
      --replace-fail \
        'log.error("❌ Error processing images:", {
            message: err?.message || String(error),
            stack: err?.stack,
            stderr: err?.stderr,
            format,
            stats: getBufferStats(imageBuffers),
        });
    }
}' \
        'log.error("❌ Error processing images:", {
            message: err?.message || String(error),
            stack: err?.stack,
            stderr: err?.stderr,
            format,
            stats: getBufferStats(imageBuffers),
        });
        if (imageBuffers.length > 0) {
            log.info("⚠️ Falling back to raw buffer");
            return { buffer: imageBuffers[0], format: "png" };
        }
    }
}'

    # Capture only the specified display via GRIM_OUTPUT env var
    substituteInPlace $out/opt/scrin.io/resources/app/dist-main/main/utils/platform/LinuxStrategy.js \
      --replace-fail \
        'return this.runTempFileScreenshot("grim", ["{FILE}"], ".jpg");' \
        'return this.runTempFileScreenshot("grim", process.env.GRIM_OUTPUT ? ["-o", process.env.GRIM_OUTPUT, "{FILE}"] : ["{FILE}"], ".jpg");'

    asar pack $out/opt/scrin.io/resources/app $out/opt/scrin.io/resources/app.asar
    rm -rf $out/opt/scrin.io/resources/app

    # Now remove arm64 and musl variants from unpacked (keep linux-x64)
    rm -rf $out/opt/scrin.io/resources/app.asar.unpacked/node_modules/@img/sharp-linux-arm64
    rm -rf $out/opt/scrin.io/resources/app.asar.unpacked/node_modules/@img/sharp-libvips-linux-arm64
    rm -rf $out/opt/scrin.io/resources/app.asar.unpacked/node_modules/@img/sharp-linuxmusl-*
    rm -rf $out/opt/scrin.io/resources/app.asar.unpacked/node_modules/@img/sharp-libvips-linuxmusl-*

    chmod +x $out/opt/scrin.io/scrinio

    sed -e "s|/opt/scrin.io/scrinio|$out/bin/scrinio|g" -i $out/share/applications/scrinio.desktop

    makeWrapper $out/opt/scrin.io/scrinio $out/bin/scrinio \
      --prefix PATH : "${lib.makeBinPath [ grim gnome-screenshot imagemagick xdg-utils ]}" \
      --prefix XDG_DATA_DIRS : "${gtk3}/share/gsettings-schemas/${gtk3.name}/" \
      --prefix LD_LIBRARY_PATH : "${libPath}:$out/opt/scrin.io/resources/app.asar.unpacked/node_modules/@img/sharp-libvips-linux-x64/lib"

    runHook postInstall
  '';

  meta = {
    description = "Screenshot monitoring app";
    homepage = "https://github.com/ScreenshotMonitor/scrinio-app-releases";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    platforms = [ "x86_64-linux" ];
    mainProgram = "scrinio";
  };
}
