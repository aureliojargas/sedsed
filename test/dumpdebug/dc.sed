#n
#  dc.sed - an arbitrary precision RPN calculator
#  Created by Greg Ubben <gsu@romulus.ncsc.mil> early 1995, late 1996
#
#  Dedicated to MAC's memory of the IBM 1620 ("CADET") computer.
#  @(#)GSU dc.sed 1.0 27-Feb-1997 [non-explanatory]
#
#  Examples:
#	sqrt(2) to 10 digits:	echo "10k 2vp" | dc.sed
#	20 factorial:		echo "[d1-d1<!*]s! 20l!xp" | dc.sed
#	sin(ln(7)):		echo "s(l(7))" | bc -c /usr/lib/lib.b | dc.sed
#	hex to base 60:		echo "60o16i 6B407.CAFE p" | dc.sed
#
#  To debug or analyze, give the dc Y command as input or add it to
#  embedded dc routines, or add the sed p command to the beginning of
#  the main loop or at various points in the low-level sed routines.
#  If you need to allow [|~] characters in the input, filter this
#  script through "tr '|~' '\36\37'" first.
#
#  Not implemented:	! \
#  But implemented:	K Y t # !< !> != fractional-bases
#  SunOS limits:	199/199 commands (though could pack in 10-20 more)
#  Limitations:		scale <= 999; |obase| >= 1; input digits in [0..F]
#  Completed:		1am Feb 4, 1997
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
COMM:s/^/|P|K0|I10|O10|?~/

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
COMM:s/^/|P|K0|I10|O10|?~/

		:zzclr001
#--------------------------------------------------
s/^/|P|K0|I10|O10|?~/
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
COMM::next

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
COMM::next

		:zzclr002
#--------------------------------------------------
:next
		i\
COMM:s/|?./|?/
#--------------------------------------------------
s/|?./|?/
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
COMM:s/|?#[	 -}]*/|?/

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
COMM:s/|?#[	 -}]*/|?/

		:zzclr003
#--------------------------------------------------
s/|?#[	 -}]*/|?/
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
COMM:/|?!*[lLsS;:<>=]\\{0,1\\}$/ N

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
COMM:/|?!*[lLsS;:<>=]\\{0,1\\}$/ N

		:zzclr004
#--------------------------------------------------
/|?!*[lLsS;:<>=]\{0,1\}$/ N
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
COMM:/|?!*[-+*/%^<>=]/ b binop

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
COMM:/|?!*[-+*/%^<>=]/ b binop

		:zzclr005
#--------------------------------------------------
/|?!*[-+*/%^<>=]/ b binop
		i\
COMM:/^|.*|?[dpPfQXZvxkiosStT;:]/ b binop
#--------------------------------------------------
/^|.*|?[dpPfQXZvxkiosStT;:]/ b binop
		i\
COMM:/|?[_0-9A-F.]/ b number
#--------------------------------------------------
/|?[_0-9A-F.]/ b number
		i\
COMM:/|?\\[/ b string
#--------------------------------------------------
/|?\[/ b string
		i\
COMM:/|?l/ b load
#--------------------------------------------------
/|?l/ b load
		i\
COMM:/|?L/ b Load
#--------------------------------------------------
/|?L/ b Load
		i\
COMM:/|?[sS]/ b save
#--------------------------------------------------
/|?[sS]/ b save
		i\
COMM:/|?c/ s/[^|]*//
#--------------------------------------------------
/|?c/ s/[^|]*//
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
COMM:/|?d/ s/[^~]*~/&&/

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
COMM:/|?d/ s/[^~]*~/&&/

		:zzclr006
#--------------------------------------------------
/|?d/ s/[^~]*~/&&/
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
COMM:/|?f/ s//&[pSbz0<aLb]dSaxsaLa/

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
COMM:/|?f/ s//&[pSbz0<aLb]dSaxsaLa/

		:zzclr007
		/|?f/y/!/!/
#--------------------------------------------------
/|?f/ s//&[pSbz0<aLb]dSaxsaLa/
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
COMM:/|?x/ s/\\([^~]*~\\)\\(.*|?x\\)~*/\\2\\1/

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
COMM:/|?x/ s/\\([^~]*~\\)\\(.*|?x\\)~*/\\2\\1/

		:zzclr008
#--------------------------------------------------
/|?x/ s/\([^~]*~\)\(.*|?x\)~*/\2\1/
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
COMM:/|?[KIO]/ s/.*|\\([KIO]\\)\\([^|]*\\).*|?\\1/\\2~&/

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
COMM:/|?[KIO]/ s/.*|\\([KIO]\\)\\([^|]*\\).*|?\\1/\\2~&/

		:zzclr009
#--------------------------------------------------
/|?[KIO]/ s/.*|\([KIO]\)\([^|]*\).*|?\1/\2~&/
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
COMM:/|?T/ s/\\.*0*~/~/

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
COMM:/|?T/ s/\\.*0*~/~/

		:zzclr010
#--------------------------------------------------
/|?T/ s/\.*0*~/~/
#  a slow, non-stackable array implementation in dc, just for completeness
#  A fast, stackable, associative array implementation could be done in sed
#  (format: {key}value{key}value...), but would be longer, like load & save.
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
COMM:/|?;/ s/|?;\\([^{}]\\)/|?~[s}s{L{s}q]S}[S}l\\1L}1-d0>}s\\1L\\1l{xS\\1]dS{xL}/

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
COMM:/|?;/ s/|?;\\([^{}]\\)/|?~[s}s{L{s}q]S}[S}l\\1L}1-d0>}s\\1L\\1l{xS\\1]dS{xL}/

		:zzclr011
