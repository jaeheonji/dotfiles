{
  description = "A simple Typescript project";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      devShells.default = pkgs.mkShell {
        packages = with pkgs; [
          # Javascript/Typescript Runtime
          bun
          # nodejs
          # nodejs-slim

          # Development Tools
          nodePackages.typescript-language-server
        ];
      };
    });
}
