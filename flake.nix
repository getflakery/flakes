{
  description = "Flakery templates";

  outputs = { self, nixpkgs }: {

    templates = {
      quickstart = {
        path = ./templates/quickstart;
        description = "quickstart application for flakery";
      };
      futils = {
        path = ./templates/flake-utils;
        description = "flake utils starter";
      };
      rust = {
        path = ./templates/rust;
        description = "rust nix app";
      };
    };

    nixosModules = {
      flakery = ./modules/flakery/mod.nix;
    }
  };
}
