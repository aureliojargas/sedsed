#n
#! /bin/sed -nf
#----------------- gather the lines in hold space
		t zzset001
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:H

		t zzclr001
		:zzset001
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:H

		:zzclr001
#--------------------------------------------------
H
		t zzset002
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:$ !b 

		t zzclr002
		:zzset002
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:$ !b 

		:zzclr002
#--------------------------------------------------
$ !b 
#----------------- sort them
# Append a new-line and the look-up table to hold space, get everything
# in pattern space
		t zzset003
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/.*/° !"#$%\\&'()*+,-.\\/0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~/

		t zzclr003
		:zzset003
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/.*/° !"#$%\\&'()*+,-.\\/0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~/

		:zzclr003
#--------------------------------------------------
s/.*/° !"#$%\&'()*+,-.\/0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~/
		t zzset004
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:H

		t zzclr004
		:zzset004
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:H

		:zzclr004
#--------------------------------------------------
H
		t zzset005
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:g

		t zzclr005
		:zzset005
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:g

		:zzclr005
#--------------------------------------------------
g
		t zzset006
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:t sort

		t zzclr006
		:zzset006
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:t sort

		:zzclr006
#--------------------------------------------------
t sort
		i\
COMM::sort
#--------------------------------------------------
:sort
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
		i\
COMM:s/\\(\\n\\([ -~]*\\)\\([ -~]\\)[ -~]*\\)\\(\\n.*\\)\\?\\(\\n\\2\\([ -~]\\)[ -~]*\\)\\(\\n.*°.*\\6.*\\3\\)/\\5\\1\\4\\7/
#--------------------------------------------------
s/\(\n\([ -~]*\)\([ -~]\)[ -~]*\)\(\n.*\)\?\(\n\2\([ -~]\)[ -~]*\)\(\n.*°.*\6.*\3\)/\5\1\4\7/
#   1----------------------------  4---      5------------------    7------------
#       2-----    3----                            6----
		t zzset007
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:t sort

		t zzclr007
		:zzset007
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:t sort

		:zzclr007
#--------------------------------------------------
t sort
# Remove the last new-line and the lookup table
# Leave the leading new-line
		i\
COMM:s/^\\(.*\\)\\n°.*$/\\1/
#--------------------------------------------------
s/^\(.*\)\n°.*$/\1/
# ----------------- delimit and number them
		t zzset008
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM::number

		t zzclr008
		:zzset008
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM::number

		:zzclr008
#--------------------------------------------------
:number
# Remove the first line, move the last number to the beginning of the
# new first line together with the lookup table
		i\
COMM:s/\\([0-9]*\\)[ -~]*\\n/\\1;9876543210990090 /
#--------------------------------------------------
s/\([0-9]*\)[ -~]*\n/\1;9876543210990090 /
# This regexp does the incrementing -- see tutorials for its explanation
		t zzset009
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/\\([0-8]\\{0,1\\}\\)\\(9*\\);[^1]*\\(.\\)\\1[0-9]*X*\\2\\(0*\\)[^ ]*/\\3\\4/

		t zzclr009
		:zzset009
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/\\([0-8]\\{0,1\\}\\)\\(9*\\);[^1]*\\(.\\)\\1[0-9]*X*\\2\\(0*\\)[^ ]*/\\3\\4/

		:zzclr009
#--------------------------------------------------
s/\([0-8]\{0,1\}\)\(9*\);[^1]*\(.\)\1[0-9]*X*\2\(0*\)[^ ]*/\3\4/
		t zzset010
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:P

		t zzclr010
		:zzset010
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:P

		:zzclr010
#--------------------------------------------------
P
# If the first char changes, we replace the first line with
# a single new-line character.  The pattern space will look the
# same as when we leave the sorting section, and the counter
# will be restarted.
# The leading new-line is printed by the second line, which
# can only match if the first did (if it didn't, the first 
# character will still be a digit).
		t zzset011
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:/^[0-9]* \\(.\\).*\\n\\1/ !s/[ -~]*//

		t zzclr011
		:zzset011
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:/^[0-9]* \\(.\\).*\\n\\1/ !s/[ -~]*//

		:zzclr011
#--------------------------------------------------
/^[0-9]* \(.\).*\n\1/ !s/[ -~]*//
		t zzset012
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:/^\\n/ P

		t zzclr012
		:zzset012
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:/^\\n/ P

		:zzclr012
#--------------------------------------------------
/^\n/ P
		t zzset013
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:/./ b number

		t zzclr013
		:zzset013
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:/./ b number

		:zzclr013
#--------------------------------------------------
/./ b number
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x

# Debugged SED script generated by sedsed (https://aurelio.net/projects/sedsed/)
