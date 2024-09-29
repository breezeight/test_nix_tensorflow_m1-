
# Experiments with poetry2nix

## Tensorflow

### Test build without Nix on OSX - m2 

OK su M2 con : 
```bash
cd services/backend/code
poetry install
poetry run python smoketest_tensorflow.py

poetry run python --version              
#Stampa: Python 3.10.4

```

### Test nix devShell

TEST
- OK: nix develop .#devShells.aarch64-darwin.default 
- KO: nix develop .#devShells.aarch64-darwin.test

### Test nix Build
Test:
- nix build .#devShells.aarch64-darwin.default
- KO: nix build .#devShells.aarch64-darwin.test



## Test Loguro Only

### Test Build

Loguru is a simple logger library

`nix build .#devShells.aarch64-darwin.test`

```bash
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

> ⚠️ **Warning:** it took almost 13 minutes for a simple library that with poetry tooks few seconds to install


### Test DevShell


Build OK:

```bash
❯ nix develop .#devShells.aarch64-darwin.test
path '/Users/nicolabrisotto/SRC/IDROSTUDI/test_nix_tensorflow_m1/services/backend/code' does not contain a 'flake.nix', searching up
warning: Git tree '/Users/nicolabrisotto/SRC/IDROSTUDI/test_nix_tensorflow_m1' is dirty
warning: ignoring untrusted substituter 'https://devenv.cachix.org', you are not a trusted user.
Run `man nix.conf` for more information on the `substituters` configuration option.
warning: ignoring the client-specified setting 'trusted-public-keys', because it is a restricted setting and you are not a trusted user
warning: ignoring untrusted substituter 'https://devenv.cachix.org', you are not a trusted user.
Run `man nix.conf` for more information on the `substituters` configuration option.
warning: ignoring the client-specified setting 'trusted-public-keys', because it is a restricted setting and you are not a trusted user
warning: ignoring untrusted substituter 'https://devenv.cachix.org', you are not a trusted user.
Run `man nix.conf` for more information on the `substituters` configuration option.
warning: ignoring the client-specified setting 'trusted-public-keys', because it is a restricted setting and you are not a trusted user
Restored session: Sun Sep 29 17:14:08 CEST 2024
(nix:nix-shell-env) nicola-macbook-m1:code nicolabrisotto$ python --version
Python 3.9.20
(nix:nix-shell-env) nicola-macbook-m1:code nicolabrisotto$ which python
/nix/store/nfqgpr963fc5pq2iwkm7qg5avgb3k51m-python3-3.9.20-env/bin/python
(nix:nix-shell-env) nicola-macbook-m1:code nicolabrisotto$ poetry run python smoketest_loguru.py
2024-09-29 17:34:15.928 | DEBUG    | __main__:<module>:3 - That's it, beautiful and simple logging!
(nix:nix-shell-env) nicola-macbook-m1:code nicolabrisotto$ python smoketest_loguru.py
2024-09-29 17:34:22.968 | DEBUG    | __main__:<module>:3 - That's it, beautiful and simple logging!
(nix:nix-shell-env) nicola-macbook-m1:code nicolabrisotto$ poetry run python --version
Python 3.10.4
```

> ⚠️ **Warning:** the python interpreter is 3.9.20 ... why?! And it is 3.10.4 from `poetry run` .... 


The issues is: `poetry shell` and `poetry run` try to find a suitable python interpreter (probably they make some trick to find the installed one): 

```bash
(nix:nix-shell-env) nicola-macbook-m1:code nicolabrisotto$ poetry shell
Spawning shell within /Users/nicolabrisotto/Library/Caches/pypoetry/virtualenvs/code-U7bNCHKE-py3.10
nicola-macbook-m1:code nicolabrisotto$ . /Users/nicolabrisotto/Library/Caches/pypoetry/virtualenvs/code-U7bNCHKE-py3.10/bin/activate
(code-py3.10) nicola-macbook-m1:code nicolabrisotto$ which python
/Users/nicolabrisotto/Library/Caches/pypoetry/virtualenvs/code-U7bNCHKE-py3.10/bin/python
(code-py3.10) nicola-macbook-m1:code nicolabrisotto$ which /Users/nicolabrisotto/Library/Caches/pypoetry/virtualenvs/code-U7bNCHKE-py3.10/bin/python
/Users/nicolabrisotto/Library/Caches/pypoetry/virtualenvs/code-U7bNCHKE-py3.10/bin/python
(code-py3.10) nicola-macbook-m1:code nicolabrisotto$ ls -la /Users/nicolabrisotto/Library/Caches/pypoetry/virtualenvs/code-U7bNCHKE-py3.10/bin/python
lrwxr-xr-x 1 nicolabrisotto staff 65 Sep 29 15:03 /Users/nicolabrisotto/Library/Caches/pypoetry/virtualenvs/code-U7bNCHKE-py3.10/bin/python -> /Users/nicolabrisotto/.asdf/installs/python/3.10.4/bin/python3.10
```



