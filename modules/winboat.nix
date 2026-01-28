{config, pkgs, nixpkgs-unstable, username, ...}: {

  environment.systemPackages = with nixpkgs-unstable.packages.${pkgs.stdenv.hostPlatform.system}; [
    winboat
  ];

} 
