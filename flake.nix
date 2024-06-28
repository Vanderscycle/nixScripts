{
  description = "Testing writers for nix";
  # inputs = {
  #   nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  #   flake-utils.url = "github:numtide/flake-utils";
  # };
  outputs =
    { self, nixpkgs, ... }@inputs:
    let
      forAllSystems = nixpkgs.lib.genAttrs nixpkgs.lib.platforms.unix;

      nixpkgsFor = forAllSystems (system: import nixpkgs {
        inherit system;
      });
    in
    {

# https://discourse.nixos.org/t/basic-flake-run-existing-python-bash-script/19886/2
      # nix run ".#output1"
      output1 = {config, ...}:
      with nixpkgs.lig;
      {
      pkgs.writeScriptBin.myscript = ''
        echo foo
      '';
      };
    };
}
