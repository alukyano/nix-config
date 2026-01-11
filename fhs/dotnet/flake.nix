{
  description = ".NET development environment based on the Filesystem Hierarchy Standard (FHS)";
  # https://en.wikipedia.org/wiki/Filesystem_Hierarchy_Standard

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    #nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { nixpkgs, ... } @ inputs:
  let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};

    # .NET SDKs
    dotnet_sdk = (with pkgs.dotnetCorePackages; combinePackages [
      # Install all the .NET SDK versions needed here...
       sdk_8_0
      # sdk_7_0
      # sdk_6_0
    ]);
  in
  {
    # Create development shell based on the Filesystem Hierarchy Standard (FHS) with a set of
    # standard packages based on the list maintained by the appimagetools package
    #
    # buildFHSEnv -> https://nixos.org/manual/nixpkgs/stable/#sec-fhs-environments
    #
    # The packages included in appimagetools.defaultFhsEnvArgs are:
    # https://github.com/NixOS/nixpkgs/blob/fd6a510ec7e84ccd7f38c2ad9a55a18bf076f738/pkgs/build-support/appimage/default.nix#L72-L208
    devShells.${system}.default = (pkgs.buildFHSEnv (pkgs.appimageTools.defaultFhsEnvArgs // {
          name = "dotnet-development-environment";
          # Packages installed in the development shell
          targetPkgs = pkgs: with pkgs; [
            # .NET SDK
            dotnet_sdk
            # Run PowerShell scripts, which are sometimes included in NuGet packages like Playwright
            powershell
            # Timezones
            tzdata
            # Locales
            glibcLocales
          ];
          # Commands to be executed in the development shell
          profile = ''
            # Ensure that dotnet tools can find the .NET location
            export DOTNET_ROOT="${dotnet_sdk}";

            # Set LANG for locales, otherwise it is unset when running "nix-shell --pure"
            export LANG="C.UTF-8"

            # Remove duplicate commands from Bash shell command history
            export HISTCONTROL=ignoreboth:erasedups

            # Do not pollute $HOME with config files (both paths are ignored in .gitignore)
            export DOTNET_CLI_HOME="$PWD/.net_cli_home";
            export NUGET_PACKAGES="$PWD/.nuget_packages";

            # Put dotnet tools in $PATH to be able to use them
            export PATH="$DOTNET_CLI_HOME/.dotnet/tools:$PATH"
          '';
        })).env;
  };
}