{
  description = "Demand Analysis";

  inputs.nixpkgs.url = github:NixOS/nixpkgs/nixos-unstable;
  inputs.lean.url = github:leanprover/lean4;
  inputs.flake-utils.url = github:numtide/flake-utils;
  inputs.flake-utils.inputs.nixpkgs.follows = "nixpkgs";

  outputs = { self, nixpkgs, flake-utils, lean}: flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = nixpkgs.legacyPackages.${system};
      leanPkgs = lean.packages.${system};
      pkg = leanPkgs.buildLeanPackage {
        name = "DmdAnal";  # must match the name of the top-level .lean file
        src = ./.;
      };
    in {
      packages = pkg // {
        inherit (leanPkgs) lean;
      };

      defaultPackage = pkg.modRoot;

      devShell = pkgs.mkShell {
        buildInputs = with pkgs; [ elan ];
      };
    });
}
