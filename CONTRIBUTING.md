# Contributing to sedsed

Please follow the usual GitHub workflow to contribute to this project:

- Use [GitHub issues](https://github.com/aureliojargas/sedsed/issues) for bug reports and feature requests.

- Use GitHub pull requests to submit code.


## Development environment

To create (and update in the future):

    python3 -m venv env
    source env/bin/activate
    pip install -r requirements-dev.txt

To use it while developing:

    source env/bin/activate

To leave it when done developing:

    deactivate

More info at https://packaging.python.org/guides/installing-using-pip-and-virtual-environments/


## Code check and formatting

The sedsed code is checked by pylint and formatted by [black](https://github.com/psf/black), so make sure you run both after every change.

Black is used with the default settings (no command line options) and the pylint configuration file is in the root of this repository.

Just run them over the Python files:

    pylint *.py test/*.py
    black  *.py test/*.py


## Testing

Sedsed has a homemade custom testing solution, comprised of multiple shell scripts and test files. You can read more about it at [test/README.md](test/README.md). To run all the tests, just do:

    ./test/run

There are also some extra tests for full command lines, using a Markdown file to describe the commands and their expected outputs, and [clitest](https://github.com/aureliojargas/clitest) runs and checks them.

    clitest test/command_line.md


## Automation (CI)

For every new pushed commit, Travis CI runs the code checkers and all the tests, for multiple Python versions. See [.travis.yml](.travis.yml).


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
