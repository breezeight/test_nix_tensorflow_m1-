{
  perSystem = {config, pkgs, lib, ...}: {
    packages = {
      frontend-client = pkgs.mkYarnPackage {
        name = "idr-channelguard-frontend-client";
        src = ./client; # TODO consider a filter

        packageJSON = ./client/package.json;
        yarnLock = ./yarn.lock;

        buildPhase = ''
          yarn --offline build
        '';

        installPhase = ''
          cp -r deps/client/dist $out
        '';

        doDist = false;
      };
      
      frontend-server = pkgs.mkYarnPackage {
        name = "idr-channelguard-frontend-server";
        src = ./server; # TODO consider a filter
        packageJSON = ./server/package.json;
        yarnLock = ./yarn.lock;

        configurePhase = ''
          ln -s $node_modules node_modules
        '';
      
        buildPhase = ''
          export HOME=$(mktemp -d)
          yarn --offline run tsc
          yarn --offline build-themes
        '';

        installPhase = ''
          mkdir $out
          cp -r dist $out/
          cp -r public $out/
        '';

        doDist = false;
      };

      # FIXME explictly use the same node version everywhere
      frontend = pkgs.runCommandNoCC "frontend" {
        meta.mainProgram = "start";
      } ''
        mkdir -p $out/server
        cp -r ${config.packages.frontend-server}/* $out/server/
        ln -s ${config.packages.frontend-server.node_modules} $out/server/node_modules

        mkdir -p $out/client/dist
        cp -r ${config.packages.frontend-client}/* $out/client/dist
        ln -s ${config.packages.frontend-client.node_modules} $out/client/node_modules

        mkdir $out/bin
        cat << EOF > $out/bin/start
        #!${pkgs.runtimeShell}
        export node_modules=${config.packages.frontend-client.node_modules}
        ${lib.getExe pkgs.nodejs_20} $out/server/dist/index.js
        EOF
        chmod +x $out/bin/start
      '';

      # TODO expose port(s?)
      frontend-docker = pkgs.dockerTools.buildImage {
        name = "frontend-docker";
        config = {
          Cmd = [ "${config.packages.frontend}/bin/start" ];
        };
      };
    };
  };
}
