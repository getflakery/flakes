{
  description = "Flakery templates";

  outputs = { self, nixpkgs }:
    let
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
    in
    {

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
        flakery-dev = ./modules/flakery/dev.nix;
      };
      nixosConfigurations = {
        base =
          {

            environment.systemPackages = [
              pkgs.git
            ];
            system.stateVersion = "23.05"; # Did you read the comment?

            services.tailscale = {
              enable = true;
              authKeyFile = "/tsauthkey";
              extraUpFlags = [ "--ssh" ];
            };

            security.sudo.wheelNeedsPassword = false;
            users.users.alice = {
              isNormalUser = true;
              extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
              packages = with pkgs; [ ];
              group = "alice";
              # passwordFile = "/persist/passwords/alice";
            };
            users.groups.alice = { };
            environment.variables = { EDITOR = "nvim"; };
            programs.neovim.enable = true;
            # alias nvim to vim globally
            programs.neovim.vimAlias = true;
            programs.neovim.defaultEditor = true;
            nixpkgs.config.allowUnfree = true;

            nix = {
              gc = {
                automatic = true;
                dates = "weekly";
                options = "--delete-older-than 7d";
              };
              settings = {
                experimental-features = [ "nix-command" "flakes" ];
                substituters = [
                  # "https://cache.garnix.io"
                  "https://nix-community.cachix.org"
                  "https://cache.nixos.org/"
                ];
                trusted-public-keys = [
                  "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
                  # "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
                ];
              };
            };
          };
      };
    };
}
