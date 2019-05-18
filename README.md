# sedsed

Debugger, indenter and HTMLizer for sed scripts, by Aurelio Jargas.

Website:
http://aurelio.net/projects/sedsed/

## Code linter

Sedsed code is checked by pylint. Some checks were disabled because sedsed is still not compliant on them. See [.pylintrc](.pylintrc).

## Tests

Sedsed has a homemade custom testing solution, comprised of multiple shell scripts and test files. You can read more about it at [test/README.md](test/README.md). To run all the tests, just do:

    $ ./test/run

## CI

For every new commit, Travis CI runs the code linter and all the tests. See [.travis.yml](.travis.yml).
