{ inputs, ... }:
{
  imports = [
    inputs.git-hooks.flakeModule
    inputs.treefmt-nix.flakeModule
  ];

  perSystem =
    { ... }:
    {
      treefmt.config = {
        projectRootFile = ".git/config";
        programs = {
          nixfmt.enable = true;
          deadnix.enable = true;
          black.enale = true;
        };
      };

      pre-commit.settings.hooks = {
        nixfmt-rfc-style.enable = true;
        deadnix.enable = true;
        black.enable = true;
      };
    };
}
