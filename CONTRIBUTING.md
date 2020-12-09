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

To install the tools in the development environment (venv):

    pip install -r requirements-dev.txt

Just run them over the Python files:

    make check


## Testing

Sedsed has a homemade custom testing solution, comprised of multiple shell scripts and test files. You can read more about it at [test/README.md](test/README.md).

There are also some extra tests for full command lines, using a Markdown file to describe the commands and their expected outputs, and [clitest](https://github.com/aureliojargas/clitest) runs and checks them.

To run all the tests, just do:

    make test


## Automation (CI)

For every new pushed commit, Travis CI runs the code checkers and all the tests, for multiple Python versions. See [.travis.yml](.travis.yml).


## Get released versions

Nice command to dump all the released versions into the current directory:

    for tag in $(git tag); do git show $tag:sedsed.py > sedsed-$tag.py; done

It will generate files such as:

- `sedsed-v0.1.py`
- `sedsed-v0.2.py`
- `sedsed-v0.3.py`
- `sedsed-v0.4.py`
- ...


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


## Packaging

To locally install (and uninstall) the package directly from this repository into the virtual env and test the `sedsed` executable:

    pip install -e .
    pip uninstall sedsed

To install the required software for the packaging:

    pip install -r requirements-pkg.txt

To build and upload the packages:

    python3 setup.py sdist bdist_wheel

To upload the package to TestPyPI index (good for testing) and install it locally:

    twine upload --repository-url https://test.pypi.org/legacy/ dist/*
    pip install -i https://test.pypi.org/simple/ sedsed

To upload the package to the official PyPI index:

    twine upload dist/*
