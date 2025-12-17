{
  pkgs,
  username,
  ...
}:
{
  virtualisation.podman = {
    enable = true;
    dockerCompat = false;
    defaultNetwork.settings.dns_enabled = true;
    extraPackages = with pkgs; [ 
        odman-tui
        podman-compose 
        ];
  };

  users.users.${username}.extraGroups = [ "podman" ];
}