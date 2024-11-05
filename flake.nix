{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    poetry2nix = {
      url = "github:nix-community/poetry2nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    process-compose-flake.url = "github:Platonic-Systems/process-compose-flake";
    services-flake.url = "github:juspay/services-flake";
  };

  outputs = {flake-parts, ...}@inputs: flake-parts.lib.mkFlake {inherit inputs;} {
    systems = ["x86_64-linux" "x86_64-darwin" "aarch64-darwin"];
    imports = [
      ./nix/shell.nix # TODO consider having multiple shells, one for each service
      ./nix/process-compose.nix
      # ./services/backend
      # ./services/frontend
    ];
  };
}
