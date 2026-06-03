{ pkgs, username, ... }:
{
  virtualisation.docker = {
    enable = true;
  };

  environment.systemPackages = with pkgs; [
      docker
  ];
  
  users.users.${username}.extraGroups = [ "docker" ];
}