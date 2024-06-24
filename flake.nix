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
      flakery = {
        path = ./templates/flakery;
        description = "use this template to deploy nixos on flakery";
      };
      go-webserver = {
        path = ./templates/go-webserver;
        description = "use this template to deploy a go webserver on flakery";
      };
      jupyter-notebook = {
        path = ./templates/jupyter-notebook;
      };
    };

    nixosModules = {
      flakery = ./modules/flakery/mod.nix;
      base = ./modules/flakery/base.nix;

    };
  };
}
