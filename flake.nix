{
  description = "Flakery templates";

  outputs = { self, nixpkgs }: {

    templates = {
      default = {
        path = ./templates/default;
        description = "default application for flakery";
      };
      futils = {
        path = ./templates/flake-utils;
        description = "default application for flakery";
      };
          rust = {
        path = ./templates/rust;
        description = "default application for rust";
      };
    };

  };
}
