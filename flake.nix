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
      in
      {
        packages = {
          myscript = pkgs.writeScriptBin "myscript" ''
            echo foo
          '';
          output2 = pkgs.writeScriptBin "myscript2" ''
            chmod 777 myscript.sh
            ./myscript.sh;
          '';
          # nix run/build '.#output3'
          # if nix build was :xa
          output3 = pkgs.writeScriptBin "myscript" ''
            export PATH=${pkgs.lib.makeBinPath [ pkgs.hello ]}:$PATH
            chmod 777 run-hello.sh
            ${./run-hello.sh}
          '';
        };
      }
    );
}
