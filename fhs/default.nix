{ pkgs ? import <nixpkgs> {} }:

(pkgs.buildFHSUserEnv {
  name = "dev-env";
  targetPkgs = pkgs: (with pkgs;
    [ gdk-pixbuf
      glib
      glibc
      gtk3-x11
      libkrb5
    ]) ++ (with pkgs.xorg;
    [ libX11
      libXcursor
      libXrandr
      libXext
    ]);
  runScript = "bash";
}).env