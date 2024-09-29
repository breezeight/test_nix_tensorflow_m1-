
## Without Nix on OSX - m2 

OK su M2 con : 
```bash
cd services/backend/code
poetry install
poetry run python smoketest_tensorflow.py

poetry run python --version              
#Stampa: Python 3.10.4

```

## Shell

TEST
- OK: nix develop .#devShells.aarch64-darwin.default 
- KO: nix develop .#devShells.aarch64-darwin.test

## Build
Test:
- nix build .#devShells.aarch64-darwin.default
- KO: nix build .#devShells.aarch64-darwin.test