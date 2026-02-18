{pkgs, pkgs-unstable, ...}: {
  services.n8n = {
    enable = true;
    openFirewall = true;
  };
  environment.systemPackages = [
    pkgs-unstable.n8n
  ];  
}