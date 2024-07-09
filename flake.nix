{
  description = "Testing writers for nix";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      ...
    }@inputs:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
        src = ./g-update/main.go;
      in
      {

        packages = {
          output1 = pkgs.writeScriptBin "myscript" ''
            echo foo
          '';
          output2 = pkgs.writeScriptBin "myscript2" ''
            chmod 777 myscript.sh
            ./myscript.sh;
          '';
          # nix run/build '.#output3'
          # if nix build was :xa
          output3 = pkgs.writeScriptBin "myscript3" ''
            export PATH=${pkgs.lib.makeBinPath [ pkgs.hello ]}:$PATH
            chmod 777 run-hello.sh
            ${./run-hello.sh}
          '';

          output4 = pkgs.stdenv.mkDerivation {
            name = "myscript";
            src = ./g-update/main.go;
            buildInputs = [ pkgs.go ];
            installPhase = ''
              go build -o $out/bin/myscript ${src}
            '';
          };
        };
      }
    );
}
