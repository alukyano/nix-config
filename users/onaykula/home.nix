{pkgs, ...}: {
  ##################################################################################################################
  #
  # All onaykula Home Manager Configuration
  #
  ##################################################################################################################

  imports = [
    # ../../home/core.nix

    # ./fcitx5
    # ./i3
    # ./programs
    # ./rofi
    # ./shell
  ];

  programs.git = {
    userName = "onaykula";
    userEmail = "onaykula@gmail.com";
  };
}
