# Include file used by all the sedsed tests.

sed='gsed'

sedsed='python ../../sedsed.py'
# sedsed='python2.6 ../../sedsed.py'
# sedsed='python2.7 ../../sedsed.py'
# sedsed='python3   ../../sedsed.py'

sed_output='sed-output.txt'
sedsed_output='sedsed-output.txt'

text=$(printf "one\ntwo\nthree\nfour\nfive\nsix\n")

test_message() {
    echo "                $*"
}

tests_clean_up() {
    rm -f $sed_output $sedsed_output w.out1 w.out2
}

tests_git_status() {
    # Use git to show the errors (differences)
    tests_clean_up
    git status --short . | sed 's/^/ERROR (use git diff): /'
}
