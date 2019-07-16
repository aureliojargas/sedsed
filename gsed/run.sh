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
