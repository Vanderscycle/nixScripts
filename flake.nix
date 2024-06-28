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
      pkgs.writeScriptBin "myscript" ''
        echo foo
      '';
      }
      
      # nix run ".#output2"
      # ensure that there is ./myscript.sh locally
      output2 = pkgs.writeScriptBin "myscript" ''
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
