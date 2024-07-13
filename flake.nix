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
      pre-commit-hooks,
      ...
    }@inputs:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
        callPackage = pkgs.darwin.apple_sdk_11_0.callPackage or pkgs.callPackage;
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
          output3 = pkgs.writeScriptBin "myscript3" ''
            export PATH=${pkgs.lib.makeBinPath [ pkgs.hello ]}:$PATH
            chmod 777 run-hello.sh
            ${./run-hello.sh}
          '';
          output4 = callPackage ./g-update/. {
            inherit (gomod2nix.legacyPackages.${system}) buildGoApplication;
          };

        };
      }
    );
}
