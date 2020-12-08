#!/bin/bash
# Include file used by all the sedsed tests.

# Turn strict mode on for all scripts
set -o errexit -o nounset -o pipefail

# shellcheck disable=SC2034
sed='gsed'

# shellcheck disable=SC2034
sedsed="python ../../sedsed.py --sedbin $sed"

failed=0
sed_output='sed-output.txt'
sedsed_output='sedsed-output.txt'

# shellcheck disable=SC2034
text=$(echo one two three four five six | tr ' ' '\n')

test_message() {
    echo "                $*"
}

tests_clean_up() {
    rm -f $sed_output $sedsed_output \
        w.out1 w.out2 \
        'filesw;' \
        filesw \
        filew
}

tests_git_status() {
    local problems
    # Use git to show the errors (differences)
    tests_clean_up
    problems=$(git status --short . | sed 's/^/ERROR (use git diff): /')
    if test -n "$problems"
    then
        failed=1
        echo "$problems"
    fi
}

tests_exit() {
    exit $failed
}
