		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:/bla/ {
#--------------------------------------------------
/bla/ {
# at this address
		i\
COMM:h
#--------------------------------------------------
h
# do this
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
#--------------------------------------------------
g
# than that
#
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
#--------------------------------------------------
}
#loop end
		i\
COMM:s///
		/bla/y/!/!/
#--------------------------------------------------
s///
# script end
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x

# Debugged SED script generated by sedsed (http://aurelio.net/projects/sedsed/)
