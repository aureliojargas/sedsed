#! /bin/sed -f 

# fmt.sed -- format text such as each line gets below 40 chars
# $Id: fmt.sed,v 1.1 1998/05/28 04:21:33 cdua Exp $ 
# Carlos Duarte, 980528

:a
/^.\{40\}/!{
	$q
	N
	s/ *\n */ /
	ba
}
s/^.\{40\}/&\
/
s/^\(.*\) \(.*\)\n/\1\
\2/
P
s/^.*\n//
ba
