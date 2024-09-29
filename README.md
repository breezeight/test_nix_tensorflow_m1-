
## Without Nix on OSX - m2 

cd services/backend/code
poetry install


## Shell

TEST
- OK: nix develop .#devShells.aarch64-darwin.default 
- KO: nix develop .#devShells.aarch64-darwin.test

## Build
Test:
- nix build .#devShells.aarch64-darwin.default
- KO: nix build .#devShells.aarch64-darwin.test