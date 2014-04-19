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
s,&,&amp;,g
s,<,&lt;,g
s,>,&gt;,g
s,\\{,&obrace;,g
s,\\},&cbrace;,g

# uninteresting line, jump to end
/[{}]/!b unescape

:open

/{/{
  s,\( *\)\([^|<>}{ ]*\){,\1\
\2\
,;           # Isolate tag
  # Patternspace: text \n newtag \n text
  H;         # append to holdspace
  s,\n\([^\n]*\)\n,<\1>,; # generate XML tag

  # Holdspace: ..\tagN \n text \n newtag \n text
  # We only want oldtags + newtag
  x
  s,\(.*\n\)[^\n]*\n\([^\n]*\)\n[^\n]*$,\1\2,
  x

  /^[^{]*}/b close
  /{/b open
}

:close

/}/{
  s,},\
\
\
,
  # text1 \n\n\n text2 \n\n tag0 \n tag1 text2 may be empty
  G;
  s,\n\n\n\([^\n]*\)\n.*\n\([^\n]*\)$,</\2>\1,
  x
  s,\n[^\n]*$,,;   # delete tag from holdspace
  x

  /^[^}]*{/b open;   # if next bracket is an open one
  /}/b close;        # another one?
}

:unescape
s,&obrace;,{,g
s,&cbrace;,},g
