{pkgs, pkgs-unstable, ...}: {

  environment.systemPackages = [
    pkgs-unstable.claude-code
    pkgs-unstable.opencode
  ];

} 