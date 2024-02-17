{
  description = "basic flake-utils";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";


  outputs = { self, nixpkgs, flake-utils, ... }:
    (flake-utils.lib.eachDefaultSystem
      (system:
        let
          pkgs = import nixpkgs {
            inherit system;
          };

          devshell = pkgs.mkShell {
            buildInputs = with pkgs; [
              hello
            ];
          };

          app =
            stdenv.mkDerivation rec {
              name = "hello-world-1.0";
              version = "1.0";
              src = fetchurl {
                url = "http://example.com/${name}-${version}.tar.gz";
                sha256 = ""; # replace this with the actual hash
              };

              buildInputs = [ /* dependencies */ ];

              buildPhase = ''
                ./configure --prefix=$out
                make
              '';

              installPhase = ''
                make install
              '';

              meta = {
                description = "A simple Hello World program";
                homepage = "http://example.com/";
                license = stdenv.lib.licenses.mit;
              };
            };
        in
        {
          app = app;
          packages.default = app;
          devShells.default = devshell;

        })
    );
}
