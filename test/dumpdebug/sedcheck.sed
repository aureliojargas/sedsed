# sedcheck.sed - detects various POSIX compatibility issues in sed scripts
# 
# (C) 2003 Laurent Vogel - GPL version 2 or later at your option.
# 
# 2003-09-12 version 0.1 
# hide _,<,>,~ behind '
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
COMM:s/['_<>~]/&'a_b<c>d~e,/g

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
COMM:s/['_<>~]/&'a_b<c>d~e,/g

		:zzclr001
#--------------------------------------------------
s/['_<>~]/&'a_b<c>d~e,/g
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
COMM:s/\\(['_<>~]\\)[^,]*\\1\\([^,]\\)[^,]*,/'\\2/g

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
COMM:s/\\(['_<>~]\\)[^,]*\\1\\([^,]\\)[^,]*,/'\\2/g

		:zzclr002
#--------------------------------------------------
s/\(['_<>~]\)[^,]*\1\([^,]\)[^,]*,/'\2/g
# consider the hold buffer; initialize line number and issue number
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
COMM:x

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
COMM:x

		:zzclr003
#--------------------------------------------------
x
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
COMM:1 s/.*/C~0,0+012345678910999000990090/

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
COMM:1 s/.*/C~0,0+012345678910999000990090/

		:zzclr004
#--------------------------------------------------
1 s/.*/C~0,0+012345678910999000990090/
# increment line number
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
COMM:s/\\(.\\)\\(9*\\)\\(,[^+]*+[^9]*\\1\\(.0*\\).*\\2\\(0*\\)\\)/\\4\\5\\3/

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
COMM:s/\\(.\\)\\(9*\\)\\(,[^+]*+[^9]*\\1\\(.0*\\).*\\2\\(0*\\)\\)/\\4\\5\\3/

		:zzclr005
#--------------------------------------------------
s/\(.\)\(9*\)\(,[^+]*+[^9]*\1\(.0*\).*\2\(0*\)\)/\4\5\3/
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
COMM:x

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
COMM:x

		:zzclr006
#--------------------------------------------------
x
# get back state from previous line
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
COMM:G

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
COMM:G

		:zzclr007
#--------------------------------------------------
G
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
COMM:s/\\(.*\\)\\n\\([^~]*~\\).*/_\\2\\1/

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
COMM:s/\\(.*\\)\\n\\([^~]*~\\).*/_\\2\\1/

		:zzclr008
#--------------------------------------------------
s/\(.*\)\n\([^~]*~\).*/_\2\1/
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
COMM::loop

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
COMM::loop

		:zzclr009
#--------------------------------------------------
:loop
# outside commands: _~ = at top level, _{{~ inside two nested groups
		i\
COMM:s/\\(_{*~\\)\\([ 	][ 	]*\\)/<trailing 'blank's should be avoided>\\2\\1/
#--------------------------------------------------
s/\(_{*~\)\([ 	][ 	]*\)/<trailing 'blank's should be avoided>\2\1/
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
COMM:s/_\\({{*~\\);/<";" not allowed in {...} groups>;_C\\1/

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
COMM:s/_\\({{*~\\);/<";" not allowed in {...} groups>;_C\\1/

		:zzclr010
#--------------------------------------------------
s/_\({{*~\);/<";" not allowed in {...} groups>;_C\1/
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
COMM:s/_~;/;_C~/

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
COMM:s/_~;/;_C~/

		:zzclr011
#--------------------------------------------------
s/_~;/;_C~/
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
COMM:s/_\\({*~\\)}/_c\\1}/

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
COMM:s/_\\({*~\\)}/_c\\1}/

		:zzclr012
#--------------------------------------------------
s/_\({*~\)}/_c\1}/
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
COMM:s/\\(_{*~\\)\\(#.*\\)/<"#" should be preceded by ";" or 'newline'>\\2\\1/

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
COMM:s/\\(_{*~\\)\\(#.*\\)/<"#" should be preceded by ";" or 'newline'>\\2\\1/

		:zzclr013
#--------------------------------------------------
s/\(_{*~\)\(#.*\)/<"#" should be preceded by ";" or 'newline'>\2\1/
		t zzset014
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_\\({*~\\)$/_C\\1/

		t zzclr014
		:zzset014
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_\\({*~\\)$/_C\\1/

		:zzclr014
#--------------------------------------------------
s/_\({*~\)$/_C\1/
		t zzset015
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/\\(_{*~\\)\\(.*\\)/<trailing garbage after command (rest of the line \\\\Nignored)>\\2\\1/

		t zzclr015
		:zzset015
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/\\(_{*~\\)\\(.*\\)/<trailing garbage after command (rest of the line \\\\Nignored)>\\2\\1/

		:zzclr015
#--------------------------------------------------
s/\(_{*~\)\(.*\)/<trailing garbage after command (rest of the line \
ignored)>\2\1/
# 'C'ommand: skip blanks, try first address
		t zzset016
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/\\(_C[^~]*~\\)\\([ 	][ 	]*\\)/\\2\\1/

		t zzclr016
		:zzset016
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/\\(_C[^~]*~\\)\\([ 	][ 	]*\\)/\\2\\1/

		:zzclr016
#--------------------------------------------------
s/\(_C[^~]*~\)\([ 	][ 	]*\)/\2\1/
		t zzset017
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_C\\([^~]*~[0-9$/\\]\\)/_ad\\1/

		t zzclr017
		:zzset017
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_C\\([^~]*~[0-9$/\\]\\)/_ad\\1/

		:zzclr017
#--------------------------------------------------
s/_C\([^~]*~[0-9$/\]\)/_ad\1/
# 'a'ddress
		t zzset018
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/\\(_a[^~]*~\\)\\(00*\\)\\([0-9]\\)/<useless leading 0>\\2\\1\\3/

		t zzclr018
		:zzset018
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/\\(_a[^~]*~\\)\\(00*\\)\\([0-9]\\)/<useless leading 0>\\2\\1\\3/

		:zzclr018
#--------------------------------------------------
s/\(_a[^~]*~\)\(00*\)\([0-9]\)/<useless leading 0>\2\1\3/
		t zzset019
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_a\\([^~]*~\\)0/<line 0 is a GNU extension>0_\\1/

		t zzclr019
		:zzset019
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_a\\([^~]*~\\)0/<line 0 is a GNU extension>0_\\1/

		:zzclr019
#--------------------------------------------------
s/_a\([^~]*~\)0/<line 0 is a GNU extension>0_\1/
		t zzset020
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_a\\([^~]*~\\)\\\\$/\\\\<'newline' is not a valid delimiter>_\\\\b'z\\1/

		t zzclr020
		:zzset020
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_a\\([^~]*~\\)\\\\$/\\\\<'newline' is not a valid delimiter>_\\\\b'z\\1/

		:zzclr020
#--------------------------------------------------
s/_a\([^~]*~\)\\$/\\<'newline' is not a valid delimiter>_\\b'z\1/
		t zzset021
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_a\\([^~]*~\\)\\\\\\(\\\\[^\\]*\\\\\\)/\\\\<"\\\\" is not a valid delimiter>\\2_\\1/

		t zzclr021
		:zzset021
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_a\\([^~]*~\\)\\\\\\(\\\\[^\\]*\\\\\\)/\\\\<"\\\\" is not a valid delimiter>\\2_\\1/

		:zzclr021
#--------------------------------------------------
s/_a\([^~]*~\)\\\(\\[^\]*\\\)/\\<"\\" is not a valid delimiter>\2_\1/
		t zzset022
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_a[^{~]*\\({*~\\)\\\\\\(\\\\.*\\)/\\\\<"\\\\" is not a valid delimiter>\\2<missing \\\\Ndelimiter>_\\1/

		t zzclr022
		:zzset022
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_a[^{~]*\\({*~\\)\\\\\\(\\\\.*\\)/\\\\<"\\\\" is not a valid delimiter>\\2<missing \\\\Ndelimiter>_\\1/

		:zzclr022
#--------------------------------------------------
s/_a[^{~]*\({*~\)\\\(\\.*\)/\\<"\\" is not a valid delimiter>\2<missing \
delimiter>_\1/
		t zzset023
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_a\\([^~]*~\\)\\\\\\('*[^']\\)/\\\\\\2_b\\2\\1/

		t zzclr023
		:zzset023
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_a\\([^~]*~\\)\\\\\\('*[^']\\)/\\\\\\2_b\\2\\1/

		:zzclr023
#--------------------------------------------------
s/_a\([^~]*~\)\\\('*[^']\)/\\\2_b\2\1/
		t zzset024
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_a\\([^~]*~\\)\\//\\/_b\\/\\1/

		t zzclr024
		:zzset024
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_a\\([^~]*~\\)\\//\\/_b\\/\\1/

		:zzclr024
#--------------------------------------------------
s/_a\([^~]*~\)\//\/_b\/\1/
		t zzset025
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_a\\([^~]*~\\)\\$/$_\\1/

		t zzclr025
		:zzset025
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_a\\([^~]*~\\)\\$/$_\\1/

		:zzclr025
#--------------------------------------------------
s/_a\([^~]*~\)\$/$_\1/
		t zzset026
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_a\\([^~]*~\\)\\([1-9][0-9]*\\)/\\2_\\1/

		t zzclr026
		:zzset026
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_a\\([^~]*~\\)\\([1-9][0-9]*\\)/\\2_\\1/

		:zzclr026
#--------------------------------------------------
s/_a\([^~]*~\)\([1-9][0-9]*\)/\2_\1/
		t zzset027
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_a.\\([^~]*~\\)\\(.*\\)/<bad address (rest of line ignored)>\\2_\\1/

		t zzclr027
		:zzset027
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_a.\\([^~]*~\\)\\(.*\\)/<bad address (rest of line ignored)>\\2_\\1/

		:zzclr027
#--------------------------------------------------
s/_a.\([^~]*~\)\(.*\)/<bad address (rest of line ignored)>\2_\1/
# 'd' is 1addr command, 'e' is 2addr command: try second address
		t zzset028
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/\\(_d[^~]*~\\)\\([ 	][ 	]*\\),/<no 'blank's allowed>\\2\\1,/

		t zzclr028
		:zzset028
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/\\(_d[^~]*~\\)\\([ 	][ 	]*\\),/<no 'blank's allowed>\\2\\1,/

		:zzclr028
#--------------------------------------------------
s/\(_d[^~]*~\)\([ 	][ 	]*\),/<no 'blank's allowed>\2\1,/
		t zzset029
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_d\\([^~]*~\\),\\([ 	][ 	]*\\)/,<no 'blank's allowed>\\2_ae\\1/

		t zzclr029
		:zzset029
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_d\\([^~]*~\\),\\([ 	][ 	]*\\)/,<no 'blank's allowed>\\2_ae\\1/

		:zzclr029
#--------------------------------------------------
s/_d\([^~]*~\),\([ 	][ 	]*\)/,<no 'blank's allowed>\2_ae\1/
		t zzset030
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_d\\([^~]*~\\),/,_ae\\1/

		t zzclr030
		:zzset030
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_d\\([^~]*~\\),/,_ae\\1/

		:zzclr030
#--------------------------------------------------
s/_d\([^~]*~\),/,_ae\1/
# a function can be preceded by blanks and '!'s 
		t zzset031
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/\\(_[cde][^~]*~\\)\\([ 	][ 	]*\\)/\\2\\1/

		t zzclr031
		:zzset031
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/\\(_[cde][^~]*~\\)\\([ 	][ 	]*\\)/\\2\\1/

		:zzclr031
#--------------------------------------------------
s/\(_[cde][^~]*~\)\([ 	][ 	]*\)/\2\1/
		t zzset032
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/\\(_[Cde][^~]*~\\)!\\(!*\\)!/!<multiple "!" not recommended>\\2\\1!/

		t zzclr032
		:zzset032
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/\\(_[Cde][^~]*~\\)!\\(!*\\)!/!<multiple "!" not recommended>\\2\\1!/

		:zzclr032
#--------------------------------------------------
s/\(_[Cde][^~]*~\)!\(!*\)!/!<multiple "!" not recommended>\2\1!/
		t zzset033
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/\\(_[Cde][^~]*~\\)!\\([ 	][ 	]*\\)/!<no 'blank's allowed after "!">\\2\\1/

		t zzclr033
		:zzset033
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/\\(_[Cde][^~]*~\\)!\\([ 	][ 	]*\\)/!<no 'blank's allowed after "!">\\2\\1/

		:zzclr033
#--------------------------------------------------
s/\(_[Cde][^~]*~\)!\([ 	][ 	]*\)/!<no 'blank's allowed after "!">\2\1/
		t zzset034
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/\\(_[Cde][^~]*~\\)!/!\\1/

		t zzclr034
		:zzset034
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/\\(_[Cde][^~]*~\\)!/!\\1/

		:zzclr034
#--------------------------------------------------
s/\(_[Cde][^~]*~\)!/!\1/
		t zzset035
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_C\\([^~]*~.\\)/_c\\1/

		t zzclr035
		:zzset035
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_C\\([^~]*~.\\)/_c\\1/

		:zzclr035
#--------------------------------------------------
s/_C\([^~]*~.\)/_c\1/
# 0addr and 1 addr messages 
		t zzset036
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_[de]\\([^~]*~\\)$/<missing command>_\\1/

		t zzclr036
		:zzset036
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_[de]\\([^~]*~\\)$/<missing command>_\\1/

		:zzclr036
#--------------------------------------------------
s/_[de]\([^~]*~\)$/<missing command>_\1/
		t zzset037
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_[de]\\([^~]*~[:#}]\\)/<no addresses allowed>_c\\1/

		t zzclr037
		:zzset037
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_[de]\\([^~]*~[:#}]\\)/<no addresses allowed>_c\\1/

		:zzclr037
#--------------------------------------------------
s/_[de]\([^~]*~[:#}]\)/<no addresses allowed>_c\1/
		t zzset038
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_e\\([^~]*~[aiqr=]\\)/<at most one address allowed>_c\\1/

		t zzclr038
		:zzset038
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_e\\([^~]*~[aiqr=]\\)/<at most one address allowed>_c\\1/

		:zzclr038
#--------------------------------------------------
s/_e\([^~]*~[aiqr=]\)/<at most one address allowed>_c\1/
# no need to remember the number of addresses any longer
		t zzset039
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_[de]/_c/

		t zzclr039
		:zzset039
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_[de]/_c/

		:zzclr039
#--------------------------------------------------
s/_[de]/_c/
# comment, empty command
		t zzset040
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_c\\([^~]*~\\)\\(#.*\\)/\\2_\\1/

		t zzclr040
		:zzset040
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_c\\([^~]*~\\)\\(#.*\\)/\\2_\\1/

		:zzclr040
#--------------------------------------------------
s/_c\([^~]*~\)\(#.*\)/\2_\1/
		t zzset041
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_c\\([^~]*~\\);/_\\1;/

		t zzclr041
		:zzset041
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_c\\([^~]*~\\);/_\\1;/

		:zzclr041
#--------------------------------------------------
s/_c\([^~]*~\);/_\1;/
# {, }
		t zzset042
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_c\\([^~]*~\\){/{_C{\\1/

		t zzclr042
		:zzset042
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_c\\([^~]*~\\){/{_C{\\1/

		:zzclr042
#--------------------------------------------------
s/_c\([^~]*~\){/{_C{\1/
		t zzset043
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_c\\([^~]*~\\){/{_C{\\1/

		t zzclr043
		:zzset043
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_c\\([^~]*~\\){/{_C{\\1/

		:zzclr043
#--------------------------------------------------
s/_c\([^~]*~\){/{_C{\1/
		t zzset044
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/^\\([ 	]*[^ 	_][^_]*\\)_c{\\([^~]*~\\)}/\\1<"}" should be preceded by a \\\\N'newline'>}_}\\2/

		t zzclr044
		:zzset044
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/^\\([ 	]*[^ 	_][^_]*\\)_c{\\([^~]*~\\)}/\\1<"}" should be preceded by a \\\\N'newline'>}_}\\2/

		:zzclr044
#--------------------------------------------------
s/^\([ 	]*[^ 	_][^_]*\)_c{\([^~]*~\)}/\1<"}" should be preceded by a \
'newline'>}_}\2/
		t zzset045
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_c{\\([^~]*~\\)}/}_}\\1/

		t zzclr045
		:zzset045
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_c{\\([^~]*~\\)}/}_}\\1/

		:zzclr045
#--------------------------------------------------
s/_c{\([^~]*~\)}/}_}\1/
		t zzset046
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_}\\([^~]*~\\)\\([ 	]*\\);/\\2<";" not allowed after { ... } groups>;_C\\1/

		t zzclr046
		:zzset046
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_}\\([^~]*~\\)\\([ 	]*\\);/\\2<";" not allowed after { ... } groups>;_C\\1/

		:zzclr046
#--------------------------------------------------
s/_}\([^~]*~\)\([ 	]*\);/\2<";" not allowed after { ... } groups>;_C\1/
		t zzset047
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_}\\([^~]*~\\)\\([ 	]*\\)/\\2_\\1/

		t zzclr047
		:zzset047
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_}\\([^~]*~\\)\\([ 	]*\\)/\\2_\\1/

		:zzclr047
#--------------------------------------------------
s/_}\([^~]*~\)\([ 	]*\)/\2_\1/
		t zzset048
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_c~}/<mismatched { ... }>}_~/

		t zzclr048
		:zzset048
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_c~}/<mismatched { ... }>}_~/

		:zzclr048
#--------------------------------------------------
s/_c~}/<mismatched { ... }>}_~/
# a\, i\, c\
		t zzset049
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_c\\([^~]*~\\)\\([aic]\\\\\\)\\([ 	][ 	]*\\)$/\\2<trailing 'blank's>\\3_\\\\t\\1/

		t zzclr049
		:zzset049
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_c\\([^~]*~\\)\\([aic]\\\\\\)\\([ 	][ 	]*\\)$/\\2<trailing 'blank's>\\3_\\\\t\\1/

		:zzclr049
#--------------------------------------------------
s/_c\([^~]*~\)\([aic]\\\)\([ 	][ 	]*\)$/\2<trailing 'blank's>\3_\\t\1/
		t zzset050
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_c\\([^~]*~\\)\\([aic]\\\\\\)$/\\2_\\\\t\\1/

		t zzclr050
		:zzset050
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_c\\([^~]*~\\)\\([aic]\\\\\\)$/\\2_\\\\t\\1/

		:zzclr050
#--------------------------------------------------
s/_c\([^~]*~\)\([aic]\\\)$/\2_\\t\1/
		t zzset051
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_c\\([^~]*~\\)\\([aic]\\\\\\)/\\2<'newline' expected>_t\\1/

		t zzclr051
		:zzset051
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_c\\([^~]*~\\)\\([aic]\\\\\\)/\\2<'newline' expected>_t\\1/

		:zzclr051
#--------------------------------------------------
s/_c\([^~]*~\)\([aic]\\\)/\2<'newline' expected>_t\1/
		t zzset052
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_c\\([^~]*~\\)\\([aic]\\)/\\2<"\\\\'newline'" expected>_t\\1/

		t zzclr052
		:zzset052
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_c\\([^~]*~\\)\\([aic]\\)/\\2<"\\\\'newline'" expected>_t\\1/

		:zzclr052
#--------------------------------------------------
s/_c\([^~]*~\)\([aic]\)/\2<"\\'newline'" expected>_t\1/
		t zzset053
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/\\(_t[^~]*~\\)\\([^\\][^\\]*\\)/\\2\\1/

		t zzclr053
		:zzset053
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/\\(_t[^~]*~\\)\\([^\\][^\\]*\\)/\\2\\1/

		:zzclr053
#--------------------------------------------------
s/\(_t[^~]*~\)\([^\][^\]*\)/\2\1/
		t zzset054
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_\\(t[^~]*~\\)\\\\$/\\\\_\\\\\\1/

		t zzclr054
		:zzset054
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_\\(t[^~]*~\\)\\\\$/\\\\_\\\\\\1/

		:zzclr054
#--------------------------------------------------
s/_\(t[^~]*~\)\\$/\\_\\\1/
		t zzset055
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/\\(_t[^~]*~\\)\\\\\\\\/\\\\\\\\\\1/

		t zzclr055
		:zzset055
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/\\(_t[^~]*~\\)\\\\\\\\/\\\\\\\\\\1/

		:zzclr055
#--------------------------------------------------
s/\(_t[^~]*~\)\\\\/\\\\\1/
		t zzset056
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/\\(_t[^~]*~\\)\\(\\\\'*[^\\']\\)/<useless "\\\\">\\2\\1/

		t zzclr056
		:zzset056
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/\\(_t[^~]*~\\)\\(\\\\'*[^\\']\\)/<useless "\\\\">\\2\\1/

		:zzclr056
#--------------------------------------------------
s/\(_t[^~]*~\)\(\\'*[^\']\)/<useless "\\">\2\1/
		t zzset057
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_t\\([^~]*~\\)$/_\\1/

		t zzclr057
		:zzset057
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_t\\([^~]*~\\)$/_\\1/

		:zzclr057
#--------------------------------------------------
s/_t\([^~]*~\)$/_\1/
# b, t, : - POSIX is quite unclear: are leading spaces and tabs allowed?
# I assume here that zero or one leading space is OK, and anything else
# doubtful.
		t zzset058
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_c\\([^~]*~\\):\\([ 	]*[;#}]\\)/:<missing label>_\\1\\2/

		t zzclr058
		:zzset058
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_c\\([^~]*~\\):\\([ 	]*[;#}]\\)/:<missing label>_\\1\\2/

		:zzclr058
#--------------------------------------------------
s/_c\([^~]*~\):\([ 	]*[;#}]\)/:<missing label>_\1\2/
		t zzset059
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_c\\([^~]*~\\):\\([ 	]*\\)$/:<missing label>_\\1\\2/

		t zzclr059
		:zzset059
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_c\\([^~]*~\\):\\([ 	]*\\)$/:<missing label>_\\1\\2/

		:zzclr059
#--------------------------------------------------
s/_c\([^~]*~\):\([ 	]*\)$/:<missing label>_\1\2/
		t zzset060
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_c\\([^~]*~\\):\\([ 	][ 	]*\\)/:<'blank's not recommended here>\\2_l\\1/

		t zzclr060
		:zzset060
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_c\\([^~]*~\\):\\([ 	][ 	]*\\)/:<'blank's not recommended here>\\2_l\\1/

		:zzclr060
#--------------------------------------------------
s/_c\([^~]*~\):\([ 	][ 	]*\)/:<'blank's not recommended here>\2_l\1/
		t zzset061
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_c\\([^~]*~\\):/:_l\\1/

		t zzclr061
		:zzset061
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_c\\([^~]*~\\):/:_l\\1/

		:zzclr061
#--------------------------------------------------
s/_c\([^~]*~\):/:_l\1/
		t zzset062
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_c\\([^~]*~\\)\\([bt]\\)\\([ 	]*\\)$/\\2_\\1\\3/

		t zzclr062
		:zzset062
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_c\\([^~]*~\\)\\([bt]\\)\\([ 	]*\\)$/\\2_\\1\\3/

		:zzclr062
#--------------------------------------------------
s/_c\([^~]*~\)\([bt]\)\([ 	]*\)$/\2_\1\3/
		t zzset063
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_c\\([^~]*~\\)\\([bt]\\) /\\2 _l\\1/

		t zzclr063
		:zzset063
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_c\\([^~]*~\\)\\([bt]\\) /\\2 _l\\1/

		:zzclr063
#--------------------------------------------------
s/_c\([^~]*~\)\([bt]\) /\2 _l\1/
		t zzset064
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_c\\([^~]*~\\)\\([bt]\\)\\([ 	]*\\)/\\2<single 'space' recommended here>\\3_l\\1/

		t zzclr064
		:zzset064
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_c\\([^~]*~\\)\\([bt]\\)\\([ 	]*\\)/\\2<single 'space' recommended here>\\3_l\\1/

		:zzclr064
#--------------------------------------------------
s/_c\([^~]*~\)\([bt]\)\([ 	]*\)/\2<single 'space' recommended here>\3_l\1/
		t zzset065
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_l\\([^~]*~\\)\\([^;#} 	]*\\)\\([;}#]\\)/\\2<avoid "\\3" in labels>_\\1\\3/

		t zzclr065
		:zzset065
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_l\\([^~]*~\\)\\([^;#} 	]*\\)\\([;}#]\\)/\\2<avoid "\\3" in labels>_\\1\\3/

		:zzclr065
#--------------------------------------------------
s/_l\([^~]*~\)\([^;#} 	]*\)\([;}#]\)/\2<avoid "\3" in labels>_\1\3/
		t zzset066
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_l\\([^~]*~\\)\\([^;#} 	]*\\)\\([ 	]\\)/\\2<avoid 'blank's in labels>\\3_C\\1/

		t zzclr066
		:zzset066
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_l\\([^~]*~\\)\\([^;#} 	]*\\)\\([ 	]\\)/\\2<avoid 'blank's in labels>\\3_C\\1/

		:zzclr066
#--------------------------------------------------
s/_l\([^~]*~\)\([^;#} 	]*\)\([ 	]\)/\2<avoid 'blank's in labels>\3_C\1/
		t zzset067
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_l\\([^~]*~\\)\\('*[^']'*[^']'*[^']'*[^']'*[^']'*[^']'*[^']'*[^']\\)\\(..*\\)/\\2<\\\\Nlabel more than 8 characters long>\\3_\\1/

		t zzclr067
		:zzset067
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_l\\([^~]*~\\)\\('*[^']'*[^']'*[^']'*[^']'*[^']'*[^']'*[^']'*[^']\\)\\(..*\\)/\\2<\\\\Nlabel more than 8 characters long>\\3_\\1/

		:zzclr067
#--------------------------------------------------
s/_l\([^~]*~\)\('*[^']'*[^']'*[^']'*[^']'*[^']'*[^']'*[^']'*[^']\)\(..*\)/\2<\
label more than 8 characters long>\3_\1/
		t zzset068
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_l\\([^~]*~\\)\\(.*\\)\\([ 	][ 	]*\\)$/\\2<trailing 'blank's not \\\\Nrecommended>\\3_\\1/

		t zzclr068
		:zzset068
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_l\\([^~]*~\\)\\(.*\\)\\([ 	][ 	]*\\)$/\\2<trailing 'blank's not \\\\Nrecommended>\\3_\\1/

		:zzclr068
#--------------------------------------------------
s/_l\([^~]*~\)\(.*\)\([ 	][ 	]*\)$/\2<trailing 'blank's not \
recommended>\3_\1/
		t zzset069
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_l\\([^~]*~\\)\\(.*\\)/\\2_\\1/

		t zzclr069
		:zzset069
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_l\\([^~]*~\\)\\(.*\\)/\\2_\\1/

		:zzclr069
#--------------------------------------------------
s/_l\([^~]*~\)\(.*\)/\2_\1/
# d, D, g, G, h, H, l, n, N, p, P, q, x, =
		t zzset070
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_c\\([^~]*~\\)\\([dDgGhHlnNpPqx=]\\)/\\2_\\1/

		t zzclr070
		:zzset070
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_c\\([^~]*~\\)\\([dDgGhHlnNpPqx=]\\)/\\2_\\1/

		:zzclr070
#--------------------------------------------------
s/_c\([^~]*~\)\([dDgGhHlnNpPqx=]\)/\2_\1/
# r, w
		t zzset071
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_c\\([^~]*~\\)\\([rw]\\)/\\2_n\\1/

		t zzclr071
		:zzset071
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_c\\([^~]*~\\)\\([rw]\\)/\\2_n\\1/

		:zzclr071
#--------------------------------------------------
s/_c\([^~]*~\)\([rw]\)/\2_n\1/
		t zzset072
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_n\\([^~]*~\\)\\([ 	][ 	]*\\)/\\2_m\\1/

		t zzclr072
		:zzset072
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_n\\([^~]*~\\)\\([ 	][ 	]*\\)/\\2_m\\1/

		:zzclr072
#--------------------------------------------------
s/_n\([^~]*~\)\([ 	][ 	]*\)/\2_m\1/
		t zzset073
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_n\\([^~]*~\\)\\(..*\\)/<'blank's expected>\\2_\\1/

		t zzclr073
		:zzset073
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_n\\([^~]*~\\)\\(..*\\)/<'blank's expected>\\2_\\1/

		:zzclr073
#--------------------------------------------------
s/_n\([^~]*~\)\(..*\)/<'blank's expected>\2_\1/
		t zzset074
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_m\\([^~]*~\\)$/<missing filename>_\\1/

		t zzclr074
		:zzset074
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_m\\([^~]*~\\)$/<missing filename>_\\1/

		:zzclr074
#--------------------------------------------------
s/_m\([^~]*~\)$/<missing filename>_\1/
		t zzset075
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_m\\([^~]*~\\)\\([^;#]*\\)\\([;#].*\\)/\\2<part of the filename>\\3_\\1/

		t zzclr075
		:zzset075
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_m\\([^~]*~\\)\\([^;#]*\\)\\([;#].*\\)/\\2<part of the filename>\\3_\\1/

		:zzclr075
#--------------------------------------------------
s/_m\([^~]*~\)\([^;#]*\)\([;#].*\)/\2<part of the filename>\3_\1/
		t zzset076
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_m\\([^~]*~\\)\\(..*\\)/\\2_\\1/

		t zzclr076
		:zzset076
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_m\\([^~]*~\\)\\(..*\\)/\\2_\\1/

		:zzclr076
#--------------------------------------------------
s/_m\([^~]*~\)\(..*\)/\2_\1/
# s, y
		t zzset077
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_c\\([^~]*~\\)s$/s<'newline' is not a valid delimiter>_\\\\b'zs'zS0\\1/

		t zzclr077
		:zzset077
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_c\\([^~]*~\\)s$/s<'newline' is not a valid delimiter>_\\\\b'zs'zS0\\1/

		:zzclr077
#--------------------------------------------------
s/_c\([^~]*~\)s$/s<'newline' is not a valid delimiter>_\\b'zs'zS0\1/
		t zzset078
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_c\\([^~]*~\\)y$/y<'newline' is not a valid delimiter>_\\\\y'zy'y\\1/

		t zzclr078
		:zzset078
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_c\\([^~]*~\\)y$/y<'newline' is not a valid delimiter>_\\\\y'zy'y\\1/

		:zzclr078
#--------------------------------------------------
s/_c\([^~]*~\)y$/y<'newline' is not a valid delimiter>_\\y'zy'y\1/
		t zzset079
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_c\\([^~]*~\\)s\\(\\\\[^\\]*\\\\[^\\]*\\\\\\)/s<"\\\\" is not a valid delimiter>\\2_S0\\1/

		t zzclr079
		:zzset079
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_c\\([^~]*~\\)s\\(\\\\[^\\]*\\\\[^\\]*\\\\\\)/s<"\\\\" is not a valid delimiter>\\2_S0\\1/

		:zzclr079
#--------------------------------------------------
s/_c\([^~]*~\)s\(\\[^\]*\\[^\]*\\\)/s<"\\" is not a valid delimiter>\2_S0\1/
		t zzset080
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_c\\([^~]*~\\)y\\(\\\\[^\\]*\\\\[^\\]*\\\\\\)/y<"\\\\" is not a valid delimiter>\\2_\\1/

		t zzclr080
		:zzset080
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_c\\([^~]*~\\)y\\(\\\\[^\\]*\\\\[^\\]*\\\\\\)/y<"\\\\" is not a valid delimiter>\\2_\\1/

		:zzclr080
#--------------------------------------------------
s/_c\([^~]*~\)y\(\\[^\]*\\[^\]*\\\)/y<"\\" is not a valid delimiter>\2_\1/
		t zzset081
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_c\\([^~]*~\\)\\([sy]\\)\\(\\\\.*\\)/\\2<"\\\\" is not a valid delimiter>\\3<missing \\\\Ndelimiter>_\\1/

		t zzclr081
		:zzset081
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_c\\([^~]*~\\)\\([sy]\\)\\(\\\\.*\\)/\\2<"\\\\" is not a valid delimiter>\\3<missing \\\\Ndelimiter>_\\1/

		:zzclr081
#--------------------------------------------------
s/_c\([^~]*~\)\([sy]\)\(\\.*\)/\2<"\\" is not a valid delimiter>\3<missing \
delimiter>_\1/
		t zzset082
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_c\\([^~]*~\\)s\\('*[^']\\)/s\\2_b\\2s\\2S0\\1/

		t zzclr082
		:zzset082
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_c\\([^~]*~\\)s\\('*[^']\\)/s\\2_b\\2s\\2S0\\1/

		:zzclr082
#--------------------------------------------------
s/_c\([^~]*~\)s\('*[^']\)/s\2_b\2s\2S0\1/
		t zzset083
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_c\\([^~]*~\\)y\\('*[^']\\)/y\\2_y\\2y\\2\\1/

		t zzclr083
		:zzset083
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_c\\([^~]*~\\)y\\('*[^']\\)/y\\2_y\\2y\\2\\1/

		:zzclr083
#--------------------------------------------------
s/_c\([^~]*~\)y\('*[^']\)/y\2_y\2y\2\1/
# s right hand side and both sides of y
		t zzset084
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM::sy

		t zzclr084
		:zzset084
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM::sy

		:zzclr084
#--------------------------------------------------
:sy
		i\
COMM:s/\\(_[sy]\\/[^~]*~\\)\\([^\\/][^\\/]*\\)/\\2\\1/
#--------------------------------------------------
s/\(_[sy]\/[^~]*~\)\([^\/][^\/]*\)/\2\1/
		t zzset085
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_[sy]\\('*[^']\\)\\([^~]*~\\)\\1/\\1_\\2/

		t zzclr085
		:zzset085
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_[sy]\\('*[^']\\)\\([^~]*~\\)\\1/\\1_\\2/

		:zzclr085
#--------------------------------------------------
s/_[sy]\('*[^']\)\([^~]*~\)\1/\1_\2/
		t zzset086
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_\\([sy][^~]*~\\)\\([^\\]\\)/\\2_?\\1/

		t zzclr086
		:zzset086
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_\\([sy][^~]*~\\)\\([^\\]\\)/\\2_?\\1/

		:zzclr086
#--------------------------------------------------
s/_\([sy][^~]*~\)\([^\]\)/\2_?\1/
		t zzset087
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_\\(s\\([1-9&]\\)[^~]*~\\)\\\\\\2/<"\\\\\\2" ambiguous with "\\2" as delimiter\\\\N>\\\\\\2_?\\1/

		t zzclr087
		:zzset087
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_\\(s\\([1-9&]\\)[^~]*~\\)\\\\\\2/<"\\\\\\2" ambiguous with "\\2" as delimiter\\\\N>\\\\\\2_?\\1/

		:zzclr087
#--------------------------------------------------
s/_\(s\([1-9&]\)[^~]*~\)\\\2/<"\\\2" ambiguous with "\2" as delimiter\
>\\\2_?\1/
		t zzset088
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_\\([sy]\\('*[^']\\)[^~]*~\\)\\\\\\2/\\\\\\2_?\\1/

		t zzclr088
		:zzset088
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_\\([sy]\\('*[^']\\)[^~]*~\\)\\\\\\2/\\\\\\2_?\\1/

		:zzclr088
#--------------------------------------------------
s/_\([sy]\('*[^']\)[^~]*~\)\\\2/\\\2_?\1/
		t zzset089
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_\\(s[^~]*~\\)\\(\\\\[^1-9&n\\]\\)/<"\\2" unspecified>\\2_?\\1/

		t zzclr089
		:zzset089
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_\\(s[^~]*~\\)\\(\\\\[^1-9&n\\]\\)/<"\\2" unspecified>\\2_?\\1/

		:zzclr089
#--------------------------------------------------
s/_\(s[^~]*~\)\(\\[^1-9&n\]\)/<"\2" unspecified>\2_?\1/
		t zzset090
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_\\(s[^~]*~\\)\\(\\\\n\\)/<"\\\\n" unspecified (use 'newline' instead)>\\2_?\\1/

		t zzclr090
		:zzset090
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_\\(s[^~]*~\\)\\(\\\\n\\)/<"\\\\n" unspecified (use 'newline' instead)>\\2_?\\1/

		:zzclr090
#--------------------------------------------------
s/_\(s[^~]*~\)\(\\n\)/<"\\n" unspecified (use 'newline' instead)>\2_?\1/
		t zzset091
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_\\(y[^~]*~\\)\\(\\\\[^n\\]\\)/<"\\2" unspecified>\\2_?\\1/

		t zzclr091
		:zzset091
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_\\(y[^~]*~\\)\\(\\\\[^n\\]\\)/<"\\2" unspecified>\\2_?\\1/

		:zzclr091
#--------------------------------------------------
s/_\(y[^~]*~\)\(\\[^n\]\)/<"\2" unspecified>\2_?\1/
		t zzset092
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_\\([sy][^~]*~\\)\\(\\\\'*.\\)/\\2_?\\1/

		t zzclr092
		:zzset092
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_\\([sy][^~]*~\\)\\(\\\\'*.\\)/\\2_?\\1/

		:zzclr092
#--------------------------------------------------
s/_\([sy][^~]*~\)\(\\'*.\)/\2_?\1/
		t zzset093
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_\\(s[^~]*~\\)\\\\$/\\\\_\\\\\\1/

		t zzclr093
		:zzset093
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_\\(s[^~]*~\\)\\\\$/\\\\_\\\\\\1/

		:zzclr093
#--------------------------------------------------
s/_\(s[^~]*~\)\\$/\\_\\\1/
		t zzset094
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_\\(y[^~]*~\\)\\\\$/<"\\\\'newline'" invalid (use "\\\\n" instead)>\\\\_\\\\\\1/

		t zzclr094
		:zzset094
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_\\(y[^~]*~\\)\\\\$/<"\\\\'newline'" invalid (use "\\\\n" instead)>\\\\_\\\\\\1/

		:zzclr094
#--------------------------------------------------
s/_\(y[^~]*~\)\\$/<"\\'newline'" invalid (use "\\n" instead)>\\_\\\1/
		t zzset095
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_y'y\\([^~]*~\\)$/_\\1/

		t zzclr095
		:zzset095
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_y'y\\([^~]*~\\)$/_\\1/

		:zzclr095
#--------------------------------------------------
s/_y'y\([^~]*~\)$/_\1/
		t zzset096
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_[sy]'z\\([^~]*~\\)$/_\\\\\\1/

		t zzclr096
		:zzset096
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_[sy]'z\\([^~]*~\\)$/_\\\\\\1/

		:zzclr096
#--------------------------------------------------
s/_[sy]'z\([^~]*~\)$/_\\\1/
		t zzset097
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_y'*[^']y'*[^']\\([^~]*~\\)$/<missing delimiter>_\\1/

		t zzclr097
		:zzset097
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_y'*[^']y'*[^']\\([^~]*~\\)$/<missing delimiter>_\\1/

		:zzclr097
#--------------------------------------------------
s/_y'*[^']y'*[^']\([^~]*~\)$/<missing delimiter>_\1/
		t zzset098
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_[sy]'*[^']\\([^~]*~\\)$/<missing delimiter>_\\1/

		t zzclr098
		:zzset098
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_[sy]'*[^']\\([^~]*~\\)$/<missing delimiter>_\\1/

		:zzclr098
#--------------------------------------------------
s/_[sy]'*[^']\([^~]*~\)$/<missing delimiter>_\1/
		t zzset099
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:/_[sy]/ t sy

		t zzclr099
		:zzset099
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:/_[sy]/ t sy

		:zzclr099
#--------------------------------------------------
/_[sy]/ t sy
# s flags
		i\
COMM:s/\\(_S[^~]*~\\)p/p\\1/
#--------------------------------------------------
s/\(_S[^~]*~\)p/p\1/
		t zzset100
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_S[01]\\([^~]*~\\)g/g_S1\\1/

		t zzclr100
		:zzset100
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_S[01]\\([^~]*~\\)g/g_S1\\1/

		:zzclr100
#--------------------------------------------------
s/_S[01]\([^~]*~\)g/g_S1\1/
		t zzset101
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_S0\\([^~]*~\\)\\([0-9][0-9]*\\)/\\2_S2\\1/

		t zzclr101
		:zzset101
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_S0\\([^~]*~\\)\\([0-9][0-9]*\\)/\\2_S2\\1/

		:zzclr101
#--------------------------------------------------
s/_S0\([^~]*~\)\([0-9][0-9]*\)/\2_S2\1/
		t zzset102
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/\\(_S1[^~]*~\\)\\([0-9][0-9]*\\)/<both "g" and "n" flags>\\2\\1/

		t zzclr102
		:zzset102
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/\\(_S1[^~]*~\\)\\([0-9][0-9]*\\)/<both "g" and "n" flags>\\2\\1/

		:zzclr102
#--------------------------------------------------
s/\(_S1[^~]*~\)\([0-9][0-9]*\)/<both "g" and "n" flags>\2\1/
		t zzset103
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/\\(_S2[^~]*~\\)\\([0-9][0-9]*\\)/<multiple "n" flags>\\2\\1/

		t zzclr103
		:zzset103
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/\\(_S2[^~]*~\\)\\([0-9][0-9]*\\)/<multiple "n" flags>\\2\\1/

		:zzclr103
#--------------------------------------------------
s/\(_S2[^~]*~\)\([0-9][0-9]*\)/<multiple "n" flags>\2\1/
		t zzset104
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/\\(_S2[^~]*~\\)g/<both "g" and "n" flags>g\\1/

		t zzclr104
		:zzset104
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/\\(_S2[^~]*~\\)g/<both "g" and "n" flags>g\\1/

		:zzclr104
#--------------------------------------------------
s/\(_S2[^~]*~\)g/<both "g" and "n" flags>g\1/
		t zzset105
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_S.\\([^~]*~[ 	;#]\\)/_\\1/

		t zzclr105
		:zzset105
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_S.\\([^~]*~[ 	;#]\\)/_\\1/

		:zzclr105
#--------------------------------------------------
s/_S.\([^~]*~[ 	;#]\)/_\1/
		t zzset106
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_S.\\([^~]*~\\)$/_\\1/

		t zzclr106
		:zzset106
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_S.\\([^~]*~\\)$/_\\1/

		:zzclr106
#--------------------------------------------------
s/_S.\([^~]*~\)$/_\1/
		t zzset107
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_S.\\([^~]*~\\)\\([^pg0-9w]\\)$/<unknown flag>\\2_\\1/

		t zzclr107
		:zzset107
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_S.\\([^~]*~\\)\\([^pg0-9w]\\)$/<unknown flag>\\2_\\1/

		:zzclr107
#--------------------------------------------------
s/_S.\([^~]*~\)\([^pg0-9w]\)$/<unknown flag>\2_\1/
		t zzset108
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_S.\\([^~]*~\\)\\([^pg0-9w].*\\)/<unknown flag (rest of line ignored)>\\2_\\1/

		t zzclr108
		:zzset108
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_S.\\([^~]*~\\)\\([^pg0-9w].*\\)/<unknown flag (rest of line ignored)>\\2_\\1/

		:zzclr108
#--------------------------------------------------
s/_S.\([^~]*~\)\([^pg0-9w].*\)/<unknown flag (rest of line ignored)>\2_\1/
		t zzset109
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_S.\\([^~]*~\\)w/w_n\\1/

		t zzclr109
		:zzset109
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_S.\\([^~]*~\\)w/w_n\\1/

		:zzclr109
#--------------------------------------------------
s/_S.\([^~]*~\)w/w_n\1/
# #
		t zzset110
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_c\\([^~]*~\\)\\(#.*\\)/\\2_\\1/

		t zzclr110
		:zzset110
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_c\\([^~]*~\\)\\(#.*\\)/\\2_\\1/

		:zzclr110
#--------------------------------------------------
s/_c\([^~]*~\)\(#.*\)/\2_\1/
		t zzset111
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_c\\([^~]*~\\)\\([^#; 	].*\\)/<unknown command (rest of line ignored)>\\2_\\1/

		t zzclr111
		:zzset111
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_c\\([^~]*~\\)\\([^#; 	].*\\)/<unknown command (rest of line ignored)>\\2_\\1/

		:zzclr111
#--------------------------------------------------
s/_c\([^~]*~\)\([^#; 	].*\)/<unknown command (rest of line ignored)>\2_\1/
# 'b'eginning of regexp
# "*" is special unless at the beginning of the regex (after optional "^")
		t zzset112
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_b\\([^^][^~]*~\\)^/^_b\\1/

		t zzclr112
		:zzset112
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_b\\([^^][^~]*~\\)^/^_b\\1/

		:zzclr112
#--------------------------------------------------
s/_b\([^^][^~]*~\)^/^_b\1/
		t zzset113
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_b\\([^*][^~]*~\\)\\*/*_r\\1/

		t zzclr113
		:zzset113
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_b\\([^*][^~]*~\\)\\*/*_r\\1/

		:zzclr113
#--------------------------------------------------
s/_b\([^*][^~]*~\)\*/*_r\1/
		t zzset114
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_b/_r/

		t zzclr114
		:zzset114
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_b/_r/

		:zzclr114
#--------------------------------------------------
s/_b/_r/
# 'r'egexp loop. state 'R' after a repeated symbol and 'B' inside a bracket
# expression. 
		t zzset115
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:/_[rB]/ {

		t zzclr115
		:zzset115
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:/_[rB]/ {

		:zzclr115
#--------------------------------------------------
/_[rB]/ {
		i\
COMM::reloop
#--------------------------------------------------
:reloop
# shortcut, when the delimiter is "/"
		i\
COMM:s/_[rR]\\(\\/[^~]*~\\)\\([^\\/*$[][^\\/*$[]*\\)/\\2_r\\1/
#--------------------------------------------------
s/_[rR]\(\/[^~]*~\)\([^\/*$[][^\/*$[]*\)/\2_r\1/
		t zzset116
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_[rR]\\('*[^']\\)\\([^~]*~\\)\\1/\\1_\\2/

		t zzclr116
		:zzset116
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_[rR]\\('*[^']\\)\\([^~]*~\\)\\1/\\1_\\2/

		:zzclr116
#--------------------------------------------------
s/_[rR]\('*[^']\)\([^~]*~\)\1/\1_\2/
# \x
		t zzset117
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_[rR]\\(\\([n.(){1-9^$*[]\\)[^~]*~\\)\\\\\\2/<"\\\\\\2" ambiguous with "\\2" as \\\\Ndelimiter>_?r\\1/

		t zzclr117
		:zzset117
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_[rR]\\(\\([n.(){1-9^$*[]\\)[^~]*~\\)\\\\\\2/<"\\\\\\2" ambiguous with "\\2" as \\\\Ndelimiter>_?r\\1/

		:zzclr117
#--------------------------------------------------
s/_[rR]\(\([n.(){1-9^$*[]\)[^~]*~\)\\\2/<"\\\2" ambiguous with "\2" as \
delimiter>_?r\1/
		t zzset118
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_[rR]\\(\\('*[^']\\)[^~]*~\\)\\\\\\2/\\\\\\2_?r\\1/

		t zzclr118
		:zzset118
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_[rR]\\(\\('*[^']\\)[^~]*~\\)\\\\\\2/\\\\\\2_?r\\1/

		:zzclr118
#--------------------------------------------------
s/_[rR]\(\('*[^']\)[^~]*~\)\\\2/\\\2_?r\1/
		t zzset119
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_[rR]\\([^~]*~\\)\\(\\\\[^n.\\*^$(){1-9?+[]\\)/<"\\2" undefined>\\2_?r\\1/

		t zzclr119
		:zzset119
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_[rR]\\([^~]*~\\)\\(\\\\[^n.\\*^$(){1-9?+[]\\)/<"\\2" undefined>\\2_?r\\1/

		:zzclr119
#--------------------------------------------------
s/_[rR]\([^~]*~\)\(\\[^n.\*^$(){1-9?+[]\)/<"\2" undefined>\2_?r\1/
		t zzset120
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_[rR]\\([^~]*~\\)\\\\?/<"\\\\?" undefined (use "\\\\{0,1\\\\}" instead)>\\\\?_?r\\1/

		t zzclr120
		:zzset120
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_[rR]\\([^~]*~\\)\\\\?/<"\\\\?" undefined (use "\\\\{0,1\\\\}" instead)>\\\\?_?r\\1/

		:zzclr120
#--------------------------------------------------
s/_[rR]\([^~]*~\)\\?/<"\\?" undefined (use "\\{0,1\\}" instead)>\\?_?r\1/
		t zzset121
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_[rR]\\([^~]*~\\)\\\\+/<"\\\\+" undefined (use "\\\\{1,\\\\}" instead)>\\\\+_?r\\1/

		t zzclr121
		:zzset121
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_[rR]\\([^~]*~\\)\\\\+/<"\\\\+" undefined (use "\\\\{1,\\\\}" instead)>\\\\+_?r\\1/

		:zzclr121
#--------------------------------------------------
s/_[rR]\([^~]*~\)\\+/<"\\+" undefined (use "\\{1,\\}" instead)>\\+_?r\1/
		t zzset122
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_[rR]\\([^~]*~\\)\\(\\\\[n.\\*^$1-9)[]\\)/\\2_?r\\1/

		t zzclr122
		:zzset122
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_[rR]\\([^~]*~\\)\\(\\\\[n.\\*^$1-9)[]\\)/\\2_?r\\1/

		:zzclr122
#--------------------------------------------------
s/_[rR]\([^~]*~\)\(\\[n.\*^$1-9)[]\)/\2_?r\1/
		t zzset123
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_[rR]\\([^~]*~\\)\\\\(\\^/\\\\(<subexpression anchoring is optional (use \\\\N"\\\\^" instead)>^_?r\\1/

		t zzclr123
		:zzset123
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_[rR]\\([^~]*~\\)\\\\(\\^/\\\\(<subexpression anchoring is optional (use \\\\N"\\\\^" instead)>^_?r\\1/

		:zzclr123
#--------------------------------------------------
s/_[rR]\([^~]*~\)\\(\^/\\(<subexpression anchoring is optional (use \
"\\^" instead)>^_?r\1/
		t zzset124
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_[rR]\\([^~]*~\\)\\\\(\\*/\\\\(*_?r\\1/

		t zzclr124
		:zzset124
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_[rR]\\([^~]*~\\)\\\\(\\*/\\\\(*_?r\\1/

		:zzclr124
#--------------------------------------------------
s/_[rR]\([^~]*~\)\\(\*/\\(*_?r\1/
		t zzset125
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_[rR]\\([^~]*~\\)\\\\(/\\\\(_?r\\1/

		t zzclr125
		:zzset125
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_[rR]\\([^~]*~\\)\\\\(/\\\\(_?r\\1/

		:zzclr125
#--------------------------------------------------
s/_[rR]\([^~]*~\)\\(/\\(_?r\1/
# \{...\}
		t zzset126
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_[rR]\\([^~]*~\\)\\(\\\\{\\)\\([^0-9]\\)/\\2<bad interval>\\3_?r\\1/

		t zzclr126
		:zzset126
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_[rR]\\([^~]*~\\)\\(\\\\{\\)\\([^0-9]\\)/\\2<bad interval>\\3_?r\\1/

		:zzclr126
#--------------------------------------------------
s/_[rR]\([^~]*~\)\(\\{\)\([^0-9]\)/\2<bad interval>\3_?r\1/
		t zzset127
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_[rR]\\([^~]*~\\)\\(\\\\{[0-9][0-9]*\\)\\([^\\,0-9]\\)/\\2<bad interval>\\3_?r\\1/

		t zzclr127
		:zzset127
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_[rR]\\([^~]*~\\)\\(\\\\{[0-9][0-9]*\\)\\([^\\,0-9]\\)/\\2<bad interval>\\3_?r\\1/

		:zzclr127
#--------------------------------------------------
s/_[rR]\([^~]*~\)\(\\{[0-9][0-9]*\)\([^\,0-9]\)/\2<bad interval>\3_?r\1/
		t zzset128
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_[rR]\\([^~]*~\\)\\(\\\\{[0-9][0-9]*\\)\\(\\\\[^}]\\)/\\2<bad interval>\\3_?r\\1/

		t zzclr128
		:zzset128
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_[rR]\\([^~]*~\\)\\(\\\\{[0-9][0-9]*\\)\\(\\\\[^}]\\)/\\2<bad interval>\\3_?r\\1/

		:zzclr128
#--------------------------------------------------
s/_[rR]\([^~]*~\)\(\\{[0-9][0-9]*\)\(\\[^}]\)/\2<bad interval>\3_?r\1/
		t zzset129
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_[rR]\\([^~]*~\\)\\(\\\\{[0-9][0-9]*,\\)\\([^\\0-9]\\)/\\2<bad interval>\\3_?r\\1/

		t zzclr129
		:zzset129
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_[rR]\\([^~]*~\\)\\(\\\\{[0-9][0-9]*,\\)\\([^\\0-9]\\)/\\2<bad interval>\\3_?r\\1/

		:zzclr129
#--------------------------------------------------
s/_[rR]\([^~]*~\)\(\\{[0-9][0-9]*,\)\([^\0-9]\)/\2<bad interval>\3_?r\1/
		t zzset130
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_[rR]\\([^~]*~\\)\\(\\\\{[0-9][0-9]*,[0-9][0-9]*\\)\\([^\\0-9]\\)/\\2<bad \\\\Ninterval>\\3_?r\\1/

		t zzclr130
		:zzset130
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_[rR]\\([^~]*~\\)\\(\\\\{[0-9][0-9]*,[0-9][0-9]*\\)\\([^\\0-9]\\)/\\2<bad \\\\Ninterval>\\3_?r\\1/

		:zzclr130
#--------------------------------------------------
s/_[rR]\([^~]*~\)\(\\{[0-9][0-9]*,[0-9][0-9]*\)\([^\0-9]\)/\2<bad \
interval>\3_?r\1/
		t zzset131
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_[rR]\\([^~]*~\\)\\(\\\\{[0-9][0-9]*,[0-9][0-9]*\\)\\(\\\\[^}]\\)/\\2<bad \\\\Ninterval>\\3_?r\\1/

		t zzclr131
		:zzset131
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_[rR]\\([^~]*~\\)\\(\\\\{[0-9][0-9]*,[0-9][0-9]*\\)\\(\\\\[^}]\\)/\\2<bad \\\\Ninterval>\\3_?r\\1/

		:zzclr131
#--------------------------------------------------
s/_[rR]\([^~]*~\)\(\\{[0-9][0-9]*,[0-9][0-9]*\)\(\\[^}]\)/\2<bad \
interval>\3_?r\1/
		t zzset132
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_R\\([^~]*~\\)\\(\\\\{[^}]*}\\)/<multiple "*" or intervals>\\2_?r\\1/

		t zzclr132
		:zzset132
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_R\\([^~]*~\\)\\(\\\\{[^}]*}\\)/<multiple "*" or intervals>\\2_?r\\1/

		:zzclr132
#--------------------------------------------------
s/_R\([^~]*~\)\(\\{[^}]*}\)/<multiple "*" or intervals>\2_?r\1/
		t zzset133
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_r\\([^~]*~\\)\\(\\\\{[^}]*}\\)/\\2_?R\\1/

		t zzclr133
		:zzset133
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_r\\([^~]*~\\)\\(\\\\{[^}]*}\\)/\\2_?R\\1/

		:zzclr133
#--------------------------------------------------
s/_r\([^~]*~\)\(\\{[^}]*}\)/\2_?R\1/
# entering a bracket expression
		t zzset134
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_[rR]\\([^~]*~\\)\\(\\[^^]\\)/\\2_B\\1/

		t zzclr134
		:zzset134
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_[rR]\\([^~]*~\\)\\(\\[^^]\\)/\\2_B\\1/

		:zzclr134
#--------------------------------------------------
s/_[rR]\([^~]*~\)\(\[^^]\)/\2_B\1/
		t zzset135
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_[rR]\\([^~]*~\\)\\(\\[^]\\)/\\2_B\\1/

		t zzclr135
		:zzset135
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_[rR]\\([^~]*~\\)\\(\\[^]\\)/\\2_B\\1/

		:zzclr135
#--------------------------------------------------
s/_[rR]\([^~]*~\)\(\[^]\)/\2_B\1/
		t zzset136
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_[rR]\\([^~]*~\\)\\(\\[^\\)/\\2_B\\1/

		t zzclr136
		:zzset136
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_[rR]\\([^~]*~\\)\\(\\[^\\)/\\2_B\\1/

		:zzclr136
#--------------------------------------------------
s/_[rR]\([^~]*~\)\(\[^\)/\2_B\1/
		t zzset137
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_[rR]\\([^~]*~\\)\\(\\[\\)/\\2_B\\1/

		t zzclr137
		:zzset137
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_[rR]\\([^~]*~\\)\\(\\[\\)/\\2_B\\1/

		:zzclr137
#--------------------------------------------------
s/_[rR]\([^~]*~\)\(\[\)/\2_B\1/
# bracket expression
		t zzset138
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/\\(_B[^~]*~\\)\\([^]\\[][^]\\[]*\\)/\\2\\1/

		t zzclr138
		:zzset138
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/\\(_B[^~]*~\\)\\([^]\\[][^]\\[]*\\)/\\2\\1/

		:zzclr138
#--------------------------------------------------
s/\(_B[^~]*~\)\([^]\[][^]\[]*\)/\2\1/
		t zzset139
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/\\(_B[^~]*~\\)\\\\n/<"\\\\n" ambiguous (use "n\\\\" instead)>\\\\n\\1/

		t zzclr139
		:zzset139
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/\\(_B[^~]*~\\)\\\\n/<"\\\\n" ambiguous (use "n\\\\" instead)>\\\\n\\1/

		:zzclr139
#--------------------------------------------------
s/\(_B[^~]*~\)\\n/<"\\n" ambiguous (use "n\\" instead)>\\n\1/
		t zzset140
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/\\(_B[^~]*~\\)\\\\\\([^n]\\)/\\\\\\1\\2/

		t zzclr140
		:zzset140
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/\\(_B[^~]*~\\)\\\\\\([^n]\\)/\\\\\\1\\2/

		:zzclr140
#--------------------------------------------------
s/\(_B[^~]*~\)\\\([^n]\)/\\\1\2/
		t zzset141
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_\\(B[^~]*~\\)\\\\$/<"\\\\'newline'" not allowed>\\\\_\\\\\\1/

		t zzclr141
		:zzset141
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_\\(B[^~]*~\\)\\\\$/<"\\\\'newline'" not allowed>\\\\_\\\\\\1/

		:zzclr141
#--------------------------------------------------
s/_\(B[^~]*~\)\\$/<"\\'newline'" not allowed>\\_\\\1/
		t zzset142
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/\\(_B[^~]*~\\)\\(\\[[.=:].[^]]*]\\)/\\2\\1/

		t zzclr142
		:zzset142
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/\\(_B[^~]*~\\)\\(\\[[.=:].[^]]*]\\)/\\2\\1/

		:zzclr142
#--------------------------------------------------
s/\(_B[^~]*~\)\(\[[.=:].[^]]*]\)/\2\1/
		t zzset143
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/\\(_B[^~]*~\\)\\[\\([^.=:]\\)/[\\1\\2/

		t zzclr143
		:zzset143
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/\\(_B[^~]*~\\)\\[\\([^.=:]\\)/[\\1\\2/

		:zzclr143
#--------------------------------------------------
s/\(_B[^~]*~\)\[\([^.=:]\)/[\1\2/
		t zzset144
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_B\\([^~]*~\\)]/]_?r\\1/

		t zzclr144
		:zzset144
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_B\\([^~]*~\\)]/]_?r\\1/

		:zzclr144
#--------------------------------------------------
s/_B\([^~]*~\)]/]_?r\1/
# *
		t zzset145
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_R\\([^~]*~\\)\\*/<multiple "*" or intervals>*_?r\\1/

		t zzclr145
		:zzset145
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_R\\([^~]*~\\)\\*/<multiple "*" or intervals>*_?r\\1/

		:zzclr145
#--------------------------------------------------
s/_R\([^~]*~\)\*/<multiple "*" or intervals>*_?r\1/
		t zzset146
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_r\\([^~]*~\\)\\*/*_?R\\1/

		t zzclr146
		:zzset146
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_r\\([^~]*~\\)\\*/*_?R\\1/

		:zzclr146
#--------------------------------------------------
s/_r\([^~]*~\)\*/*_?R\1/
# $
		t zzset147
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_[rR]\\([^~]*~\\)\\(\\$\\\\)\\)/<subexpression anchoring is optional (use \\\\N"\\\\$" instead)>\\2_?r\\1/

		t zzclr147
		:zzset147
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_[rR]\\([^~]*~\\)\\(\\$\\\\)\\)/<subexpression anchoring is optional (use \\\\N"\\\\$" instead)>\\2_?r\\1/

		:zzclr147
#--------------------------------------------------
s/_[rR]\([^~]*~\)\(\$\\)\)/<subexpression anchoring is optional (use \
"\\$" instead)>\2_?r\1/
		t zzset148
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_[rR]\\([^~]*~\\)\\$/$_?r\\1/

		t zzclr148
		:zzset148
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_[rR]\\([^~]*~\\)\\$/$_?r\\1/

		:zzclr148
#--------------------------------------------------
s/_[rR]\([^~]*~\)\$/$_?r\1/
# \<newline>
		t zzset149
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_[rR]'z\\([^~]*~\\)$/_\\\\\\1/

		t zzclr149
		:zzset149
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_[rR]'z\\([^~]*~\\)$/_\\\\\\1/

		:zzclr149
#--------------------------------------------------
s/_[rR]'z\([^~]*~\)$/_\\\1/
		t zzset150
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_[rRB][^{~]*\\({*~\\)$/<missing delimiter>_\\1/

		t zzclr150
		:zzset150
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_[rRB][^{~]*\\({*~\\)$/<missing delimiter>_\\1/

		:zzclr150
#--------------------------------------------------
s/_[rRB][^{~]*\({*~\)$/<missing delimiter>_\1/
		t zzset151
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_[rR]\\([^~]*~\\)\\\\$/<"\\\\'newline'" not allowed (use "\\\\n" \\\\Ninstead)>\\\\_\\\\r\\1/

		t zzclr151
		:zzset151
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_[rR]\\([^~]*~\\)\\\\$/<"\\\\'newline'" not allowed (use "\\\\n" \\\\Ninstead)>\\\\_\\\\r\\1/

		:zzclr151
#--------------------------------------------------
s/_[rR]\([^~]*~\)\\$/<"\\'newline'" not allowed (use "\\n" \
instead)>\\_\\r\1/
# any other character
		t zzset152
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_[rR]\\([^~]*~\\)\\(.\\)/\\2_?r\\1/

		t zzclr152
		:zzset152
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_[rR]\\([^~]*~\\)\\(.\\)/\\2_?r\\1/

		:zzclr152
#--------------------------------------------------
s/_[rR]\([^~]*~\)\(.\)/\2_?r\1/
		t zzset153
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_?/_/

		t zzclr153
		:zzset153
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_?/_/

		:zzclr153
#--------------------------------------------------
s/_?/_/
		t zzset154
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:/_[rRB]/ t reloop

		t zzclr154
		:zzset154
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:/_[rRB]/ t reloop

		:zzclr154
#--------------------------------------------------
/_[rRB]/ t reloop
		i\
COMM:}
#--------------------------------------------------
}
# force re-cycle
		i\
COMM:s/_?/_/
#--------------------------------------------------
s/_?/_/
		t zzset155
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:t loop

		t zzclr155
		:zzset155
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:t loop

		:zzclr155
#--------------------------------------------------
t loop
		i\
COMM:s/\\n//g
#--------------------------------------------------
s/\n//g
# end of line not reached by the parser?
		t zzset156
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_\\([^~]*~\\)\\(..*\\)/<syntax error (rest of line ignored)>\\2_C~/

		t zzclr156
		:zzset156
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/_\\([^~]*~\\)\\(..*\\)/<syntax error (rest of line ignored)>\\2_C~/

		:zzclr156
#--------------------------------------------------
s/_\([^~]*~\)\(..*\)/<syntax error (rest of line ignored)>\2_C~/
# update state in the hold buffer, removing any leading \ in the state
# (these are used to control when a command can extend to the next line) 
		t zzset157
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

		t zzclr157
		:zzset157
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

		:zzclr157
#--------------------------------------------------
G
		t zzset158
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/\\([^_]*\\)_\\\\*\\(.*\\)\\(\\n\\)[^~]*~\\(.*\\)/\\2\\4\\3\\1/

		t zzclr158
		:zzset158
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/\\([^_]*\\)_\\\\*\\(.*\\)\\(\\n\\)[^~]*~\\(.*\\)/\\2\\4\\3\\1/

		:zzclr158
#--------------------------------------------------
s/\([^_]*\)_\\*\(.*\)\(\n\)[^~]*~\(.*\)/\2\4\3\1/
		t zzset159
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:h

		t zzclr159
		:zzset159
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:h

		:zzclr159
#--------------------------------------------------
h
		t zzset160
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:/</ !b noerror

		t zzclr160
		:zzset160
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:/</ !b noerror

		:zzclr160
#--------------------------------------------------
/</ !b noerror
		i\
COMM::error
#--------------------------------------------------
:error
		i\
COMM:s/[^~]*~\\([0-9]*\\)[^<]*<\\([^>]*\\).*/line \\1: \\2/
#--------------------------------------------------
s/[^~]*~\([0-9]*\)[^<]*<\([^>]*\).*/line \1: \2/
		t zzset161
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/'\\([^']*\\)'/<\\1>/g

		t zzclr161
		:zzset161
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/'\\([^']*\\)'/<\\1>/g

		:zzclr161
#--------------------------------------------------
s/'\([^']*\)'/<\1>/g
		t zzset162
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:p

		t zzclr162
		:zzset162
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:p

		:zzclr162
#--------------------------------------------------
p
		t zzset163
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

		t zzclr163
		:zzset163
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

		:zzclr163
#--------------------------------------------------
g
		t zzset164
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/.*\\n//

		t zzclr164
		:zzset164
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/.*\\n//

		:zzclr164
#--------------------------------------------------
s/.*\n//
		t zzset165
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/<[^>]*>//g

		t zzclr165
		:zzset165
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/<[^>]*>//g

		:zzclr165
#--------------------------------------------------
s/<[^>]*>//g
		t zzset166
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/'./&'a_b<c>d~e,/g

		t zzclr166
		:zzset166
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/'./&'a_b<c>d~e,/g

		:zzclr166
#--------------------------------------------------
s/'./&'a_b<c>d~e,/g
		t zzset167
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/'\\(.\\)[^,]*\\([^,]\\)\\1[^,]*,/\\2/g

		t zzclr167
		:zzset167
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/'\\(.\\)[^,]*\\([^,]\\)\\1[^,]*,/\\2/g

		:zzclr167
#--------------------------------------------------
s/'\(.\)[^,]*\([^,]\)\1[^,]*,/\2/g
		t zzset168
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:p

		t zzclr168
		:zzset168
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:p

		:zzclr168
#--------------------------------------------------
p
		t zzset169
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

		t zzclr169
		:zzset169
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

		:zzclr169
#--------------------------------------------------
g
		t zzset170
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/.*\\n//

		t zzclr170
		:zzset170
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/.*\\n//

		:zzclr170
#--------------------------------------------------
s/.*\n//
		t zzset171
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/\\([^<]*\\)<.*/>\\1/

		t zzclr171
		:zzset171
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/\\([^<]*\\)<.*/>\\1/

		:zzclr171
#--------------------------------------------------
s/\([^<]*\)<.*/>\1/
		t zzset172
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM::tospace

		t zzclr172
		:zzset172
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM::tospace

		:zzclr172
#--------------------------------------------------
:tospace
		i\
COMM:s/>'*[^	]/ >/
#--------------------------------------------------
s/>'*[^	]/ >/
		t zzset173
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/>\\(		*\\)/\\1>/

		t zzclr173
		:zzset173
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/>\\(		*\\)/\\1>/

		:zzclr173
#--------------------------------------------------
s/>\(		*\)/\1>/
		t zzset174
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/>$/^/p

		t zzclr174
		:zzset174
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/>$/^/p

		:zzclr174
#--------------------------------------------------
s/>$/^/p
		t zzset175
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:t tospace

		t zzclr175
		:zzset175
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:t tospace

		:zzclr175
#--------------------------------------------------
t tospace
		i\
COMM:g
#--------------------------------------------------
g
# remove first issue and increment issue count
		t zzset176
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/<[^>]*>//

		t zzclr176
		:zzset176
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/<[^>]*>//

		:zzclr176
#--------------------------------------------------
s/<[^>]*>//
		t zzset177
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/\\(.\\)\\(9*\\)\\(+[0-8]*\\1\\([0-9]0*\\)[0-9]*\\2\\(0*\\).*\\n\\)/\\4\\5\\3/

		t zzclr177
		:zzset177
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/\\(.\\)\\(9*\\)\\(+[0-8]*\\1\\([0-9]0*\\)[0-9]*\\2\\(0*\\).*\\n\\)/\\4\\5\\3/

		:zzclr177
#--------------------------------------------------
s/\(.\)\(9*\)\(+[0-8]*\1\([0-9]0*\)[0-9]*\2\(0*\).*\n\)/\4\5\3/
		t zzset178
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:h

		t zzclr178
		:zzset178
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:h

		:zzclr178
#--------------------------------------------------
h
		t zzset179
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:/</ b error

		t zzclr179
		:zzset179
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:/</ b error

		:zzclr179
#--------------------------------------------------
/</ b error
		i\
COMM::noerror
#--------------------------------------------------
:noerror
# remove the line from the future hold buffer
		i\
COMM:s/\\n.*//
#--------------------------------------------------
s/\n.*//
		t zzset180
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:h

		t zzclr180
		:zzset180
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:h

		:zzclr180
#--------------------------------------------------
h
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:$ !d
#--------------------------------------------------
$ !d
# if the issue count is not null, report it.
		t zzset181
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:/[^~]*~[^,]*,\\([1-9][0-9]*\\).*/ {

		t zzclr181
		:zzset181
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:/[^~]*~[^,]*,\\([1-9][0-9]*\\).*/ {

		:zzclr181
#--------------------------------------------------
/[^~]*~[^,]*,\([1-9][0-9]*\).*/ {
		i\
COMM:s//\\1 issues reported./
		/[^~]*~[^,]*,\([1-9][0-9]*\).*/y/!/!/
#--------------------------------------------------
s//\1 issues reported./
		t zzset182
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/^\\(1 issue\\)s/\\1/

		t zzclr182
		:zzset182
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/^\\(1 issue\\)s/\\1/

		:zzclr182
#--------------------------------------------------
s/^\(1 issue\)s/\1/
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:q
#--------------------------------------------------
q
		t zzset183
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:}

		t zzclr183
		:zzset183
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:}

		:zzclr183
#--------------------------------------------------
}
		i\
COMM:d
#--------------------------------------------------
d
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x

# Debugged SED script generated by sedsed-1.1-dev (http://aurelio.net/projects/sedsed/)
