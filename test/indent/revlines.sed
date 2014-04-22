#n
#! /bin/sed -nf

# These three reverse the lines in a file by moving the line to
# the *beginning* of hold space.  Replace these three with a `p'
# (or remove them and remove the -n flag above) to reverse
# the chars on a single line
1 !G
h
$ p
