{

  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  inputs.poetry2nix = {
    url = "github:nix-community/poetry2nix";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, flake-utils, poetry2nix }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        inherit (poetry2nix.legacyPackages.${system})
          mkPoetryApplication
          overrides;
        # pkgs = nixpkgs.legacyPackages.${system};
        pkgs = import nixpkgs {
          inherit system;
        };

        our-poetry = pkgs.writeShellScriptBin "poetry" ''
        # Wrap in libraries expected by numpy etc
        export LD_LIBRARY_PATH=${pkgs.stdenv.cc.cc.lib}/lib/
        export LD_LIBRARY_PATH="${pkgs.lib.makeLibraryPath [ pkgs.zlib ]}:$LD_LIBRARY_PATH"
        export LD_LIBRARY_PATH="${pkgs.lib.makeLibraryPath [ pkgs.expat ]}:$LD_LIBRARY_PATH"
        # exec ${poetry2nix.packages.${system}.poetry}/bin/poetry $@
        exec ${pkgs.poetry}/bin/poetry $@
        '';
       
      in
      {

        devShells.default = pkgs.mkShell {
          packages = [
            # poetry2nix.packages.${system}.poetry
            our-poetry
            pkgs.git
            pkgs.python3Packages.ipython
            pkgs.awscli
            pkgs.meld
            pkgs.makefile2graph
            pkgs.graphviz
            # MacOS
            pkgs.hdf5.dev
          ];
          shellHook = ''
          export HDF5_DIR=${pkgs.hdf5.dev}
          '';
        };
        
      });
}
