# sedcheck.sed - detects various POSIX compatibility issues in sed scripts
# 
# (C) 2003 Laurent Vogel - GPL version 2 or later at your option.
# 
# 2003-09-12 version 0.1 

# hide _,<,>,~ behind '
s/['_<>~]/&'a_b<c>d~e,/g
s/\(['_<>~]\)[^,]*\1\([^,]\)[^,]*,/'\2/g

# consider the hold buffer; initialize line number and issue number
x
1s/.*/C~0,0+012345678910999000990090/
# increment line number
s/\(.\)\(9*\)\(,[^+]*+[^9]*\1\(.0*\).*\2\(0*\)\)/\4\5\3/
x

# get back state from previous line
G
s/\(.*\)\n\([^~]*~\).*/_\2\1/

:loop

# outside commands: _~ = at top level, _{{~ inside two nested groups
s/\(_{*~\)\([ 	][ 	]*\)/<trailing 'blank's should be avoided>\2\1/
s/_\({{*~\);/<";" not allowed in {...} groups>;_C\1/
s/_~;/;_C~/
s/_\({*~\)}/_c\1}/
s/\(_{*~\)\(#.*\)/<"#" should be preceded by ";" or 'newline'>\2\1/
s/_\({*~\)$/_C\1/
s/\(_{*~\)\(.*\)/<trailing garbage after command (rest of the line \
ignored)>\2\1/

# 'C'ommand: skip blanks, try first address
s/\(_C[^~]*~\)\([ 	][ 	]*\)/\2\1/
s/_C\([^~]*~[0-9$/\]\)/_ad\1/

# 'a'ddress
s/\(_a[^~]*~\)\(00*\)\([0-9]\)/<useless leading 0>\2\1\3/
s/_a\([^~]*~\)0/<line 0 is a GNU extension>0_\1/
s/_a\([^~]*~\)\\$/\\<'newline' is not a valid delimiter>_\\b'z\1/
s/_a\([^~]*~\)\\\(\\[^\]*\\\)/\\<"\\" is not a valid delimiter>\2_\1/
s/_a[^{~]*\({*~\)\\\(\\.*\)/\\<"\\" is not a valid delimiter>\2<missing \
delimiter>_\1/
s/_a\([^~]*~\)\\\('*[^']\)/\\\2_b\2\1/
s/_a\([^~]*~\)\//\/_b\/\1/
s/_a\([^~]*~\)\$/$_\1/
s/_a\([^~]*~\)\([1-9][0-9]*\)/\2_\1/
s/_a.\([^~]*~\)\(.*\)/<bad address (rest of line ignored)>\2_\1/

# 'd' is 1addr command, 'e' is 2addr command: try second address
s/\(_d[^~]*~\)\([ 	][ 	]*\),/<no 'blank's allowed>\2\1,/
s/_d\([^~]*~\),\([ 	][ 	]*\)/,<no 'blank's allowed>\2_ae\1/
s/_d\([^~]*~\),/,_ae\1/

# a function can be preceded by blanks and '!'s 
s/\(_[cde][^~]*~\)\([ 	][ 	]*\)/\2\1/
s/\(_[Cde][^~]*~\)!\(!*\)!/!<multiple "!" not recommended>\2\1!/
s/\(_[Cde][^~]*~\)!\([ 	][ 	]*\)/!<no 'blank's allowed after "!">\2\1/
s/\(_[Cde][^~]*~\)!/!\1/
s/_C\([^~]*~.\)/_c\1/

# 0addr and 1 addr messages 
s/_[de]\([^~]*~\)$/<missing command>_\1/
s/_[de]\([^~]*~[:#}]\)/<no addresses allowed>_c\1/
s/_e\([^~]*~[aiqr=]\)/<at most one address allowed>_c\1/

# no need to remember the number of addresses any longer
s/_[de]/_c/

# comment, empty command
s/_c\([^~]*~\)\(#.*\)/\2_\1/
s/_c\([^~]*~\);/_\1;/

# {, }
s/_c\([^~]*~\){/{_C{\1/
s/_c\([^~]*~\){/{_C{\1/
s/^\([ 	]*[^ 	_][^_]*\)_c{\([^~]*~\)}/\1<"}" should be preceded by a \
'newline'>}_}\2/
s/_c{\([^~]*~\)}/}_}\1/
s/_}\([^~]*~\)\([ 	]*\);/\2<";" not allowed after { ... } groups>;_C\1/
s/_}\([^~]*~\)\([ 	]*\)/\2_\1/
s/_c~}/<mismatched { ... }>}_~/

# a\, i\, c\
s/_c\([^~]*~\)\([aic]\\\)\([ 	][ 	]*\)$/\2<trailing 'blank's>\3_\\t\1/
s/_c\([^~]*~\)\([aic]\\\)$/\2_\\t\1/
s/_c\([^~]*~\)\([aic]\\\)/\2<'newline' expected>_t\1/
s/_c\([^~]*~\)\([aic]\)/\2<"\\'newline'" expected>_t\1/

s/\(_t[^~]*~\)\([^\][^\]*\)/\2\1/
s/_\(t[^~]*~\)\\$/\\_\\\1/
s/\(_t[^~]*~\)\\\\/\\\\\1/
s/\(_t[^~]*~\)\(\\'*[^\']\)/<useless "\\">\2\1/
s/_t\([^~]*~\)$/_\1/

# b, t, : - POSIX is quite unclear: are leading spaces and tabs allowed?
# I assume here that zero or one leading space is OK, and anything else
# doubtful.
s/_c\([^~]*~\):\([ 	]*[;#}]\)/:<missing label>_\1\2/
s/_c\([^~]*~\):\([ 	]*\)$/:<missing label>_\1\2/
s/_c\([^~]*~\):\([ 	][ 	]*\)/:<'blank's not recommended here>\2_l\1/
s/_c\([^~]*~\):/:_l\1/

s/_c\([^~]*~\)\([bt]\)\([ 	]*\)$/\2_\1\3/
s/_c\([^~]*~\)\([bt]\) /\2 _l\1/
s/_c\([^~]*~\)\([bt]\)\([ 	]*\)/\2<single 'space' recommended here>\3_l\1/

s/_l\([^~]*~\)\([^;#} 	]*\)\([;}#]\)/\2<avoid "\3" in labels>_\1\3/
s/_l\([^~]*~\)\([^;#} 	]*\)\([ 	]\)/\2<avoid 'blank's in labels>\3_C\1/
s/_l\([^~]*~\)\('*[^']'*[^']'*[^']'*[^']'*[^']'*[^']'*[^']'*[^']\)\(..*\)/\2<\
label more than 8 characters long>\3_\1/
s/_l\([^~]*~\)\(.*\)\([ 	][ 	]*\)$/\2<trailing 'blank's not \
recommended>\3_\1/
s/_l\([^~]*~\)\(.*\)/\2_\1/

# d, D, g, G, h, H, l, n, N, p, P, q, x, =
s/_c\([^~]*~\)\([dDgGhHlnNpPqx=]\)/\2_\1/

# r, w
s/_c\([^~]*~\)\([rw]\)/\2_n\1/
s/_n\([^~]*~\)\([ 	][ 	]*\)/\2_m\1/
s/_n\([^~]*~\)\(..*\)/<'blank's expected>\2_\1/
s/_m\([^~]*~\)$/<missing filename>_\1/
s/_m\([^~]*~\)\([^;#]*\)\([;#].*\)/\2<part of the filename>\3_\1/
s/_m\([^~]*~\)\(..*\)/\2_\1/

# s, y
s/_c\([^~]*~\)s$/s<'newline' is not a valid delimiter>_\\b'zs'zS0\1/
s/_c\([^~]*~\)y$/y<'newline' is not a valid delimiter>_\\y'zy'y\1/
s/_c\([^~]*~\)s\(\\[^\]*\\[^\]*\\\)/s<"\\" is not a valid delimiter>\2_S0\1/
s/_c\([^~]*~\)y\(\\[^\]*\\[^\]*\\\)/y<"\\" is not a valid delimiter>\2_\1/
s/_c\([^~]*~\)\([sy]\)\(\\.*\)/\2<"\\" is not a valid delimiter>\3<missing \
delimiter>_\1/
s/_c\([^~]*~\)s\('*[^']\)/s\2_b\2s\2S0\1/
s/_c\([^~]*~\)y\('*[^']\)/y\2_y\2y\2\1/

# s right hand side and both sides of y
:sy
s/\(_[sy]\/[^~]*~\)\([^\/][^\/]*\)/\2\1/
s/_[sy]\('*[^']\)\([^~]*~\)\1/\1_\2/
s/_\([sy][^~]*~\)\([^\]\)/\2_?\1/
s/_\(s\([1-9&]\)[^~]*~\)\\\2/<"\\\2" ambiguous with "\2" as delimiter\
>\\\2_?\1/
s/_\([sy]\('*[^']\)[^~]*~\)\\\2/\\\2_?\1/
s/_\(s[^~]*~\)\(\\[^1-9&n\]\)/<"\2" unspecified>\2_?\1/
s/_\(s[^~]*~\)\(\\n\)/<"\\n" unspecified (use 'newline' instead)>\2_?\1/
s/_\(y[^~]*~\)\(\\[^n\]\)/<"\2" unspecified>\2_?\1/
s/_\([sy][^~]*~\)\(\\'*.\)/\2_?\1/
s/_\(s[^~]*~\)\\$/\\_\\\1/
s/_\(y[^~]*~\)\\$/<"\\'newline'" invalid (use "\\n" instead)>\\_\\\1/
s/_y'y\([^~]*~\)$/_\1/
s/_[sy]'z\([^~]*~\)$/_\\\1/
s/_y'*[^']y'*[^']\([^~]*~\)$/<missing delimiter>_\1/
s/_[sy]'*[^']\([^~]*~\)$/<missing delimiter>_\1/
/_[sy]/t sy

# s flags
s/\(_S[^~]*~\)p/p\1/
s/_S[01]\([^~]*~\)g/g_S1\1/
s/_S0\([^~]*~\)\([0-9][0-9]*\)/\2_S2\1/
s/\(_S1[^~]*~\)\([0-9][0-9]*\)/<both "g" and "n" flags>\2\1/
s/\(_S2[^~]*~\)\([0-9][0-9]*\)/<multiple "n" flags>\2\1/
s/\(_S2[^~]*~\)g/<both "g" and "n" flags>g\1/
s/_S.\([^~]*~[ 	;#]\)/_\1/
s/_S.\([^~]*~\)$/_\1/
s/_S.\([^~]*~\)\([^pg0-9w]\)$/<unknown flag>\2_\1/
s/_S.\([^~]*~\)\([^pg0-9w].*\)/<unknown flag (rest of line ignored)>\2_\1/
s/_S.\([^~]*~\)w/w_n\1/

# #
s/_c\([^~]*~\)\(#.*\)/\2_\1/

s/_c\([^~]*~\)\([^#; 	].*\)/<unknown command (rest of line ignored)>\2_\1/

# 'b'eginning of regexp
# "*" is special unless at the beginning of the regex (after optional "^")
s/_b\([^^][^~]*~\)^/^_b\1/
s/_b\([^*][^~]*~\)\*/*_r\1/
s/_b/_r/

# 'r'egexp loop. state 'R' after a repeated symbol and 'B' inside a bracket
# expression. 
/_[rB]/{
  
  :reloop
  # shortcut, when the delimiter is "/"
  s/_[rR]\(\/[^~]*~\)\([^\/*$[][^\/*$[]*\)/\2_r\1/
  s/_[rR]\('*[^']\)\([^~]*~\)\1/\1_\2/
  
  # \x
  s/_[rR]\(\([n.(){1-9^$*[]\)[^~]*~\)\\\2/<"\\\2" ambiguous with "\2" as \
delimiter>_?r\1/
  s/_[rR]\(\('*[^']\)[^~]*~\)\\\2/\\\2_?r\1/
  s/_[rR]\([^~]*~\)\(\\[^n.\*^$(){1-9?+[]\)/<"\2" undefined>\2_?r\1/
  s/_[rR]\([^~]*~\)\\?/<"\\?" undefined (use "\\{0,1\\}" instead)>\\?_?r\1/
  s/_[rR]\([^~]*~\)\\+/<"\\+" undefined (use "\\{1,\\}" instead)>\\+_?r\1/
  s/_[rR]\([^~]*~\)\(\\[n.\*^$1-9)[]\)/\2_?r\1/
  s/_[rR]\([^~]*~\)\\(\^/\\(<subexpression anchoring is optional (use \
"\\^" instead)>^_?r\1/
  s/_[rR]\([^~]*~\)\\(\*/\\(*_?r\1/
  s/_[rR]\([^~]*~\)\\(/\\(_?r\1/
  
  # \{...\}
  s/_[rR]\([^~]*~\)\(\\{\)\([^0-9]\)/\2<bad interval>\3_?r\1/
  s/_[rR]\([^~]*~\)\(\\{[0-9][0-9]*\)\([^\,0-9]\)/\2<bad interval>\3_?r\1/
  s/_[rR]\([^~]*~\)\(\\{[0-9][0-9]*\)\(\\[^}]\)/\2<bad interval>\3_?r\1/
  s/_[rR]\([^~]*~\)\(\\{[0-9][0-9]*,\)\([^\0-9]\)/\2<bad interval>\3_?r\1/
  s/_[rR]\([^~]*~\)\(\\{[0-9][0-9]*,[0-9][0-9]*\)\([^\0-9]\)/\2<bad \
interval>\3_?r\1/
  s/_[rR]\([^~]*~\)\(\\{[0-9][0-9]*,[0-9][0-9]*\)\(\\[^}]\)/\2<bad \
interval>\3_?r\1/
  s/_R\([^~]*~\)\(\\{[^}]*}\)/<multiple "*" or intervals>\2_?r\1/
  s/_r\([^~]*~\)\(\\{[^}]*}\)/\2_?R\1/
  
  # entering a bracket expression
  s/_[rR]\([^~]*~\)\(\[^^]\)/\2_B\1/
  s/_[rR]\([^~]*~\)\(\[^]\)/\2_B\1/
  s/_[rR]\([^~]*~\)\(\[^\)/\2_B\1/
  s/_[rR]\([^~]*~\)\(\[\)/\2_B\1/
  
  # bracket expression
  s/\(_B[^~]*~\)\([^]\[][^]\[]*\)/\2\1/
  s/\(_B[^~]*~\)\\n/<"\\n" ambiguous (use "n\\" instead)>\\n\1/
  s/\(_B[^~]*~\)\\\([^n]\)/\\\1\2/
  s/_\(B[^~]*~\)\\$/<"\\'newline'" not allowed>\\_\\\1/
  s/\(_B[^~]*~\)\(\[[.=:].[^]]*]\)/\2\1/
  s/\(_B[^~]*~\)\[\([^.=:]\)/[\1\2/
  s/_B\([^~]*~\)]/]_?r\1/
  
  # *
  s/_R\([^~]*~\)\*/<multiple "*" or intervals>*_?r\1/
  s/_r\([^~]*~\)\*/*_?R\1/
  
  # $
  s/_[rR]\([^~]*~\)\(\$\\)\)/<subexpression anchoring is optional (use \
"\\$" instead)>\2_?r\1/
  s/_[rR]\([^~]*~\)\$/$_?r\1/

  # \<newline>
  s/_[rR]'z\([^~]*~\)$/_\\\1/
  s/_[rRB][^{~]*\({*~\)$/<missing delimiter>_\1/
  s/_[rR]\([^~]*~\)\\$/<"\\'newline'" not allowed (use "\\n" \
instead)>\\_\\r\1/
  
  # any other character
  s/_[rR]\([^~]*~\)\(.\)/\2_?r\1/
  
  s/_?/_/
  /_[rRB]/t reloop
}

# force re-cycle
s/_?/_/
t loop

s/\n//g

# end of line not reached by the parser?
s/_\([^~]*~\)\(..*\)/<syntax error (rest of line ignored)>\2_C~/

# update state in the hold buffer, removing any leading \ in the state
# (these are used to control when a command can extend to the next line) 
G
s/\([^_]*\)_\\*\(.*\)\(\n\)[^~]*~\(.*\)/\2\4\3\1/
h
/</!b noerror

:error
s/[^~]*~\([0-9]*\)[^<]*<\([^>]*\).*/line \1: \2/
s/'\([^']*\)'/<\1>/g
p
g
s/.*\n//
s/<[^>]*>//g
s/'./&'a_b<c>d~e,/g
s/'\(.\)[^,]*\([^,]\)\1[^,]*,/\2/g
p
g
s/.*\n//
s/\([^<]*\)<.*/>\1/
:tospace
s/>'*[^	]/ >/
s/>\(		*\)/\1>/
s/>$/^/p
t tospace
g
# remove first issue and increment issue count
s/<[^>]*>//
s/\(.\)\(9*\)\(+[0-8]*\1\([0-9]0*\)[0-9]*\2\(0*\).*\n\)/\4\5\3/
h
/</b error

:noerror
# remove the line from the future hold buffer
s/\n.*//
h

$!d

# if the issue count is not null, report it.
/[^~]*~[^,]*,\([1-9][0-9]*\).*/{
  s//\1 issues reported./
  s/^\(1 issue\)s/\1/
  q
}
d


