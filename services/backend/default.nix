{ inputs, ... }:
{
  debug = true;
  perSystem =
    {
      pkgs,
      lib,
      ...
    }:
    let

      # Load a uv workspace from a workspace root.
      # Uv2nix treats all uv projects as workspace projects.
      workspace = inputs.uv2nix.lib.workspace.loadWorkspace { workspaceRoot = ./code; };

      # Create package overlay from workspace.
      overlay = workspace.mkPyprojectOverlay {
        # Prefer prebuilt binary wheels as a package source.
        # Sdists are less likely to "just work" because of the metadata missing from uv.lock.
        # Binary wheels are more likely to, but may still require overrides for library dependencies.
        sourcePreference = "wheel"; # or sourcePreference = "sdist";
        # Optionally customise PEP 508 environment
        # environ = {
        #   platform_release = "5.10.65";
        # };
      };

      # Extend generated overlay with build fixups
      #
      # Uv2nix can only work with what it has, and uv.lock is missing essential metadata to perform some builds.
      # This is an additional overlay implementing build fixups.
      # See:
      # - https://adisbladis.github.io/uv2nix/FAQ.html
      pyprojectOverrides = _final: _prev: {
        # Implement build fixups here.
        tensorflow = _prev.tensorflow.overrideAttrs (old: {
          nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ pkgs.python312Packages.setuptools ];
        });
      };

      # Use Python 3.12 from nixpkgs
      python = pkgs.python312;

      # Construct package set
      pythonSet =
        # Use base package set from pyproject.nix builders
        (pkgs.callPackage inputs.pyproject-nix.build.packages {
          inherit python;
        }).overrideScope
          (lib.composeExtensions overlay pyprojectOverrides);

      # Create an overlay enabling editable mode for all local dependencies.
      editableOverlay = workspace.mkEditablePyprojectOverlay {
        # Use environment variable
        root = "$REPO_ROOT";
        # Optional: Only enable editable for these packages
        # members = [ "hello-world" ];
      };

      # Override previous set with our overrideable overlay.
      editablePythonSet = pythonSet.overrideScope editableOverlay;

      # Build virtual environment, with local packages being editable.
      #
      # Enable all optional dependencies for development.
      virtualenv = editablePythonSet.mkVirtualEnv "hello-world-dev-env" workspace.deps.all;
    in
    {
      devShells.test = pkgs.mkShell {
        # buildInputs = [poetryEnv.env.nativeBuildInputs];
        packages = [
          pkgs.uv
          virtualenv
        ];
        # GDAL_LIBRARY_PATH = "${pkgs.gdal}/lib/libgdal.so";
      };
    };
}
