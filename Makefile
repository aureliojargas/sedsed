.PHONY: black check doctester pylint sedparse shellcheck test

# Main targets

check: black pylint shellcheck

test: doctester sedparse
	doctester test/command_line.md
	./test/run

# Secondary targets

black:
	black --check --diff --quiet ./*.py test/*.py

pylint: sedparse
	pylint ./*.py test/*.py

shellcheck:
	find . -name run | xargs shellcheck -x

# Dependencies

doctester:
	@command -v doctester || \
	pip install doctester

sedparse:
	@command -v sedparse || \
	pip install `grep -o 'sedparse[ =<>.0-9*]*' setup.py`
