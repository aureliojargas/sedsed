# Include file used by all the sedsed tests.

# Turn strict mode on for all scripts
set -o errexit -o nounset -o pipefail

sed='gsed'

sedsed='python ../../sedsed.py'
# sedsed='python2.6 ../../sedsed.py'
# sedsed='python2.7 ../../sedsed.py'
# sedsed='python3   ../../sedsed.py'

failed=0
sed_output='sed-output.txt'
sedsed_output='sedsed-output.txt'

text=$(printf "one\ntwo\nthree\nfour\nfive\nsix\n")

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
