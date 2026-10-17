{
  lib,
  stdenv,
  appimageTools,
  fetchurl,
  fetchgit,
  fetchFromGitHub,
  dockerTools,
  undmg,
  ...
}:

let
  inherit (import ./flake/systems.nix) systems;

  system = stdenv.hostPlatform.system;

  sources = import ./_sources/generated.nix {
    inherit
      fetchgit
      fetchurl
      fetchFromGitHub
      dockerTools
      ;
  };

  pname = "express";

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
    platforms = systems;
  };
in
if !(lib.elem system systems) then
  throw "Unsupported system: ${system}"
else if stdenv.hostPlatform.isLinux then
  let
    inherit (sources.express-linux) version src;
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
else
  let
    inherit (sources.express-darwin) version src;
  in
  stdenv.mkDerivation {
    inherit
      pname
      meta
      version
      src
      ;

    nativeBuildInputs = [ undmg ];

    dontBuild = true;
    dontFixup = true;

    sourceRoot = "eXpress.app";

    installPhase = ''
      runHook preInstall

      mkdir -p "$out/Applications"
      cp -R . "$out/Applications/eXpress.app"

      runHook postInstall
    '';
  }
