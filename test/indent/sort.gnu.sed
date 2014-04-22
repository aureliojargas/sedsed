#! /bin/sed -f

# sort.sed -- implementing selection sort with sed
# 
# $Id: sort.sed,v 1.3 1998/07/07 12:31:49 cdua Exp cdua $
# Carlos Duarte, 970529

# How does this work?
# 
# o first all lines are joined in this format
# 
# \na line_a \nA
# \nb line_b \nB
# \nl next_line \nL
# \nl next_line \nL
# ...
# 
# o general markers are of the form \n<letter> (and a \n can not appear alone)
# 
# o the following algorithm is used: 
# 
#       start at 2
#       1. a = a+1
#       2. a at end? yes: exit, no: continue
#       3. make b = a+1
#       4. sort a vs b 
#       5. b at end? yes: goto 1; no: continue
#       6. b = b+1; goto 4
# 
# o the sorting by itself is done this way: 
#       
#       . after isolating the line a and b, add a table, with order we want
#       . then match the initial common part of both lines, for instance
#               line_a: xxxx1
#               line_b: xxx22
#         it would store xxx x1 22, i.e. common rest_of_a rest_of_b 
#       . if the RE \(first_char_of_a\) \(first_char_of_b\) \1.*\2 exist
#         then the line is sorted already, do nothing
#       . else swap them
# 
#       (for instance, "a" is \1 "g" is \2, then \1.*\2 exist, because table
#       is abcdefg..., but if \1 was "k", then \1.*\2 do not exit on table)
# 
# 

# setup 
H
$ !d
g
s/.//
s/\n/&L&l/g
s/^/\
a/
s/\nL/\
A/
s/$/\
L/

# have now: \na ln1 \nA \nl ln2 \nL \nl ln3 \nL ... 

b start

# advance \na .. \nA to next line
:inca
s/\(\na\)\(.*\)\(\nA\)\(\n[lb]\)\([^\n]*\)\(\n[LB]\)/\4\2\6\1\5\3/

# ln_a is at the end, then sort is over
:start
/\nA$/ b exit

# b = a+1
s/\nb/\
l/
s/\nB/\
L/
s/\(\na.*\nA\)\nl\([^\n]*\)\nL/\1\
b\2\
B/

:sort
h
s/.*\na\(.*\)\nA.*\nb\(.*\)\nB.*/\1\
\2\
         !"#$%\&()*+,-.\/0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~/

# work on a temp space: common \n rest_a \n rest_b \n table 
s/^\(.*\)\(.*\n\)\1\(.*\n.*\)/\1\
\2\3/

# a is empty and b not: keep this order
/.*\n\n..*\n/ b keep

# a is not empty and b is: swap order
/.*\n..*\n\n/ b swap

# if RE fail, swap, else keep order.. 
/.*\n\(.\).*\n\(.\).*\n.*\1.*\2/ b keep

:swap
s/\(\n.*\)\(\n.*\)\n/\2\1\
/

:keep
s/\(.*\)\n\(.*\)\n\(.*\)\n.*/\1\2\
c\1\3\
d/

# merge with main buffer
G
s/^\(.*\)\nc\(.*\na\)\(.*\)\(\nA\)/\2\1\4/
s/^\(.*\)\nd\n\(.*\nb\)\(.*\)\(\nB\)/\2\1\4/

# b at end? 
/\nB$/ b inca

# nope, then make b = b+1
s/\(\nb\)\(.*\)\(\nB\)\(\nl\)\([^\n]*\)\(\nL\)/\4\2\6\1\5\3/
b sort

# here: ^ \nl..\nL...\na..\nA $
:exit
s/\n[ablA]//g
s/\n[BL]/\
/g

