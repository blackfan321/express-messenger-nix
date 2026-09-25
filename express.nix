{
  lib,
  stdenv,
  appimageTools,
  fetchurl,
  ...
}:

let
  pname = "express";

  linuxSources = {
    version = "3.73.51";
    x86_64-linux = {
      hash = "sha256-WMhyfKpSwSDuOPQ4g2TtcLzRg71jaGXoa/5bqVqWo6I=";
    };
  };

  darwinSources = {
    version = "3.73.51";
    aarch64-darwin = {
      hash = "sha256-jqbimLJD+dsU362NWdYnw8uT/xq15m6CbVT2V4zaUgA=";
    };
  };

  system = stdenv.hostPlatform.system;

  platformNames =
    sources: lib.filter (name: lib.isAttrs sources.${name}) (builtins.attrNames sources);

  meta = with lib; {
    description = "eXpress Messenger";
    longDescription = ''
      Desktop client for eXpress Messenger
    '';
    mainProgram = pname;
    homepage = "https://express.ms/";
    downloadPage = "https://express.ms/download/#web-desktop";
    license = licenses.unfree;
    maintainers = with maintainers; [ blackfan321 ];
    platforms = platformNames linuxSources ++ platformNames darwinSources;
  };
in
if stdenv.hostPlatform.isLinux then
  let
    source = linuxSources.${system} or (throw "Unsupported system: ${system}");
    inherit (linuxSources) version;
    src = fetchurl {
      url = "https://updates.express.ms/desktop/eXpress-${version}.AppImage";
      inherit (source) hash;
    };
    appimageContents = appimageTools.extract {
      inherit pname src version;
    };
    mkDesktop = import ./desktop-helper.nix;
  in
  appimageTools.wrapType2 {
    inherit
      pname
      src
      meta
      version
      ;

    extraInstallCommands = mkDesktop {
      inherit pname appimageContents;
    };
  }
else if stdenv.hostPlatform.isDarwin then
  let
    source = darwinSources.${system} or (throw "Unsupported system: ${system}");
    inherit (darwinSources) version;
  in
  stdenv.mkDerivation {
    inherit pname meta version;

    src = fetchurl {
      url = "https://updates.express.ms/desktop/eXpress-${version}-arm64.dmg";
      inherit (source) hash;
    };

    # hdiutil lives outside the Nix sandbox.
    __noChroot = true;

    dontBuild = true;
    dontFixup = true;

    sourceRoot = "eXpress.app";

    unpackPhase = ''
      runHook preUnpack

      tmp=$(mktemp -d)
      /usr/bin/hdiutil attach "$src" -mountpoint "$tmp" -nobrowse -quiet
      app=$(find "$tmp" -maxdepth 2 -name 'eXpress.app' -type d | head -n1)
      cp -R "$app" ./eXpress.app
      /usr/bin/hdiutil detach "$tmp" -quiet
      rm -rf "$tmp"

      runHook postUnpack
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p "$out/Applications/eXpress.app"
      cp -R Contents "$out/Applications/eXpress.app/"

      runHook postInstall
    '';
  }
else
  throw "Unsupported system: ${system}"
