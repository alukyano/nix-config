{pkgs, ...}: {
  ##################################################################################################################
  #
  # All alukyano Home Manager Configuration
  #
  ##################################################################################################################

  imports = [
    ../../home/core.nix
    ../../home/programs
    ../../home/xfce
    # ../../home/fcitx5
    # ../../home/i3
     ../../home/rofi
     ../../home/shell
  ];


  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  programs.git = {
    userName = "alukyano";
    userEmail = "alukyano@gmail.com";
  };
}
