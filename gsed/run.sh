#!/bin/bash
# Compare output from old sedsed parser to the ported GNU sed parser
#
# Differences:
#
#   1. Partial line comments in the output are not supported
#      Old: p       ;# comment
#      New: p
#           # comment
#
#   2. Using \n as the s delimiter is not supported by GNU sed.
#      If seems it was never really supported by GNU sed.
#      This is used in one old script: indexhtml.sed
#
#   3. Old parser had a bug which inserted an extra space in the start
#      of a/i/c commands.
#      Old: i\
#            foo
#      New: i\
#           foo
#
#   4. Command r now considers any char (except \n) as part of the filename.
#      Old parser stopped at blanks.
#      Old: r foo
#      New: r foo bar baz


# remove space after b and t without labels
fix_sedsed_b_t() {
    sed 's/\(\(^ *\|!\|\/ \)[bt]\) $/\1/'
}

remove_debug() {
    sed "1,/ch='<EOF>'$/ d"
}

# not UTF-8, s using \n as delimiter
remove_broken_scripts() {
    grep -v \
        -e sedermind.sed$ \
        -e untroff.sed$ \
        -e html_uc.sed$ \
        -e html_lc.sed$ \
        -e impossible.sed$ \
        -e iso2html.sed$ \
        -e html2iso.sed$ \
        -e indexhtml.sed$ \
        -e sodelnum.sed$
}

# run errors tests
python3 test.py

# test sample
python3 compile_c.py sample.sed > sample.sed.out 2>&1
git diff sample.sed.out

# test sedsed 'parsing' test module
cat ../test/{parsing,scripts}/*.sed > blob.sed
../sedsed.py -i -f blob.sed | fix_sedsed_b_t > blob-sedsed.sed
python3 compile_c.py blob.sed | remove_debug > blob-gsed.sed
diff -u blob-{sedsed,gsed}.sed | less

# all sed.sf.net scripts
find ../../sed.sf.net/ -name '*.sed' |
    remove_broken_scripts |
    while read file
    do
        cat "$file"
        echo
    done > blob2.sed
../sedsed.py -i -f blob2.sed | fix_sedsed_b_t > blob2-sedsed.sed
python3 compile_c.py blob2.sed | remove_debug > blob2-gsed.sed
diff -u blob2-{sedsed,gsed}.sed | less
