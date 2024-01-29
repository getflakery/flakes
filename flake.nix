{
  description = "Flakery templates";

  outputs = { self, nixpkgs }: {

    templates = {
      default = {
        path = ./templates/default;
        description = "default application for flakery";
      };
    };
    defaultTemplate = self.templates.default;

  };
}
