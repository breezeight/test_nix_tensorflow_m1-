
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



## Test Loguro Only
Loguru is a simple logger library

```
❯ nix build .#devShells.aarch64-darwin.test   
warning: Git tree '/Users/nicolabrisotto/SRC/IDROSTUDI/test_nix_tensorflow_m1' is dirty
warning: ignoring untrusted substituter 'https://devenv.cachix.org', you are not a trusted user.
Run `man nix.conf` for more information on the `substituters` configuration option.
warning: ignoring the client-specified setting 'trusted-public-keys', because it is a restricted setting and you are not a trusted user
warning: ignoring untrusted substituter 'https://devenv.cachix.org', you are not a trusted user.
Run `man nix.conf` for more information on the `substituters` configuration option.
warning: ignoring the client-specified setting 'trusted-public-keys', because it is a restricted setting and you are not a trusted user
[1/61/73 built, 195 copied (949.0/949.7 MiB), 213.7 MiB DL] building python3.9-cffi-1.17.0 (pytestCheckPhase): testing/cffi1/test_unicode_literals.py .......                           [ 90%]

test_nix_tensorflow_m1 on  test_loguru [+] took 12m49s
```
