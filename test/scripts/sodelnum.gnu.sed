#n
#! /bin/sed -nf

#----------------- gather the lines in hold space

H
$! b

#----------------- sort them

# Append a new-line and the look-up table to hold space, get everything
# in pattern space
s/.*/° !"#$%\&'()*+,-.\/0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~/
H
g

t sort
: sort
# This regexp performs an insertion sort pass!!!
# It searches for two lines with a common (possibly empty) prefix and
# compares the first differing char using a lookup table -- if the
# order is wrong, the regexp matches and the RHS of the s command
# swaps the lines
#
# \1 = line after the one to be inserted
# \2 = common part to the two lines     
# \3 = first differing char (in \1)     
# \4 = lines between the two lines      
# \5 = line to be inserted              
# \6 = first differing char (in \5)     
# \7 = lines after the second line + the lookup table

s/\(\n\([ -~]*\)\([ -~]\)[ -~]*\)\(\n.*\)\?\(\n\2\([ -~]\)[ -~]*\)\(\n.*°.*\6.*\3\)/\5\1\4\7/
#   1----------------------------  4---      5------------------    7------------
#       2-----    3----                            6----
t sort

# Remove the last new-line and the lookup table
# Leave the leading new-line
s/^\(.*\)\n°.*$/\1/

# ----------------- delimit and number them

: number

# Remove the first line, move the last number to the beginning of the
# new first line together with the lookup table
s/\([0-9]*\)[ -~]*\n/\1;9876543210990090 /
     
# This regexp does the incrementing -- see tutorials for its explanation
s/\([0-8]\{0,1\}\)\(9*\);[^1]*\(.\)\1[0-9]*X*\2\(0*\)[^ ]*/\3\4/
P

# If the first char changes, we replace the first line with
# a single new-line character.  The pattern space will look the
# same as when we leave the sorting section, and the counter
# will be restarted.
# The leading new-line is printed by the second line, which
# can only match if the first did (if it didn't, the first 
# character will still be a digit).
/^[0-9]* \(.\).*\n\1/ !s/[ -~]*//
/^\n/P

/./b number
