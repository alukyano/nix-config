{pkgs, ...}: {
  ##################################################################################################################
  #
  # All alukyano Home Manager Configuration
  #
  ##################################################################################################################

  imports = [
    ../../home/core.nix

    # ../../home/fcitx5
    # ../../home/i3
    # ../../home/programs
    # ../../home/rofi
    # ../../home/shell
  ];


  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  programs.git = {
    userName = "alukyano";
    userEmail = "alukyano@gmail.com";
  };
}
