{
  description = "Testing writers for nix";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs =
    { self, nixpkgs, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        system = system;
        config.allowUnfree = true;
      };
    in
    {
      # https://discourse.nixos.org/t/basic-flake-run-existing-python-bash-script/19886/2
      # nix run ".#output1"
      output1 = pkgs.writeScriptBin "myscript" ''
        echo foo
      '';
    };
}
