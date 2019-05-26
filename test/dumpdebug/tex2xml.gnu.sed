#!/bin/sed -f
# Try of a nested tag{value} parser:
# - handles multiline tags
# - can deal with quoted \{ and \}
# - handles nested tags
# Limitations:
# - tags are not allowed to have [{}<>| ] in the name.
# - doesn't detect unbalanced brackets
#
# b{foo} -> <b>foo</b>
# b{foo em{bar}} -> <b>foo <em>bar</em></b>
# Tue Nov 27 17:28:32 UTC 2001
# \{1{2{3{4{5{6{7{8{9{a{b{c{d{e{f{g{h{i{\{text0\}}}}}}}}}}}}}}}}}}}text1\}
# How it works
# We build a stack of unclosed tags in holdspace
# by appending always at the end (``H'').
# when a closing bracket is found, fetch tag
# from holdspace.
# Main focus is small memory usage
# escape Quoted and generate entities
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s,&,&amp;,g
#--------------------------------------------------
s,&,&amp;,g
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s,<,&lt;,g
#--------------------------------------------------
s,<,&lt;,g
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s,>,&gt;,g
#--------------------------------------------------
s,>,&gt;,g
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s,\\\\{,&obrace;,g
#--------------------------------------------------
s,\\{,&obrace;,g
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s,\\\\},&cbrace;,g
#--------------------------------------------------
s,\\},&cbrace;,g
# uninteresting line, jump to end
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:/[{}]/ !b unescape
#--------------------------------------------------
/[{}]/ !b unescape
		i\
COMM::open
#--------------------------------------------------
:open
		i\
COMM:/{/ {
#--------------------------------------------------
/{/ {
		i\
COMM:s,\\( *\\)\\([^|<>}{ ]*\\){,\\1\\\\N\\2\\\\N,
#--------------------------------------------------
s,\( *\)\([^|<>}{ ]*\){,\1\
\2\
,
# Isolate tag
# Patternspace: text \n newtag \n text
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
#--------------------------------------------------
H
# append to holdspace
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s,\\n\\([^\\n]*\\)\\n,<\\1>,
#--------------------------------------------------
s,\n\([^\n]*\)\n,<\1>,
# generate XML tag
# Holdspace: ..\tagN \n text \n newtag \n text
# We only want oldtags + newtag
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:x
#--------------------------------------------------
x
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s,\\(.*\\n\\)[^\\n]*\\n\\([^\\n]*\\)\\n[^\\n]*$,\\1\\2,
#--------------------------------------------------
s,\(.*\n\)[^\n]*\n\([^\n]*\)\n[^\n]*$,\1\2,
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:x
#--------------------------------------------------
x
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:/^[^{]*}/ b close
#--------------------------------------------------
/^[^{]*}/ b close
		i\
COMM:/{/ b open
#--------------------------------------------------
/{/ b open
		i\
COMM:}
#--------------------------------------------------
}
		i\
COMM::close
#--------------------------------------------------
:close
		i\
COMM:/}/ {
#--------------------------------------------------
/}/ {
		i\
COMM:s,},\\\\N\\\\N\\\\N,
#--------------------------------------------------
s,},\
\
\
,
# text1 \n\n\n text2 \n\n tag0 \n tag1 text2 may be empty
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:G
#--------------------------------------------------
G
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s,\\n\\n\\n\\([^\\n]*\\)\\n.*\\n\\([^\\n]*\\)$,</\\2>\\1,
#--------------------------------------------------
s,\n\n\n\([^\n]*\)\n.*\n\([^\n]*\)$,</\2>\1,
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:x
#--------------------------------------------------
x
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s,\\n[^\\n]*$,,
#--------------------------------------------------
s,\n[^\n]*$,,
# delete tag from holdspace
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:x
#--------------------------------------------------
x
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:/^[^}]*{/ b open
#--------------------------------------------------
/^[^}]*{/ b open
# if next bracket is an open one
		i\
COMM:/}/ b close
#--------------------------------------------------
/}/ b close
# another one?
		i\
COMM:}
#--------------------------------------------------
}
		i\
COMM::unescape
#--------------------------------------------------
:unescape
		i\
COMM:s,&obrace;,{,g
#--------------------------------------------------
s,&obrace;,{,g
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s,&cbrace;,},g
#--------------------------------------------------
s,&cbrace;,},g
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x

# Debugged SED script generated by sedsed (https://aurelio.net/projects/sedsed/)
