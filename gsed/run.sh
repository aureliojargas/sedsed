#!/bin/bash

# run errors tests
python3 test.py

# test sample
python3 compile_c.py sample.sed > sample.sed.out 2>&1
git diff sample.sed.out

# test sedsed 'parsing' test module
cat ../test/{parsing,scripts}/*.sed > blob.sed
../sedsed.py -i -f blob.sed > blob-sedsed.sed
python3 compile_c.py blob.sed | sed "1,/ch='<EOF>'$/ d" > blob-gsed.sed
diff -u blob-{sedsed,gsed}.sed | less

# all sed.sf.net scripts
find ../../sed.sf.net/ -name '*.sed' |
    grep -v \
        -e sedermind.sed$ \
        -e untroff.sed$ \
        -e html_uc.sed$ \
        -e html_lc.sed$ \
        -e iso2html.sed$ \
        -e html2iso.sed$ \
        -e indexhtml.sed$ \
        -e sodelnum.sed$ |
    xargs -n 1 cat > blob2.sed
../sedsed.py -i -f blob2.sed > blob2-sedsed.sed
python3 compile_c.py blob2.sed | sed "1,/ch='<EOF>'$/ d" > blob2-gsed.sed
diff -u blob2-{sedsed,gsed}.sed | less
