#!/bin/sed -f
#  @(#)14apr89/31aug01 expand.sed by Greg Ubben

/	/!b

# Change the text before a tab to
#   text<MARKER>text<TAB><8 blanks><TAB>
#
s/\([^	]*\)	/\1&        	/g

# Reduce the text between the marker and the tab to less
# than eight characters.  We have to put in 8-(length MOD 8)
# blanks, and this effectively does the modulo operation.
:a
        s/[^	]\{8\}/\a/g
ta

# The buffer is now:
#   text<MARKER><(length MOD 8) characters><TAB><expansion><extra blanks><TAB>
#               `-----------------------------------------'
# Notice that the expansion is 8-(length MOD 8), so the 
# underlined part is exactly nine characters.  That's how
# we discard the extra blanks and the tabs.
#                	
s/\(.\{9\}\) *	/\1/g
	
# We have now:
#         text<MARKER><(length MOD 8) characters><TAB><expansion>
#
# so we discard everything between the marker and the tab
#
s/[^	]*	//g
