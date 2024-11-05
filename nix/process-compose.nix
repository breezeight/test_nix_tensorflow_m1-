{inputs, ...}: {
  imports = [
    inputs.process-compose-flake.flakeModule
  ];
  perSystem = {...}: {
    process-compose."dev" = {config, ...}: {
      imports = [
	inputs.services-flake.processComposeModules.default
      ];
      services.postgres."pg1" = {
	enable = true;
	initialDatabases = [
          {
            name = "test";
            schemas = [ ./schema.sql ];
          }
	];
      };
    };
  };
}
