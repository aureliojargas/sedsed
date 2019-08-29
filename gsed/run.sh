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
#
#   5. Empty b and t commands (no label) used to have an extra white space
#      after them. No more.


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

cleanup() {
    rm blob{,2}.sed blob{,2}-{sedsed,gsed}.sed
}

echo "run errors tests..."
python3 test.py

echo "test sample..."
python3 gnused.py -v sample.gnused.sed > sample.gnused.out 2>&1
git diff sample.gnused.out

echo "test sedsed 'parsing' and 'script' test modules..."
cat ../test/{parsing,scripts}/*.sed > blob.sed
python3 ../sedsed.py -i -f blob.sed | fix_sedsed_b_t > blob-sedsed.sed
python3 gnused.py blob.sed > blob-gsed.sed
diff -u blob-{sedsed,gsed}.sed | view -

echo "Converting all sed.sf.net scripts..."
find ../../sed.sf.net/ -name '*.sed' |
    remove_broken_scripts |
    while read -r file
    do
        cat "$file"
        echo
    done > blob2.sed
python3 ../sedsed.py -i -f blob2.sed | fix_sedsed_b_t > blob2-sedsed.sed
python3 gnused.py blob2.sed > blob2-gsed.sed
diff -u blob2-{sedsed,gsed}.sed | view -

cleanup
