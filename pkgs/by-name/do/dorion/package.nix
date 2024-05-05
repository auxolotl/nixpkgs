{ lib
, stdenv
, fetchurl
, autoPatchelfHook
, dpkg
, glib-networking
, gst_all_1
, libappindicator
, libayatana-appindicator
, webkitgtk
, wrapGAppsHook3
}:

stdenv.mkDerivation (finalAttrs: {
  name = "dorion";
  version = "4.2.0";

  src = fetchurl {
    url = "https://github.com/SpikeHD/Dorion/releases/download/v${finalAttrs.version }/Dorion_${finalAttrs.version}_amd64.deb";
    hash = "sha256-QqjRxAx2hDd8atpXuof8AVWtK3o8K77Se2b2CyOBMOw=";
  };

  unpackCmd = ''
    dpkg -X $curSrc .
  '';

  runtimeDependencies = [
    glib-networking
    libappindicator
    libayatana-appindicator
  ];

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
    wrapGAppsHook3
  ];

  buildInputs = [
    glib-networking
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    webkitgtk
  ];

  installPhase = ''
    runHook preInstall

    mkdir -pv $out
    mv -v {bin,lib,share} $out

    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/SpikeHD/Dorion";
    description = "Tiny alternative Discord client";
    license = lib.licenses.gpl3Only;
    mainProgram = "dorion";
    maintainers = with lib.maintainers; [ ];
    platforms = lib.intersectLists (lib.platforms.linux) (lib.platforms.x86_64);
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
