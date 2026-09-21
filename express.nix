{
  lib,
  appimageTools,
  fetchurl,
  ...
}:

let
  pname = "express";
  version = "3.73.51";

  src = fetchurl {
    url = "https://updates.express.ms/desktop/eXpress-${version}.AppImage";
    hash = "sha256-WMhyfKpSwSDuOPQ4g2TtcLzRg71jaGXoa/5bqVqWo6I=";
  };

  appimageContents = appimageTools.extract { inherit pname version src; };
  mkDesktop = import ./desktop-helper.nix;
in appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = mkDesktop {inherit pname; inherit appimageContents;};

  meta = with lib; {
    description = "eXpress client";
    longDescription = ''
      Desktop client for eXpress Messenger
    '';

    mainProgram = pname;
    homepage = "https://express.ms/";
    downloadPage = "https://express.ms/download/#web-desktop";
    license = licenses.unfree;
    maintainers = with maintainers; [ blackfan321 ];
    platforms = [ "x86_64-linux" ];
  };
}
