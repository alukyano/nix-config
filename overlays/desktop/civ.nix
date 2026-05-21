self: super: {
    classic-image-viewer = super.appimageTools.wrapType2 {
    src = super.fetchurl {
      url = "https://github.com/classicimageviewer/ClassicImageViewer/releases/download/v1.5.0/ClassicImageViewer-x86_64.AppImage";
      sha256 = "sha256-M4CSBv22Hvy99vHyuxUV2dnkY4Vz7EjM7FKIVuYwgVQ=";
    };
    pname = "classic-image-viewer";
    version = "1.5.0";
  };  
}