{ inputs, ... }:
{
  debug = true;
  perSystem =
    {
      pkgs,
      system,
      config,
      ...
    }:
    {
      packages = {
        backend = inputs.dream2nix.lib.evalModules {
          packageSets.nixpkgs = inputs.nixpkgs.legacyPackages.${system};
          modules = [
            ./package.nix
            {
              paths.projectRoot = ../..;
              paths.projectRootFile = "flake.nix";
              paths.package = ./code;
            }
          ];
        };
      };

      devShells.test = pkgs.mkShell {
        buildInputs = [ pkgs.pdm ];
        inputsFrom = [ config.packages.backend.devShell ];
      };
    };
}
