{
  description = "Flakery templates";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/24.05";


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

      packages.x86_64-linux.test = pkgs.testers.runNixOSTest
        {
          skipLint = true;
          name = "Test prometheus";



          nodes = {
            machine = { pkgs, ... }: {
              # Empty config sets some defaults
              imports = [
                ./modules/flakery/dev.nix
              ];
            };

            machine2 = { ... }: {
              # Empty config sets some defaults

            };

          };

          testScript = ''
            start_all()
            # wait for port 9002
            machine.wait_for_open_port(9002)
            #  curl -I  localhost:9002 | grep -q "200 OK"
            status, out = machine.execute("curl -I  localhost:9002 | curl -I localhost:9002 | grep '200 OK'")
            assert status == 0
            assert "200 OK" in out
            status, out = machine2.execute("curl -I  machine:9002 | curl -I machine:9002 | grep '200 OK'")
            assert status == 0
            assert "200 OK" in out
          '';
        };


    };
}
