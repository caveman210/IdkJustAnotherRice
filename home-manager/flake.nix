{
  description = "Home Manager configuration of george";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    vicinae.url = "github:vicinaehq/vicinae";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, home-manager, vicinae, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      nixosConfigurations."george" = nixpkgs.lib.nixosSystem {
        system = system; # e.g., x86_64-linux
        modules = [
          # ... your other configuration modules ...
          vicinae.nixosModules.default
        ];
      };

      homeConfigurations."george" =
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;

          modules = [
            ./home.nix
            vicinae.homeManagerModules.default
          ];
        };
    };
}

