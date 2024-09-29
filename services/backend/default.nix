{inputs, ...}: {
  debug = true;
  perSystem = {pkgs, config, ...}: let
    inherit (inputs.poetry2nix.lib.mkPoetry2Nix {inherit pkgs;}) mkPoetryEnv overrides;
    poetryEnv = mkPoetryEnv {
      projectDir = ./code; # TODO consider a filter
      python = pkgs.python39;
      overrides = overrides.withDefaults (final: prev: {
        drf-flex-fields = prev.drf-flex-fields.overridePythonAttrs (old: {
          nativeBuildInputs = old.nativeBuildInputs or [ ] ++ [ final.setuptools ];
        });
        argparse = prev.argparse.overridePythonAttrs (old: {
          nativeBuildInputs = old.nativeBuildInputs or [ ] ++ [ final.setuptools ];
        });
        django-jsonfield-backport = prev.django-jsonfield-backport.overridePythonAttrs (old: {
          nativeBuildInputs = old.nativeBuildInputs or [ ] ++ [ final.setuptools ];
        });
        opt-einsum = prev.opt-einsum.overridePythonAttrs (old: {
          nativeBuildInputs = old.nativeBuildInputs or [ ] ++ [ final.hatchling ];
        });
        gast = pkgs.python39Packages.gast; # FIXME this is bad but the version in the lockfile makes sicpy fail to build
      });
    };
  in {
    devShells.test = pkgs.mkShell {
      buildInputs = [poetryEnv.env.nativeBuildInputs];
      GDAL_LIBRARY_PATH = "${pkgs.gdal}/lib/libgdal.so";
    };
  };
}
