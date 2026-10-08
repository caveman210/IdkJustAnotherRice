{
  description = "NixOS setup with system-level qylock";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    qylock.url = "github:Darkkal44/qylock";
    qylock.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, qylock, ... }@inputs: {
    nixosConfigurations.nixpad = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        # 1. Import qylock's NixOS module directly
        qylock.nixosModules.default

        # 2. Include your system configuration
        ./configuration.nix
      ];
    };
  };
}
