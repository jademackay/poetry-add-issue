# Poetry Add Issue

From this dir
```
poetry install
poetry run yo
```

From another dir
```
poetry init -i --name example
poetry add git+https://github.com/jademackay/poetry-add-issue.git
#poetry install
#poetry run yo
```
Fails with error relating to metadata preparation, excerpt:
```
  EnvCommandError

  Command ['/home/jade/.cache/pypoetry/virtualenvs/example-iNd1DgyF-py3.10/bin/python', '-m', 'pip', 'install', '--use-pep517', '--disable-pip-version-check', '--isolated', '--no-input', '--prefix', '/home/jade/.cache/pypoetry/virtualenvs/example-iNd1DgyF-py3.10', '--upgrade', '--no-deps', '/home/jade/.cache/pypoetry/virtualenvs/example-iNd1DgyF-py3.10/src/poetry-add-issue'] errored with the following return code 1, and output:
  Processing /home/jade/.cache/pypoetry/virtualenvs/example-iNd1DgyF-py3.10/src/poetry-add-issue
    Installing build dependencies: started
    Installing build dependencies: finished with status 'done'
    Getting requirements to build wheel: started
    Getting requirements to build wheel: finished with status 'done'
    Preparing metadata (pyproject.toml): started
    Preparing metadata (pyproject.toml): finished with status 'error'
    error: subprocess-exited-with-error

    × Preparing metadata (pyproject.toml) did not run successfully.
    │ exit code: 1
```


## Work-around

```
mkdir /tmp
cd /tmp
git clone https://github.com/jademackay/poetry-add-issue.git
poetry-add-issue
poetry build
```

Back in our project edit `pyproject.toml` to include
```
[tool.poetry.dependencies]
python = "^3.10"
poetry-add-issue = {path = "/tmp/poetry-add-issue/dist/poetry_add_issue-0.1.0-py3-none-any.whl"}
```
then
```
poetry install
```
success!
```
poetry run yo
# yo! # as desired.
```

