{pkgs, pkgs-unstable, ...}: {

  environment.systemPackages = [
    pkgs.claude-code
    pkgs-unstable.opencode
  ];

} 