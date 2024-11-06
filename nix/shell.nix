{
  perSystem =
    { pkgs, config, ... }:
    {
      devShells.default = pkgs.mkShellNoCC {
        packages = with pkgs; [
          yarn
          pipenv
          pyenv
          just
          python39Full
          postgresql # needed by `pipenv install`, FIXME make version explicit
          gcc # needed by `pipenv install`
          graphviz # needed by pygraphviz
        ];
        shellHook = ''
          ${config.pre-commit.installationScript}
        '';
      };
    };
}
