{
  description = "Testing writers for nix";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    gomod2nix = {
      url = "github:nix-community/gomod2nix";
      inputs = {
        flake-utils.follows = "flake-utils";
        nixpkgs.follows = "nixpkgs";
      };
    };
    pre-commit-hooks.url = "github:cachix/pre-commit-hooks.nix";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      gomod2nix,
      ...
    }@inputs:
    flake-utils.lib.eachSystem [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ] (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
        callPackage = pkgs.callPackage; # pkgs.darwin.apple_sdk_11_0.callPackage or
      in
      {

        packages = {
          output1 = pkgs.writeScriptBin "myscript" ''
            echo foo
          '';
          output2 = pkgs.writeScriptBin "myscript2" ''
            export PATH=${pkgs.lib.makeBinPath [ pkgs.cmatrix ]}:$PATH
            chmod 777 myscript.sh
            ./myscript.sh;
            echo "Running cmatrix for 3 seconds..."
            cmatrix -s -u 9 -C blue &
            sleep 5
            kill $!
          '';
          # nix run/build '.#output3'
          output3 = pkgs.writeScriptBin "myscript3" ''
            export PATH=${pkgs.lib.makeBinPath [ pkgs.hello ]}:$PATH
            chmod 777 run-hello.sh
            ${./run-hello.sh}
          '';
          output4 = callPackage ./g-update/. {
            inherit (gomod2nix.legacyPackages.${system}) buildGoApplication;
          };
          helloGo = callPackage ./g-hello/. {
            inherit (gomod2nix.legacyPackages.${system}) buildGoApplication;
          };
        };
      }
    );
}