#--------------------------------------------------
/|?;/ s/|?;\([^{}]\)/|?~[s}s{L{s}q]S}[S}l\1L}1-d0>}s\1L\1l{xS\1]dS{xL}/
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
COMM:/|?:/ s/|?:\\([^{}]\\)/|?~[s}L{s}L{s}L}s\\1q]S}S}S{[L}1-d0>}S}l\\1s\\1L\\1l{xS\\1]dS{x/

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
COMM:/|?:/ s/|?:\\([^{}]\\)/|?~[s}L{s}L{s}L}s\\1q]S}S}S{[L}1-d0>}S}l\\1s\\1L\\1l{xS\\1]dS{x/

		:zzclr012
#--------------------------------------------------
/|?:/ s/|?:\([^{}]\)/|?~[s}L{s}L{s}L}s\1q]S}S}S{[L}1-d0>}S}l\1s\1L\1l{xS\1]dS{x/
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
COMM:/|?[ ~	cdfxKIOT]/ b next

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
COMM:/|?[ ~	cdfxKIOT]/ b next

		:zzclr013
#--------------------------------------------------
/|?[ ~	cdfxKIOT]/ b next
		i\
COMM:/|?\\n/ b next
#--------------------------------------------------
/|?\n/ b next
		i\
COMM:/|?[pP]/ b print
#--------------------------------------------------
/|?[pP]/ b print
		i\
COMM:/|?k/ s/^\\([0-9]\\{1,3\\}\\)\\([.~].*|K\\)[^|]*/\\2\\1/
#--------------------------------------------------
/|?k/ s/^\([0-9]\{1,3\}\)\([.~].*|K\)[^|]*/\2\1/
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
COMM:/|?i/ s/^\\(-\\{0,1\\}[0-9]*\\.\\{0,1\\}[0-9]\\{1,\\}\\)\\(~.*|I\\)[^|]*/\\2\\1/

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
COMM:/|?i/ s/^\\(-\\{0,1\\}[0-9]*\\.\\{0,1\\}[0-9]\\{1,\\}\\)\\(~.*|I\\)[^|]*/\\2\\1/

		:zzclr014
#--------------------------------------------------
/|?i/ s/^\(-\{0,1\}[0-9]*\.\{0,1\}[0-9]\{1,\}\)\(~.*|I\)[^|]*/\2\1/
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
COMM:/|?o/ s/^\\(-\\{0,1\\}[1-9][0-9]*\\.\\{0,1\\}[0-9]*\\)\\(~.*|O\\)[^|]*/\\2\\1/

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
COMM:/|?o/ s/^\\(-\\{0,1\\}[1-9][0-9]*\\.\\{0,1\\}[0-9]*\\)\\(~.*|O\\)[^|]*/\\2\\1/

		:zzclr015
#--------------------------------------------------
/|?o/ s/^\(-\{0,1\}[1-9][0-9]*\.\{0,1\}[0-9]*\)\(~.*|O\)[^|]*/\2\1/
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
COMM:/|?[kio]/ b pop

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
COMM:/|?[kio]/ b pop

		:zzclr016
#--------------------------------------------------
/|?[kio]/ b pop
		i\
COMM:/|?t/ b trunc
#--------------------------------------------------
/|?t/ b trunc
		i\
COMM:/|??/ b input
#--------------------------------------------------
/|??/ b input
		i\
COMM:/|?Q/ b break
#--------------------------------------------------
/|?Q/ b break
		i\
COMM:/|?q/ b quit
#--------------------------------------------------
/|?q/ b quit
		i\
COMM:h
#--------------------------------------------------
h
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
COMM:/|?[XZz]/ b count

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
COMM:/|?[XZz]/ b count

		:zzclr017
#--------------------------------------------------
/|?[XZz]/ b count
		i\
COMM:/|?v/ b sqrt
#--------------------------------------------------
/|?v/ b sqrt
		i\
COMM:s/.*|?\\([^Y]\\).*/\\1 is unimplemented/
#--------------------------------------------------
s/.*|?\([^Y]\).*/\1 is unimplemented/
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
COMM:s/\\n/\\\\n/g

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
COMM:s/\\n/\\\\n/g

		:zzclr018
#--------------------------------------------------
s/\n/\\n/g
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
COMM:l

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
COMM:l

		:zzclr019
#--------------------------------------------------
l
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
COMM:g

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
COMM:g

		:zzclr020
#--------------------------------------------------
g
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
COMM:b next

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
COMM:b next

		:zzclr021
#--------------------------------------------------
b next
		i\
COMM::print
#--------------------------------------------------
:print
		i\
COMM:/^-\\{0,1\\}[0-9]*\\.\\{0,1\\}[0-9]\\{1,\\}~.*|?p/ !b Print
#--------------------------------------------------
/^-\{0,1\}[0-9]*\.\{0,1\}[0-9]\{1,\}~.*|?p/ !b Print
		i\
COMM:/|O10|/ b Print
#--------------------------------------------------
/|O10|/ b Print
#  Print a number in a non-decimal output base.  Uses registers a,b,c,d.
#  Handles fractional output bases (O<-1 or O>=1), unlike other dc's.
#  Converts the fraction correctly on negative output bases, unlike
#  UNIX dc.  Also scales the fraction more accurately than UNIX dc.
#
		i\
COMM:s,|?p,&KSa0kd[[-]Psa0la-]Sad0>a[0P]sad0=a[A*2+]saOtd0>a1-ZSd[[[[ ]P]sclb1\\\\N!=cSbLdlbtZ[[[-]P0lb-sb]sclb0>c1+]sclb0!<c[0P1+dld>c]scdld>cscSdLbP]q]Sb\\\\N[t[1P1-d0<c]scd0<c]ScO_1>bO1!<cO[16]<bOX0<b[[q]sc[dSbdA>c[A]sbdA=c[B]sbd\\\\NB=c[C]sbdC=c[D]sbdD=c[E]sbdE=c[F]sb]xscLbP]~Sd[dtdZOZ+k1O/Tdsb[.5]*[.1]O\\\\NX^*dZkdXK-1+ktsc0kdSb-[Lbdlb*lc+tdSbO*-lb0!=aldx]dsaxLbsb]sad1!>a[[.]POX\\\\N+sb1[SbO*dtdldx-LbO*dZlb!<a]dsax]sadXd0<asbsasaLasbLbscLcsdLdsdLdLak[]pP,
#--------------------------------------------------
s,|?p,&KSa0kd[[-]Psa0la-]Sad0>a[0P]sad0=a[A*2+]saOtd0>a1-ZSd[[[[ ]P]sclb1\
!=cSbLdlbtZ[[[-]P0lb-sb]sclb0>c1+]sclb0!<c[0P1+dld>c]scdld>cscSdLbP]q]Sb\
[t[1P1-d0<c]scd0<c]ScO_1>bO1!<cO[16]<bOX0<b[[q]sc[dSbdA>c[A]sbdA=c[B]sbd\
B=c[C]sbdC=c[D]sbdD=c[E]sbdE=c[F]sb]xscLbP]~Sd[dtdZOZ+k1O/Tdsb[.5]*[.1]O\
X^*dZkdXK-1+ktsc0kdSb-[Lbdlb*lc+tdSbO*-lb0!=aldx]dsaxLbsb]sad1!>a[[.]POX\
+sb1[SbO*dtdldx-LbO*dZlb!<a]dsax]sadXd0<asbsasaLasbLbscLcsdLdsdLdLak[]pP,
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
COMM:b next

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
COMM:b next

		:zzclr022
#--------------------------------------------------
b next
		i\
COMM::Print
#--------------------------------------------------
:Print
		i\
COMM:/|?p/ s/[^~]*/&\\\\N~&/
#--------------------------------------------------
/|?p/ s/[^~]*/&\
~&/
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
COMM:s/\\(.*|P\\)\\([^|]*\\)/\\\\N\\2\\1/

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
COMM:s/\\(.*|P\\)\\([^|]*\\)/\\\\N\\2\\1/

		:zzclr023
#--------------------------------------------------
s/\(.*|P\)\([^|]*\)/\
\2\1/
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
COMM:s/\\([^~]*\\)\\n\\([^~]*\\)\\(.*|P\\)/\\1\\3\\2/

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
COMM:s/\\([^~]*\\)\\n\\([^~]*\\)\\(.*|P\\)/\\1\\3\\2/

		:zzclr024
#--------------------------------------------------
s/\([^~]*\)\n\([^~]*\)\(.*|P\)/\1\3\2/
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
COMM:h

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
COMM:h

		:zzclr025
#--------------------------------------------------
h
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
COMM:s/~.*//

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
COMM:s/~.*//

		:zzclr026
#--------------------------------------------------
s/~.*//
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
COMM:/./ {

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
COMM:/./ {

		:zzclr027
#--------------------------------------------------
/./ {
		i\
COMM:s/.//
#--------------------------------------------------
s/.//
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
COMM:p

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
COMM:p

		:zzclr028
#--------------------------------------------------
p
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
COMM:}

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
COMM:}

		:zzclr029
#--------------------------------------------------
}
#  Just s/.//p would work if we knew we were running under the -n option.
#  Using l vs p would kind of do \ continuations, but would break strings.
		i\
COMM:g
#--------------------------------------------------
g
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
COMM::pop

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
COMM::pop

		:zzclr030
#--------------------------------------------------
:pop
		i\
COMM:s/[^~]*~//
#--------------------------------------------------
s/[^~]*~//
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
COMM:b next

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
COMM:b next

		:zzclr031
#--------------------------------------------------
b next
		i\
COMM::load
#--------------------------------------------------
:load
		i\
COMM:s/\\(.*|?.\\)\\(.\\)/\\20~\\1/
#--------------------------------------------------
s/\(.*|?.\)\(.\)/\20~\1/
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
COMM:s/^\\(.\\)0\\(.*|r\\1\\([^~|]*\\)~\\)/\\1\\3\\2/

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
COMM:s/^\\(.\\)0\\(.*|r\\1\\([^~|]*\\)~\\)/\\1\\3\\2/

		:zzclr032
#--------------------------------------------------
s/^\(.\)0\(.*|r\1\([^~|]*\)~\)/\1\3\2/
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
COMM:s/.//

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
COMM:s/.//

		:zzclr033
#--------------------------------------------------
s/.//
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
COMM:b next

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
COMM:b next

		:zzclr034
#--------------------------------------------------
b next
		i\
COMM::Load
#--------------------------------------------------
:Load
		i\
COMM:s/\\(.*|?.\\)\\(.\\)/\\2\\1/
#--------------------------------------------------
s/\(.*|?.\)\(.\)/\2\1/
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
COMM:s/^\\(.\\)\\(.*|r\\1\\)\\([^~|]*~\\)/|\\3\\2/

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
COMM:s/^\\(.\\)\\(.*|r\\1\\)\\([^~|]*~\\)/|\\3\\2/

		:zzclr035
#--------------------------------------------------
s/^\(.\)\(.*|r\1\)\([^~|]*~\)/|\3\2/
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
COMM:/^|/ !i\\\\Nregister empty

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
COMM:/^|/ !i\\\\Nregister empty

		:zzclr036
#--------------------------------------------------
/^|/ !i\
register empty
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
COMM:s/.//

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
COMM:s/.//

		:zzclr037
#--------------------------------------------------
s/.//
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
COMM:b next

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
COMM:b next

		:zzclr038
#--------------------------------------------------
b next
		i\
COMM::save
#--------------------------------------------------
:save
		i\
COMM:s/\\(.*|?.\\)\\(.\\)/\\2\\1/
#--------------------------------------------------
s/\(.*|?.\)\(.\)/\2\1/
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
COMM:/^\\(.\\).*|r\\1/ !s/\\(.\\).*|/&r\\1|/

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
COMM:/^\\(.\\).*|r\\1/ !s/\\(.\\).*|/&r\\1|/

		:zzclr039
#--------------------------------------------------
/^\(.\).*|r\1/ !s/\(.\).*|/&r\1|/
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
COMM:/|?S/ s/\\(.\\).*|r\\1/&~/

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
COMM:/|?S/ s/\\(.\\).*|r\\1/&~/

		:zzclr040
#--------------------------------------------------
/|?S/ s/\(.\).*|r\1/&~/
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
COMM:s/\\(.\\)\\([^~]*~\\)\\(.*|r\\1\\)[^~|]*~\\{0,1\\}/\\3\\2/

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
COMM:s/\\(.\\)\\([^~]*~\\)\\(.*|r\\1\\)[^~|]*~\\{0,1\\}/\\3\\2/

		:zzclr041
#--------------------------------------------------
s/\(.\)\([^~]*~\)\(.*|r\1\)[^~|]*~\{0,1\}/\3\2/
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
COMM:b next

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
COMM:b next

		:zzclr042
#--------------------------------------------------
b next
		i\
COMM::quit
#--------------------------------------------------
:quit
		i\
COMM:t quit
#--------------------------------------------------
t quit
		i\
COMM:s/|?[^~]*~[^~]*~/|?q/
#--------------------------------------------------
s/|?[^~]*~[^~]*~/|?q/
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
COMM:t next

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
COMM:t next

		:zzclr043
#--------------------------------------------------
t next
#  Really should be using the -n option to avoid printing a final newline.
		i\
COMM:s/.*|P\\([^|]*\\).*/\\1/
#--------------------------------------------------
s/.*|P\([^|]*\).*/\1/
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
COMM::break

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
COMM::break

		:zzclr044
#--------------------------------------------------
:break
		i\
COMM:s/[0-9]*/&;987654321009;/
#--------------------------------------------------
s/[0-9]*/&;987654321009;/
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
COMM::break1

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
COMM::break1

		:zzclr045
#--------------------------------------------------
:break1
		i\
COMM:s/^\\([^;]*\\)\\([1-9]\\)\\(0*\\)\\([^1]*\\2\\(.\\)[^;]*\\3\\(9*\\).*|?.\\)[^~]*~/\\1\\5\\6\\4/
#--------------------------------------------------
s/^\([^;]*\)\([1-9]\)\(0*\)\([^1]*\2\(.\)[^;]*\3\(9*\).*|?.\)[^~]*~/\1\5\6\4/
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
COMM:t break1

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
COMM:t break1

		:zzclr046
#--------------------------------------------------
t break1
		i\
COMM:b pop
#--------------------------------------------------
b pop
		i\
COMM::input
#--------------------------------------------------
:input
		i\
COMM:N
#--------------------------------------------------
N
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
COMM:s/|??\\(.*\\)\\(\\n.*\\)/|?\\2~\\1/

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
COMM:s/|??\\(.*\\)\\(\\n.*\\)/|?\\2~\\1/

		:zzclr047
#--------------------------------------------------
s/|??\(.*\)\(\n.*\)/|?\2~\1/
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
COMM:b next

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
COMM:b next

		:zzclr048
#--------------------------------------------------
b next
		i\
COMM::count
#--------------------------------------------------
:count
		i\
COMM:/|?Z/ s/~.*//
#--------------------------------------------------
/|?Z/ s/~.*//
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
COMM:/^-\\{0,1\\}[0-9]*\\.\\{0,1\\}[0-9]\\{1,\\}$/ s/[-.0]*\\([^.]*\\)\\.*/\\1/

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
COMM:/^-\\{0,1\\}[0-9]*\\.\\{0,1\\}[0-9]\\{1,\\}$/ s/[-.0]*\\([^.]*\\)\\.*/\\1/

		:zzclr049
#--------------------------------------------------
/^-\{0,1\}[0-9]*\.\{0,1\}[0-9]\{1,\}$/ s/[-.0]*\([^.]*\)\.*/\1/
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
COMM:/|?X/ s/-*[0-9A-F]*\\.*\\([0-9A-F]*\\).*/\\1/

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
COMM:/|?X/ s/-*[0-9A-F]*\\.*\\([0-9A-F]*\\).*/\\1/

		:zzclr050
#--------------------------------------------------
/|?X/ s/-*[0-9A-F]*\.*\([0-9A-F]*\).*/\1/
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
COMM:s/|.*//

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
COMM:s/|.*//

		:zzclr051
#--------------------------------------------------
s/|.*//
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
COMM:/~/ s/[^~]//g

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
COMM:/~/ s/[^~]//g

		:zzclr052
#--------------------------------------------------
/~/ s/[^~]//g
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
COMM:s/./a/g

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
COMM:s/./a/g

		:zzclr053
#--------------------------------------------------
s/./a/g
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
COMM::count1

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
COMM::count1

		:zzclr054
#--------------------------------------------------
:count1
		i\
COMM:s/a\\{10\\}/b/g
#--------------------------------------------------
s/a\{10\}/b/g
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
COMM:s/b*a*/&a9876543210;/

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
COMM:s/b*a*/&a9876543210;/

		:zzclr055
#--------------------------------------------------
s/b*a*/&a9876543210;/
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
COMM:s/a.\\{9\\}\\(.\\).*;/\\1/

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
COMM:s/a.\\{9\\}\\(.\\).*;/\\1/

		:zzclr056
#--------------------------------------------------
s/a.\{9\}\(.\).*;/\1/
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
COMM:y/b/a/

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
COMM:y/b/a/

		:zzclr057
#--------------------------------------------------
y/b/a/
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
COMM:/a/ b count1

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
COMM:/a/ b count1

		:zzclr058
#--------------------------------------------------
/a/ b count1
		i\
COMM:G
#--------------------------------------------------
G
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
COMM:/|?z/ s/\\n/&~/

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
COMM:/|?z/ s/\\n/&~/

		:zzclr059
#--------------------------------------------------
/|?z/ s/\n/&~/
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
COMM:s/\\n[^~]*//

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
COMM:s/\\n[^~]*//

		:zzclr060
#--------------------------------------------------
s/\n[^~]*//
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
COMM:b next

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
COMM:b next

		:zzclr061
#--------------------------------------------------
b next
		i\
COMM::trunc
#--------------------------------------------------
:trunc
#  for efficiency, doesn't pad with 0s, so 10k 2 5/ returns just .40
#  The X* here and in a couple other places works around a SunOS 4.x sed bug.
		i\
COMM:s/\\([^.~]*\\.*\\)\\(.*|K\\([^|]*\\)\\)/\\3;9876543210009909:\\1,\\2/
#--------------------------------------------------
s/\([^.~]*\.*\)\(.*|K\([^|]*\)\)/\3;9876543210009909:\1,\2/
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
COMM::trunc1

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
COMM::trunc1

		:zzclr062
#--------------------------------------------------
:trunc1
		i\
COMM:s/^\\([^;]*\\)\\([1-9]\\)\\(0*\\)\\([^1]*\\2\\(.\\)[^:]*X*\\3\\(9*\\)[^,]*\\),\\([0-9]\\)/\\1\\5\\6\\4\\7,/
#--------------------------------------------------
s/^\([^;]*\)\([1-9]\)\(0*\)\([^1]*\2\(.\)[^:]*X*\3\(9*\)[^,]*\),\([0-9]\)/\1\5\6\4\7,/
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
COMM:t trunc1

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
COMM:t trunc1

		:zzclr063
#--------------------------------------------------
t trunc1
		i\
COMM:s/[^:]*:\\([^,]*\\)[^~]*/\\1/
#--------------------------------------------------
s/[^:]*:\([^,]*\)[^~]*/\1/
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
COMM:b normal

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
COMM:b normal

		:zzclr064
#--------------------------------------------------
b normal
		i\
COMM::number
#--------------------------------------------------
:number
		i\
COMM:s/\\(.*|?\\)\\(_\\{0,1\\}[0-9A-F]*\\.\\{0,1\\}[0-9A-F]*\\)/\\2~\\1~/
#--------------------------------------------------
s/\(.*|?\)\(_\{0,1\}[0-9A-F]*\.\{0,1\}[0-9A-F]*\)/\2~\1~/
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
COMM:s/^_/-/

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
COMM:s/^_/-/

		:zzclr065
#--------------------------------------------------
s/^_/-/
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
COMM:/^[^A-F~]*~.*|I10|/ b normal

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
COMM:/^[^A-F~]*~.*|I10|/ b normal

		:zzclr066
#--------------------------------------------------
/^[^A-F~]*~.*|I10|/ b normal
		i\
COMM:/^[-0.]*~/ b normal
#--------------------------------------------------
/^[-0.]*~/ b normal
		i\
COMM:s:\\([^.~]*\\)\\.*\\([^~]*\\):[Ilb^lbk/,\\1\\2~0A1B2C3D4E5F1=11223344556677889900;.\\2:
#--------------------------------------------------
s:\([^.~]*\)\.*\([^~]*\):[Ilb^lbk/,\1\2~0A1B2C3D4E5F1=11223344556677889900;.\2:
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
COMM::digit

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
COMM::digit

		:zzclr067
#--------------------------------------------------
:digit
		i\
COMM:s/^\\([^,]*\\),\\(-*\\)\\([0-F]\\)\\([^;]*\\(.\\)\\3[^1;]*\\(1*\\)\\)/I*+\\1\\2\\6\\5~,\\2\\4/
#--------------------------------------------------
s/^\([^,]*\),\(-*\)\([0-F]\)\([^;]*\(.\)\3[^1;]*\(1*\)\)/I*+\1\2\6\5~,\2\4/
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
COMM:t digit

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
COMM:t digit

		:zzclr068
#--------------------------------------------------
t digit
		i\
COMM:s:...\\([^/]*.\\)\\([^,]*\\)[^.]*\\(.*|?.\\):\\2\\3KSb[99]k\\1]SaSaXSbLalb0<aLakLbktLbk:
#--------------------------------------------------
s:...\([^/]*.\)\([^,]*\)[^.]*\(.*|?.\):\2\3KSb[99]k\1]SaSaXSbLalb0<aLakLbktLbk:
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
COMM:b next

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
COMM:b next

		:zzclr069
#--------------------------------------------------
b next
		i\
COMM::string
#--------------------------------------------------
:string
		i\
COMM:/|?[^]]*$/ N
#--------------------------------------------------
/|?[^]]*$/ N
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
COMM:s/\\(|?[^]]*\\)\\[\\([^]]*\\)]/\\1|{\\2|}/

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
COMM:s/\\(|?[^]]*\\)\\[\\([^]]*\\)]/\\1|{\\2|}/

		:zzclr070
