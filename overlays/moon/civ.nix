self: super: {
    classic-image-viewer = super.appimageTools.wrapType2 {
    src = super.fetchurl {
      url = "https://github.com/classicimageviewer/ClassicImageViewer/releases/download/v1.5.0/ClassicImageViewer-x86_64.AppImage";
      sha256 = "sha256-SgdsIcRu05mJA/bchyIPJ+bZgga4cp4KI4VaqJoRrpE=";
    };
    pname = "classic-image-viewer";
    version = "1.5.0";
  };  
}