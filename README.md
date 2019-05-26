# sedsed

Debugger, indenter and HTMLizer for sed scripts, by Aurelio Jargas.

Website:
https://aurelio.net/projects/sedsed/

## Code linter

Sedsed code is checked by pylint. Some checks were disabled because sedsed is still not compliant on them. See [.pylintrc](.pylintrc).

## Tests

Sedsed has a homemade custom testing solution, comprised of multiple shell scripts and test files. You can read more about it at [test/README.md](test/README.md). To run all the tests, just do:

    $ ./test/run

## CI

For every new commit, Travis CI runs the code linter and all the tests. The tests are checked in multiple Python versions, from 2.6 to 3.6. See [.travis.yml](.travis.yml).

## New version release checklist

Preparing:

- Make sure the tests are 100% ok.
- Check the list of commits since the last version.
- Check the full diff against the last version.
- Update and commit the Changelog.

Releasing:

- Commit the increased version number in `__version__`.
- Tag this commit with the new version.
- Commit the change to the version number back to the dev state.
- Push everything (commits and tags) to GitHub.
- Update the website, download section.
