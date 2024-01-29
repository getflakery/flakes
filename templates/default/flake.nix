{
  outputs = { self, nixpkgs }: {
    nixosConfigurations.default = nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";
      modules = [ 
        ./configuration.nix
        ./hello.nix
      ];
    };
  };
}