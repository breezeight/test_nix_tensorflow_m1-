# An example package with dependencies defined via pyproject.toml
{
  lib,
  dream2nix,
  ...
}:
{
  imports = [
    dream2nix.modules.dream2nix.WIP-python-pdm
  ];

  mkDerivation = {
    src = lib.cleanSourceWith {
      src = lib.cleanSource ./code;
      filter =
        name: _type:
        !(builtins.any (x: x) [
          (lib.hasSuffix ".nix" name)
          (lib.hasPrefix "." (builtins.baseNameOf name))
          (lib.hasSuffix "flake.lock" name)
        ]);
    };
  };
  pdm.lockfile = ./code/pdm.lock;
  pdm.pyproject = ./code/pyproject.toml;

  buildPythonPackage =
    {
    };
}
