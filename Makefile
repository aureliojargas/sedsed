.PHONY: black clean lint pylint sedparse shellcheck test

# Main targets

lint: black pylint shellcheck

test: clitest sedparse
	bash ./clitest test/command_line.md
	./test/run

clean:
	rm -f clitest

# Secondary targets

black:
	black --check --diff --quiet ./*.py test/*.py

pylint: sedparse
	pylint ./*.py test/*.py

shellcheck:
	find . -name run | xargs shellcheck -x

# Dependencies

clitest:
	curl --location --remote-name --silent \
	https://raw.githubusercontent.com/aureliojargas/clitest/master/clitest

sedparse:
	@command -v sedparse || \
	pip install `grep -o 'sedparse[ =<>.0-9*]*' setup.py`
