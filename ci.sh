#!/bin/bash

# Turn strict mode on
set -o errexit -o nounset -o pipefail

echo "*** Running Pylint..."
pylint sedsed.py

echo "*** Running tests..."
./test/run
