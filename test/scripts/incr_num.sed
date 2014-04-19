#!/usr/bin/sed -f

# algorithm by :
# Bruno <Haible@ma2s2.mathematik.uni-karlsruhe.de>

# incrementing one number, is just add 1 to first digit, i.e. replacing
# it by the following digit
#
# there is one exception, when carry does happen, on that case, all
# following digits must be added with one
#
# now this solution by `Bruno <Haible@ma2s2.mathematik.uni-karlsruhe.de>'
# is very clever and smart
#
# the only way to happen carry, is when the first digit is a 9
# all others cases are just fine
#
# for a number beginning with any digit except 9, just replace it (the digit)
# by the next digit, for each number beginning with a 9, just "remove" it and
# proceed as above for all others, i.e. all leadings 9s are "removes" until
# a non-9 is found, if any 9 did not remain, a 0 is insert

# replace all leading 9s by _ (any other char except digits, could be used)
#
:d
s/9\(_*\)$/_\1/
td

# if there aren't any digits left, add a MostSign Digit 0
#
s/^\(_*\)$/0\1/

# incr last digit only - there is no need for more
#
s/8\(_*\)$/9\1/
s/7\(_*\)$/8\1/
s/6\(_*\)$/7\1/
s/5\(_*\)$/6\1/
s/4\(_*\)$/5\1/
s/3\(_*\)$/4\1/
s/2\(_*\)$/3\1/
s/1\(_*\)$/2\1/
s/0\(_*\)$/1\1/

# replace all _ to 0s
#
s/_/0/g