#--------------------------------------------------
s/\(|?[^]]*\)\[\([^]]*\)]/\1|{\2|}/
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
COMM:/|?\\[/ b string

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
COMM:/|?\\[/ b string

		:zzclr071
#--------------------------------------------------
/|?\[/ b string
		i\
COMM:s/\\(.*|?\\)|{\\(.*\\)|}/\\2~\\1[/
#--------------------------------------------------
s/\(.*|?\)|{\(.*\)|}/\2~\1[/
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
COMM:s/|{/[/g

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
COMM:s/|{/[/g

		:zzclr072
#--------------------------------------------------
s/|{/[/g
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
COMM:s/|}/]/g

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
COMM:s/|}/]/g

		:zzclr073
#--------------------------------------------------
s/|}/]/g
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
COMM:b next

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
COMM:b next

		:zzclr074
#--------------------------------------------------
b next
		i\
COMM::binop
#--------------------------------------------------
:binop
		i\
COMM:/^[^~|]*~[^|]/ !i\\\\Nstack empty
#--------------------------------------------------
/^[^~|]*~[^|]/ !i\
stack empty
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
COMM:// !b next

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
COMM:// !b next

		:zzclr075
		/^[^~|]*~[^|]/y/!/!/
#--------------------------------------------------
// !b next
		i\
COMM:/^-\\{0,1\\}[0-9]*\\.\\{0,1\\}[0-9]\\{1,\\}~/ !s/[^~]*\\(.*|?!*[^!=<>]\\)/0\\1/
#--------------------------------------------------
/^-\{0,1\}[0-9]*\.\{0,1\}[0-9]\{1,\}~/ !s/[^~]*\(.*|?!*[^!=<>]\)/0\1/
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
COMM:/^[^~]*~-\\{0,1\\}[0-9]*\\.\\{0,1\\}[0-9]\\{1,\\}~/ !s/~[^~]*\\(.*|?!*[^!=<>]\\)/~0\\1/

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
COMM:/^[^~]*~-\\{0,1\\}[0-9]*\\.\\{0,1\\}[0-9]\\{1,\\}~/ !s/~[^~]*\\(.*|?!*[^!=<>]\\)/~0\\1/

		:zzclr076
#--------------------------------------------------
/^[^~]*~-\{0,1\}[0-9]*\.\{0,1\}[0-9]\{1,\}~/ !s/~[^~]*\(.*|?!*[^!=<>]\)/~0\1/
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
COMM:h

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
COMM:h

		:zzclr077
#--------------------------------------------------
h
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
COMM:/|?\\*/ b mul

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
COMM:/|?\\*/ b mul

		:zzclr078
#--------------------------------------------------
/|?\*/ b mul
		i\
COMM:/|?\\// b div
#--------------------------------------------------
/|?\// b div
		i\
COMM:/|?%/ b rem
#--------------------------------------------------
/|?%/ b rem
		i\
COMM:/|?^/ b exp
#--------------------------------------------------
/|?^/ b exp
		i\
COMM:/|?[+-]/ s/^\\(-*\\)\\([^~]*~\\)\\(-*\\)\\([^~]*~\\).*|?\\(-\\{0,1\\}\\).*/\\2\\4s\\3o\\1\\3\\5/
#--------------------------------------------------
/|?[+-]/ s/^\(-*\)\([^~]*~\)\(-*\)\([^~]*~\).*|?\(-\{0,1\}\).*/\2\4s\3o\1\3\5/
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
COMM:s/\\([^.~]*\\)\\([^~]*~[^.~]*\\)\\(.*\\)/<\\1,\\2,\\3|=-~.0,123456789<></

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
COMM:s/\\([^.~]*\\)\\([^~]*~[^.~]*\\)\\(.*\\)/<\\1,\\2,\\3|=-~.0,123456789<></

		:zzclr079
#--------------------------------------------------
s/\([^.~]*\)\([^~]*~[^.~]*\)\(.*\)/<\1,\2,\3|=-~.0,123456789<></
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
COMM:/^<\\([^,]*,[^~]*\\)\\.*0*~\\1\\.*0*~/ s/</=/

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
COMM:/^<\\([^,]*,[^~]*\\)\\.*0*~\\1\\.*0*~/ s/</=/

		:zzclr080
#--------------------------------------------------
/^<\([^,]*,[^~]*\)\.*0*~\1\.*0*~/ s/</=/
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
COMM::cmp1

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
COMM::cmp1

		:zzclr081
#--------------------------------------------------
:cmp1
		i\
COMM:s/^\\(<[^,]*\\)\\([0-9]\\),\\([^,]*\\)\\([0-9]\\),/\\1,\\2\\3,\\4/
#--------------------------------------------------
s/^\(<[^,]*\)\([0-9]\),\([^,]*\)\([0-9]\),/\1,\2\3,\4/
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
COMM:t cmp1

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
COMM:t cmp1

		:zzclr082
#--------------------------------------------------
t cmp1
		i\
COMM:/^<\\([^~]*\\)\\([^~]\\)[^~]*~\\1\\(.\\).*|=.*\\3.*\\2/ s/</>/
#--------------------------------------------------
/^<\([^~]*\)\([^~]\)[^~]*~\1\(.\).*|=.*\3.*\2/ s/</>/
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
COMM:/|?/ {

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
COMM:/|?/ {

		:zzclr083
#--------------------------------------------------
/|?/ {
		i\
COMM:s/^\\([<>]\\)\\(-[^~]*~-.*\\1\\)\\(.\\)/\\3\\2/
#--------------------------------------------------
s/^\([<>]\)\(-[^~]*~-.*\1\)\(.\)/\3\2/
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
COMM:s/^\\(.\\)\\(.*|?!*\\)\\1/\\2!\\1/

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
COMM:s/^\\(.\\)\\(.*|?!*\\)\\1/\\2!\\1/

		:zzclr084
#--------------------------------------------------
s/^\(.\)\(.*|?!*\)\1/\2!\1/
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
COMM:s/|?![^!]\\(.\\)/&l\\1x/

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
COMM:s/|?![^!]\\(.\\)/&l\\1x/

		:zzclr085
#--------------------------------------------------
s/|?![^!]\(.\)/&l\1x/
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
COMM:s/[^~]*~[^~]*~\\(.*|?\\)!*.\\(.*\\)|=.*/\\1\\2/

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
COMM:s/[^~]*~[^~]*~\\(.*|?\\)!*.\\(.*\\)|=.*/\\1\\2/

		:zzclr086
#--------------------------------------------------
s/[^~]*~[^~]*~\(.*|?\)!*.\(.*\)|=.*/\1\2/
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
COMM:b next

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
COMM:b next

		:zzclr087
#--------------------------------------------------
b next
		i\
COMM:}
#--------------------------------------------------
}
		i\
COMM:s/\\(-*\\)\\1|=.*/;9876543210;9876543210/
#--------------------------------------------------
s/\(-*\)\1|=.*/;9876543210;9876543210/
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
COMM:/o-/ s/;9876543210/;0123456789/

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
COMM:/o-/ s/;9876543210/;0123456789/

		:zzclr088
#--------------------------------------------------
/o-/ s/;9876543210/;0123456789/
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
COMM:s/^>\\([^~]*~\\)\\([^~]*~\\)s\\(-*\\)\\(-*o\\3\\(-*\\)\\)/>\\2\\1s\\5\\4/

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
COMM:s/^>\\([^~]*~\\)\\([^~]*~\\)s\\(-*\\)\\(-*o\\3\\(-*\\)\\)/>\\2\\1s\\5\\4/

		:zzclr089
#--------------------------------------------------
s/^>\([^~]*~\)\([^~]*~\)s\(-*\)\(-*o\3\(-*\)\)/>\2\1s\5\4/
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
COMM:s/,\\([0-9]*\\)\\.*\\([^,]*\\),\\([0-9]*\\)\\.*\\([0-9]*\\)/\\1,\\2\\3.,\\4;0/

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
COMM:s/,\\([0-9]*\\)\\.*\\([^,]*\\),\\([0-9]*\\)\\.*\\([0-9]*\\)/\\1,\\2\\3.,\\4;0/

		:zzclr090
#--------------------------------------------------
s/,\([0-9]*\)\.*\([^,]*\),\([0-9]*\)\.*\([0-9]*\)/\1,\2\3.,\4;0/
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
COMM::right1

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
COMM::right1

		:zzclr091
#--------------------------------------------------
:right1
		i\
COMM:s/,\\([0-9]\\)\\([^,]*\\),;*\\([0-9]\\)\\([0-9]*\\);*0*/\\1,\\2\\3,\\4;0/
#--------------------------------------------------
s/,\([0-9]\)\([^,]*\),;*\([0-9]\)\([0-9]*\);*0*/\1,\2\3,\4;0/
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
COMM:t right1

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
COMM:t right1

		:zzclr092
#--------------------------------------------------
t right1
		i\
COMM:s/.\\([^,]*\\),~\\(.*\\);0~s\\(-*\\)o-*/\\1~\\30\\2~/
#--------------------------------------------------
s/.\([^,]*\),~\(.*\);0~s\(-*\)o-*/\1~\30\2~/
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
COMM::addsub1

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
COMM::addsub1

		:zzclr093
#--------------------------------------------------
:addsub1
		i\
COMM:s/\\(.\\{0,1\\}\\)\\(~[^,]*\\)\\([0-9]\\)\\(\\.*\\),\\([^;]*\\)\\(;\\([^;]*\\(\\3[^;]*\\)\\).*X*\\1\\(.*\\)\\)/\\2,\\4\\5\\9\\8\\7\\6/
#--------------------------------------------------
s/\(.\{0,1\}\)\(~[^,]*\)\([0-9]\)\(\.*\),\([^;]*\)\(;\([^;]*\(\3[^;]*\)\).*X*\1\(.*\)\)/\2,\4\5\9\8\7\6/
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
COMM:s/,\\([^~]*~\\).\\{10\\}\\(.\\)[^;]\\{0,9\\}\\([^;]\\{0,1\\}\\)[^;]*/,\\2\\1\\3/

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
COMM:s/,\\([^~]*~\\).\\{10\\}\\(.\\)[^;]\\{0,9\\}\\([^;]\\{0,1\\}\\)[^;]*/,\\2\\1\\3/

		:zzclr094
#--------------------------------------------------
s/,\([^~]*~\).\{10\}\(.\)[^;]\{0,9\}\([^;]\{0,1\}\)[^;]*/,\2\1\3/
#	could be done in one s/// if we could have >9 back-refs...
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
COMM:/^~.*~;/ !b addsub1

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
COMM:/^~.*~;/ !b addsub1

		:zzclr095
#--------------------------------------------------
/^~.*~;/ !b addsub1
		i\
COMM::endbin
#--------------------------------------------------
:endbin
		i\
COMM:s/.\\([^,]*\\),\\([0-9.]*\\).*/\\1\\2/
#--------------------------------------------------
s/.\([^,]*\),\([0-9.]*\).*/\1\2/
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
COMM:G

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
COMM:G

		:zzclr096
#--------------------------------------------------
G
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
COMM:s/\\n[^~]*~[^~]*//

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
COMM:s/\\n[^~]*~[^~]*//

		:zzclr097
#--------------------------------------------------
s/\n[^~]*~[^~]*//
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
COMM::normal

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
COMM::normal

		:zzclr098
#--------------------------------------------------
:normal
		i\
COMM:s/^\\(-*\\)0*\\([0-9.]*[0-9]\\)[^~]*/\\1\\2/
#--------------------------------------------------
s/^\(-*\)0*\([0-9.]*[0-9]\)[^~]*/\1\2/
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
COMM:s/^[^1-9~]*~/0~/

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
COMM:s/^[^1-9~]*~/0~/

		:zzclr099
#--------------------------------------------------
s/^[^1-9~]*~/0~/
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
COMM:b next

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
COMM:b next

		:zzclr100
#--------------------------------------------------
b next
		i\
COMM::mul
#--------------------------------------------------
:mul
		i\
COMM:s/\\(-*\\)\\([0-9]*\\)\\.*\\([0-9]*\\)~\\(-*\\)\\([0-9]*\\)\\.*\\([0-9]*\\).*|K\\([^|]*\\).*/\\1\\4\\2\\5.!\\3\\6,|\\2<\\3~\\5>\\6:\\7;9876543210009909/
#--------------------------------------------------
s/\(-*\)\([0-9]*\)\.*\([0-9]*\)~\(-*\)\([0-9]*\)\.*\([0-9]*\).*|K\([^|]*\).*/\1\4\2\5.!\3\6,|\2<\3~\5>\6:\7;9876543210009909/
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
COMM::mul1

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
COMM::mul1

		:zzclr101
#--------------------------------------------------
:mul1
		i\
COMM:s/![0-9]\\([^<]*\\)<\\([0-9]\\{0,1\\}\\)\\([^>]*\\)>\\([0-9]\\{0,1\\}\\)/0!\\1\\2<\\3\\4>/
#--------------------------------------------------
s/![0-9]\([^<]*\)<\([0-9]\{0,1\}\)\([^>]*\)>\([0-9]\{0,1\}\)/0!\1\2<\3\4>/
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
COMM:/![0-9]/ s/\\(:[^;]*\\)\\([1-9]\\)\\(0*\\)\\([^0]*\\2\\(.\\).*X*\\3\\(9*\\)\\)/\\1\\5\\6\\4/

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
COMM:/![0-9]/ s/\\(:[^;]*\\)\\([1-9]\\)\\(0*\\)\\([^0]*\\2\\(.\\).*X*\\3\\(9*\\)\\)/\\1\\5\\6\\4/

		:zzclr102
#--------------------------------------------------
/![0-9]/ s/\(:[^;]*\)\([1-9]\)\(0*\)\([^0]*\2\(.\).*X*\3\(9*\)\)/\1\5\6\4/
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
COMM:/<~[^>]*>:0*;/ !t mul1

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
COMM:/<~[^>]*>:0*;/ !t mul1

		:zzclr103
#--------------------------------------------------
/<~[^>]*>:0*;/ !t mul1
		i\
COMM:s/\\(-*\\)\\1\\([^>]*\\).*/;\\2^>:9876543210aaaaaaaaa/
#--------------------------------------------------
s/\(-*\)\1\([^>]*\).*/;\2^>:9876543210aaaaaaaaa/
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
COMM::mul2

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
COMM::mul2

		:zzclr104
#--------------------------------------------------
:mul2
		i\
COMM:s/\\([0-9]~*\\)^/^\\1/
#--------------------------------------------------
s/\([0-9]~*\)^/^\1/
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
COMM:s/<\\([0-9]*\\)\\(.*[~^]\\)\\([0-9]*\\)>/\\1<\\2>\\3/

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
COMM:s/<\\([0-9]*\\)\\(.*[~^]\\)\\([0-9]*\\)>/\\1<\\2>\\3/

		:zzclr105
#--------------------------------------------------
s/<\([0-9]*\)\(.*[~^]\)\([0-9]*\)>/\1<\2>\3/
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
COMM::mul3

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
COMM::mul3

		:zzclr106
#--------------------------------------------------
:mul3
		i\
COMM:s/>\\([0-9]\\)\\(.*\\1.\\{9\\}\\(a*\\)\\)/\\1>\\2;9\\38\\37\\36\\35\\34\\33\\32\\31\\30/
#--------------------------------------------------
s/>\([0-9]\)\(.*\1.\{9\}\(a*\)\)/\1>\2;9\38\37\36\35\34\33\32\31\30/
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
COMM:s/\\(;[^<]*\\)\\([0-9]\\)<\\([^;]*\\).*\\2[0-9]*\\(.*\\)/\\4\\1<\\2\\3/

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
COMM:s/\\(;[^<]*\\)\\([0-9]\\)<\\([^;]*\\).*\\2[0-9]*\\(.*\\)/\\4\\1<\\2\\3/

		:zzclr107
#--------------------------------------------------
s/\(;[^<]*\)\([0-9]\)<\([^;]*\).*\2[0-9]*\(.*\)/\4\1<\2\3/
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
COMM:s/a[0-9]/a/g

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
COMM:s/a[0-9]/a/g

		:zzclr108
#--------------------------------------------------
s/a[0-9]/a/g
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
COMM:s/a\\{10\\}/b/g

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
COMM:s/a\\{10\\}/b/g

		:zzclr109
#--------------------------------------------------
s/a\{10\}/b/g
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
COMM:s/b\\{10\\}/c/g

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
COMM:s/b\\{10\\}/c/g

		:zzclr110
#--------------------------------------------------
s/b\{10\}/c/g
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
COMM:/|0*[1-9][^>]*>0*[1-9]/ b mul3

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
COMM:/|0*[1-9][^>]*>0*[1-9]/ b mul3

		:zzclr111
#--------------------------------------------------
/|0*[1-9][^>]*>0*[1-9]/ b mul3
		i\
COMM:s/;/a9876543210;/
#--------------------------------------------------
s/;/a9876543210;/
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
COMM:s/a.\\{9\\}\\(.\\)[^;]*\\([^,]*\\)[0-9]\\([.!]*\\),/\\2,\\1\\3/

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
COMM:s/a.\\{9\\}\\(.\\)[^;]*\\([^,]*\\)[0-9]\\([.!]*\\),/\\2,\\1\\3/

		:zzclr112
#--------------------------------------------------
s/a.\{9\}\(.\)[^;]*\([^,]*\)[0-9]\([.!]*\),/\2,\1\3/
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
COMM:y/cb/ba/

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
COMM:y/cb/ba/

		:zzclr113
#--------------------------------------------------
y/cb/ba/
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
COMM:/|<^/ !b mul2

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
COMM:/|<^/ !b mul2

		:zzclr114
#--------------------------------------------------
/|<^/ !b mul2
		i\
COMM:b endbin
#--------------------------------------------------
b endbin
		i\
COMM::div
#--------------------------------------------------
:div
#  CDDET
		i\
COMM:/^[-.0]*[1-9]/ !i\\\\Ndivide by 0
#--------------------------------------------------
/^[-.0]*[1-9]/ !i\
divide by 0
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
COMM:// !b pop

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
COMM:// !b pop

		:zzclr115
		/^[-.0]*[1-9]/y/!/!/
#--------------------------------------------------
// !b pop
		i\
COMM:s/\\(-*\\)\\([0-9]*\\)\\.*\\([^~]*~-*\\)\\([0-9]*\\)\\.*\\([^~]*\\)/\\2.\\3\\1;0\\4.\\5;0/
#--------------------------------------------------
s/\(-*\)\([0-9]*\)\.*\([^~]*~-*\)\([0-9]*\)\.*\([^~]*\)/\2.\3\1;0\4.\5;0/
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
COMM::div1

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
COMM::div1

		:zzclr116
#--------------------------------------------------
:div1
		i\
COMM:s/^\\.0\\([^.]*\\)\\.;*\\([0-9]\\)\\([0-9]*\\);*0*/.\\1\\2.\\3;0/
#--------------------------------------------------
s/^\.0\([^.]*\)\.;*\([0-9]\)\([0-9]*\);*0*/.\1\2.\3;0/
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
COMM:s/^\\([^.]*\\)\\([0-9]\\)\\.\\([^;]*;\\)0*\\([0-9]*\\)\\([0-9]\\)\\./\\1.\\2\\30\\4.\\5/

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
COMM:s/^\\([^.]*\\)\\([0-9]\\)\\.\\([^;]*;\\)0*\\([0-9]*\\)\\([0-9]\\)\\./\\1.\\2\\30\\4.\\5/

		:zzclr117
#--------------------------------------------------
s/^\([^.]*\)\([0-9]\)\.\([^;]*;\)0*\([0-9]*\)\([0-9]\)\./\1.\2\30\4.\5/
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
COMM:t div1

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
COMM:t div1

		:zzclr118
#--------------------------------------------------
t div1
		i\
COMM:s/~\\(-*\\)\\1\\(-*\\);0*\\([^;]*[0-9]\\)[^~]*/~123456789743222111~\\2\\3/
#--------------------------------------------------
s/~\(-*\)\1\(-*\);0*\([^;]*[0-9]\)[^~]*/~123456789743222111~\2\3/
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
COMM:s/\\(.\\(.\\)[^~]*\\)[^9]*\\2.\\{8\\}\\(.\\)[^~]*/\\3~\\1/

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
COMM:s/\\(.\\(.\\)[^~]*\\)[^9]*\\2.\\{8\\}\\(.\\)[^~]*/\\3~\\1/

		:zzclr119
#--------------------------------------------------
s/\(.\(.\)[^~]*\)[^9]*\2.\{8\}\(.\)[^~]*/\3~\1/
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
COMM:s,|?.,&SaSadSaKdlaZ+LaX-1+[sb1]Sbd1>bkLatsbLa[dSa2lbla*-*dLa!=a]dSaxsakLasbLb*t,

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
COMM:s,|?.,&SaSadSaKdlaZ+LaX-1+[sb1]Sbd1>bkLatsbLa[dSa2lbla*-*dLa!=a]dSaxsakLasbLb*t,

		:zzclr120
#--------------------------------------------------
s,|?.,&SaSadSaKdlaZ+LaX-1+[sb1]Sbd1>bkLatsbLa[dSa2lbla*-*dLa!=a]dSaxsakLasbLb*t,
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
COMM:b next

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
COMM:b next

		:zzclr121
#--------------------------------------------------
b next
		i\
COMM::rem
#--------------------------------------------------
:rem
		i\
COMM:s,|?%,&Sadla/LaKSa[999]k*Lak-,
#--------------------------------------------------
s,|?%,&Sadla/LaKSa[999]k*Lak-,
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
COMM:b next

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
COMM:b next

		:zzclr122
#--------------------------------------------------
b next
		i\
COMM::exp
#--------------------------------------------------
:exp
#  This decimal method is just a little faster than the binary method done
#  totally in dc:  1LaKLb [kdSb*LbK]Sb [[.5]*d0ktdSa<bkd*KLad1<a]Sa d1<a kk*
		i\
COMM:/^[^~]*\\./ i\\\\Nfraction in exponent ignored
#--------------------------------------------------
/^[^~]*\./ i\
fraction in exponent ignored
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
COMM:s,[^-0-9].*,;9d**dd*8*d*d7dd**d*6d**d5d*d*4*d3d*2lbd**1lb*0,

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
COMM:s,[^-0-9].*,;9d**dd*8*d*d7dd**d*6d**d5d*d*4*d3d*2lbd**1lb*0,

		:zzclr123
#--------------------------------------------------
s,[^-0-9].*,;9d**dd*8*d*d7dd**d*6d**d5d*d*4*d3d*2lbd**1lb*0,
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
COMM::exp1

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
COMM::exp1

		:zzclr124
#--------------------------------------------------
:exp1
		i\
COMM:s/\\([0-9]\\);\\(.*\\1\\([d*]*\\)[^l]*\\([^*]*\\)\\(\\**\\)\\)/;dd*d**d*\\4\\3\\5\\2/
#--------------------------------------------------
s/\([0-9]\);\(.*\1\([d*]*\)[^l]*\([^*]*\)\(\**\)\)/;dd*d**d*\4\3\5\2/
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
COMM:t exp1

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
COMM:t exp1

		:zzclr125
#--------------------------------------------------
t exp1
		i\
COMM:G
#--------------------------------------------------
G
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
COMM:s,-*.\\{9\\}\\([^9]*\\)[^0]*0.\\(.*|?.\\),\\2~saSaKdsaLb0kLbkK*+k1\\1LaktsbkLax,

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
COMM:s,-*.\\{9\\}\\([^9]*\\)[^0]*0.\\(.*|?.\\),\\2~saSaKdsaLb0kLbkK*+k1\\1LaktsbkLax,

		:zzclr126
#--------------------------------------------------
s,-*.\{9\}\([^9]*\)[^0]*0.\(.*|?.\),\2~saSaKdsaLb0kLbkK*+k1\1LaktsbkLax,
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
COMM:s,|?.,&SadSbdXSaZla-SbKLaLadSb[0Lb-d1lb-*d+K+0kkSb[1Lb/]q]Sa0>a[dk]sadK<a[Lb],

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
COMM:s,|?.,&SadSbdXSaZla-SbKLaLadSb[0Lb-d1lb-*d+K+0kkSb[1Lb/]q]Sa0>a[dk]sadK<a[Lb],

		:zzclr127
#--------------------------------------------------
s,|?.,&SadSbdXSaZla-SbKLaLadSb[0Lb-d1lb-*d+K+0kkSb[1Lb/]q]Sa0>a[dk]sadK<a[Lb],
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
COMM:b next

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
COMM:b next

		:zzclr128
#--------------------------------------------------
b next
		i\
COMM::sqrt
#--------------------------------------------------
:sqrt
#  first square root using sed:  8k2v at 1:30am Dec 17, 1996
		i\
COMM:/^-/ i\\\\Nsquare root of negative number
#--------------------------------------------------
/^-/ i\
square root of negative number
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
COMM:/^[-0]/ b next

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
COMM:/^[-0]/ b next

		:zzclr129
#--------------------------------------------------
/^[-0]/ b next
		i\
COMM:s/~.*//
#--------------------------------------------------
s/~.*//
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
COMM:/^\\./ s/0\\([0-9]\\)/\\1/g

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
COMM:/^\\./ s/0\\([0-9]\\)/\\1/g

		:zzclr130
#--------------------------------------------------
/^\./ s/0\([0-9]\)/\1/g
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
COMM:/^\\./ !s/[0-9][0-9]/7/g

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
COMM:/^\\./ !s/[0-9][0-9]/7/g

		:zzclr131
#--------------------------------------------------
/^\./ !s/[0-9][0-9]/7/g
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
COMM:G

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
COMM:G

		:zzclr132
#--------------------------------------------------
G
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
COMM:s/\\n/~/

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
COMM:s/\\n/~/

		:zzclr133
#--------------------------------------------------
s/\n/~/
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
COMM:s,|?.,&KSbSb[dk]SadXdK<asadlb/lb+[.5]*[sbdlb/lb+[.5]*dlb>a]dsaxsasaLbsaLatLbk,

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
COMM:s,|?.,&KSbSb[dk]SadXdK<asadlb/lb+[.5]*[sbdlb/lb+[.5]*dlb>a]dsaxsasaLbsaLatLbk,

		:zzclr134
#--------------------------------------------------
s,|?.,&KSbSb[dk]SadXdK<asadlb/lb+[.5]*[sbdlb/lb+[.5]*dlb>a]dsaxsasaLbsaLatLbk,
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
COMM:b next

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
COMM:b next

		:zzclr135
#--------------------------------------------------
b next
#  END OF GSU dc.sed
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x

# Debugged SED script generated by sedsed-1.1-dev (http://aurelio.net/projects/sedsed/)
