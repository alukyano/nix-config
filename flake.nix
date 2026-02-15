{
  description = "Nixos alukyano global config flake for fershiedene hosts";
 
 # the nixConfig here only affects the flake itself, not the system configuration!
  nixConfig = {
    # substituers will be appended to the default substituters when fetching packages
    # nix com    extra-substituters = [munity's cache server
    extra-substituters = [
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];

  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    
    home-manager = {
       url = "github:nix-community/home-manager/release-25.11";
       inputs.nixpkgs.follows = "nixpkgs";
    };

     nixai.url = "github:olafkfreund/nix-ai-help";
  };

outputs = inputs @ {
    self,
    nixpkgs,
    nixpkgs-unstable,
    home-manager,
    ...
  }: {
    nixosConfigurations = {
      buldozer = let
        username = "alukyano";
        desktop = "xfce";
        pkgs-unstable = import nixpkgs-unstable {
          system = "x86_64-linux";
          config = {
            allowUnfree = true;
          };  
          overlays = [ (import ./overlays/buldozer.nix) ];   
        };

        #specialArgs = {inherit pkgs-unstable llm-agents username desktop;};
        specialArgs = {inherit pkgs-unstable username desktop;};
      in
        nixpkgs.lib.nixosSystem {
          inherit specialArgs;
          system = "x86_64-linux";

          modules = [
            ./hosts/buldozer
            ./users/${username}/nixos.nix

            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;

              home-manager.extraSpecialArgs = inputs // specialArgs;
              home-manager.users.${username} = import ./users/${username}/home.nix;
            }
          ];
        };

      msc-xalukyano = let
        username = "alukyano";
        desktop = "gnome";
        pkgs-unstable = import nixpkgs-unstable {
          system = "x86_64-linux";
          config = {
            allowUnfree = true;
          };
        };            
        specialArgs = {inherit username desktop pkgs-unstable;};
      in
        nixpkgs.lib.nixosSystem {
          inherit specialArgs;
          system = "x86_64-linux";

          modules = [
            ./hosts/msc-xalukyano
            ./users/${username}/nixos.nix

            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;

              home-manager.extraSpecialArgs = inputs // specialArgs;
              home-manager.users.${username} = import ./users/${username}/home.nix;
            }
          ];
        };

      sputnik = let
        username = "alukyano";
        desktop = "gnome";
        pkgs-unstable = import nixpkgs-unstable {
          system = "x86_64-linux";
          config = {
            allowUnfree = true;
          };
          overlays = [ (import ./overlays/sputnik.nix) ];
        };            
        specialArgs = {inherit username desktop pkgs-unstable;};
      in
        nixpkgs.lib.nixosSystem {
          inherit specialArgs;
          system = "x86_64-linux";

          modules = [
            ./hosts/sputnik
            ./users/${username}/nixos.nix

            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;

              home-manager.extraSpecialArgs = inputs // specialArgs;
              home-manager.users.${username} = import ./users/${username}/home.nix;
            }
          ];
        };

      saturn = let
        username = "alukyano";
        desktop = "gnome";
        pkgs-unstable = import nixpkgs-unstable {
          system = "x86_64-linux";
          config = {
            allowUnfree = true;
          };
        };            
        specialArgs = {inherit username desktop pkgs-unstable;};
      in
        nixpkgs.lib.nixosSystem {
          inherit specialArgs;
          system = "x86_64-linux";

          modules = [
            ./hosts/saturn
            ./users/${username}/nixos.nix

            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;

              home-manager.extraSpecialArgs = inputs // specialArgs;
              home-manager.users.${username} = import ./users/${username}/home.nix;
            }
          ];
        };

      moon = let
        username = "alukyano";
        desktop = "gnome";
        pkgs-unstable = import nixpkgs-unstable {
          system = "x86_64-linux";
          config = {
            allowUnfree = true;
          };
          overlays = [ (import ./overlays/moon.nix) ];
        };          
        specialArgs = {inherit username desktop pkgs-unstable;};
      
      in
        nixpkgs.lib.nixosSystem {
          inherit specialArgs;
          system = "x86_64-linux";

          modules = [
            ./hosts/moon
            ./users/${username}/nixos.nix

            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;

              home-manager.extraSpecialArgs = inputs // specialArgs;
              home-manager.users.${username} = import ./users/${username}/home.nix;
            }
          ];
        };
         
    };
  };
}
