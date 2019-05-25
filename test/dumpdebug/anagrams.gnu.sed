#n
#! /bin/sed -nf
# Search for anagrams in a line-feed-delimited (i.e. one word per line)
# list of words
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
# Sort the letters of the word (preceding it with a @)
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
COMM:s/$/@/

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
COMM:s/$/@/

		:zzclr002
#--------------------------------------------------
s/$/@/
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
COMM:t z

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
COMM:t z

		:zzclr003
#--------------------------------------------------
t z
		i\
COMM::z
#--------------------------------------------------
:z
		i\
COMM:s/\\(z\\+\\)\\(.*@\\)/\\2\\1/
#--------------------------------------------------
s/\(z\+\)\(.*@\)/\2\1/
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
COMM:t z

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
COMM:t z

		:zzclr004
#--------------------------------------------------
t z
		i\
COMM::y
#--------------------------------------------------
:y
		i\
COMM:s/\\(y\\+\\)\\(.*@\\)/\\2\\1/
#--------------------------------------------------
s/\(y\+\)\(.*@\)/\2\1/
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
COMM:t y

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
COMM:t y

		:zzclr005
#--------------------------------------------------
t y
		i\
COMM::x
#--------------------------------------------------
:x
		i\
COMM:s/\\(x\\+\\)\\(.*@\\)/\\2\\1/
#--------------------------------------------------
s/\(x\+\)\(.*@\)/\2\1/
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
COMM:t x

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
COMM:t x

		:zzclr006
#--------------------------------------------------
t x
		i\
COMM::w
#--------------------------------------------------
:w
		i\
COMM:s/\\(w\\+\\)\\(.*@\\)/\\2\\1/
#--------------------------------------------------
s/\(w\+\)\(.*@\)/\2\1/
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
COMM:t w

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
COMM:t w

		:zzclr007
#--------------------------------------------------
t w
		i\
COMM::v
#--------------------------------------------------
:v
		i\
COMM:s/\\(v\\+\\)\\(.*@\\)/\\2\\1/
#--------------------------------------------------
s/\(v\+\)\(.*@\)/\2\1/
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
COMM:t v

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
COMM:t v

		:zzclr008
#--------------------------------------------------
t v
		i\
COMM::u
#--------------------------------------------------
:u
		i\
COMM:s/\\(u\\+\\)\\(.*@\\)/\\2\\1/
#--------------------------------------------------
s/\(u\+\)\(.*@\)/\2\1/
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
COMM:t u

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
COMM:t u

		:zzclr009
#--------------------------------------------------
t u
		i\
COMM::t
#--------------------------------------------------
:t
		i\
COMM:s/\\(t\\+\\)\\(.*@\\)/\\2\\1/
#--------------------------------------------------
s/\(t\+\)\(.*@\)/\2\1/
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
COMM:t t

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
COMM:t t

		:zzclr010
#--------------------------------------------------
t t
		i\
COMM::s
#--------------------------------------------------
:s
		i\
COMM:s/\\(s\\+\\)\\(.*@\\)/\\2\\1/
#--------------------------------------------------
s/\(s\+\)\(.*@\)/\2\1/
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
COMM:t s

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
COMM:t s

		:zzclr011
#--------------------------------------------------
t s
		i\
COMM::r
#--------------------------------------------------
:r
		i\
COMM:s/\\(r\\+\\)\\(.*@\\)/\\2\\1/
#--------------------------------------------------
s/\(r\+\)\(.*@\)/\2\1/
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
COMM:t r

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
COMM:t r

		:zzclr012
#--------------------------------------------------
t r
		i\
COMM::q
#--------------------------------------------------
:q
		i\
COMM:s/\\(q\\+\\)\\(.*@\\)/\\2\\1/
#--------------------------------------------------
s/\(q\+\)\(.*@\)/\2\1/
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
COMM:t q

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
COMM:t q

		:zzclr013
#--------------------------------------------------
t q
		i\
COMM::p
#--------------------------------------------------
:p
		i\
COMM:s/\\(p\\+\\)\\(.*@\\)/\\2\\1/
#--------------------------------------------------
s/\(p\+\)\(.*@\)/\2\1/
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
COMM:t p

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
COMM:t p

		:zzclr014
#--------------------------------------------------
t p
		i\
COMM::o
#--------------------------------------------------
:o
		i\
COMM:s/\\(o\\+\\)\\(.*@\\)/\\2\\1/
#--------------------------------------------------
s/\(o\+\)\(.*@\)/\2\1/
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
COMM:t o

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
COMM:t o

		:zzclr015
#--------------------------------------------------
t o
		i\
COMM::n
#--------------------------------------------------
:n
		i\
COMM:s/\\(n\\+\\)\\(.*@\\)/\\2\\1/
#--------------------------------------------------
s/\(n\+\)\(.*@\)/\2\1/
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
COMM:t n

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
COMM:t n

		:zzclr016
#--------------------------------------------------
t n
		i\
COMM::m
#--------------------------------------------------
:m
		i\
COMM:s/\\(m\\+\\)\\(.*@\\)/\\2\\1/
#--------------------------------------------------
s/\(m\+\)\(.*@\)/\2\1/
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
COMM:t m

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
COMM:t m

		:zzclr017
#--------------------------------------------------
t m
		i\
COMM::l
#--------------------------------------------------
:l
		i\
COMM:s/\\(l\\+\\)\\(.*@\\)/\\2\\1/
#--------------------------------------------------
s/\(l\+\)\(.*@\)/\2\1/
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
COMM:t l

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
COMM:t l

		:zzclr018
#--------------------------------------------------
t l
		i\
COMM::k
#--------------------------------------------------
:k
		i\
COMM:s/\\(k\\+\\)\\(.*@\\)/\\2\\1/
#--------------------------------------------------
s/\(k\+\)\(.*@\)/\2\1/
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
COMM:t k

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
COMM:t k

		:zzclr019
#--------------------------------------------------
t k
		i\
COMM::j
#--------------------------------------------------
:j
		i\
COMM:s/\\(j\\+\\)\\(.*@\\)/\\2\\1/
#--------------------------------------------------
s/\(j\+\)\(.*@\)/\2\1/
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
COMM:t j

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
COMM:t j

		:zzclr020
#--------------------------------------------------
t j
		i\
COMM::i
#--------------------------------------------------
:i
		i\
COMM:s/\\(i\\+\\)\\(.*@\\)/\\2\\1/
#--------------------------------------------------
s/\(i\+\)\(.*@\)/\2\1/
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
COMM:t i

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
COMM:t i

		:zzclr021
#--------------------------------------------------
t i
		i\
COMM::h
#--------------------------------------------------
:h
		i\
COMM:s/\\(h\\+\\)\\(.*@\\)/\\2\\1/
#--------------------------------------------------
s/\(h\+\)\(.*@\)/\2\1/
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
COMM:t h

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
COMM:t h

		:zzclr022
#--------------------------------------------------
t h
		i\
COMM::g
#--------------------------------------------------
:g
		i\
COMM:s/\\(g\\+\\)\\(.*@\\)/\\2\\1/
#--------------------------------------------------
s/\(g\+\)\(.*@\)/\2\1/
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
COMM:t g

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
COMM:t g

		:zzclr023
#--------------------------------------------------
t g
		i\
COMM::f
#--------------------------------------------------
:f
		i\
COMM:s/\\(f\\+\\)\\(.*@\\)/\\2\\1/
#--------------------------------------------------
s/\(f\+\)\(.*@\)/\2\1/
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
COMM:t f

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
COMM:t f

		:zzclr024
#--------------------------------------------------
t f
		i\
COMM::e
#--------------------------------------------------
:e
		i\
COMM:s/\\(e\\+\\)\\(.*@\\)/\\2\\1/
#--------------------------------------------------
s/\(e\+\)\(.*@\)/\2\1/
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
COMM:t e

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
COMM:t e

		:zzclr025
#--------------------------------------------------
t e
		i\
COMM::d
#--------------------------------------------------
:d
		i\
COMM:s/\\(d\\+\\)\\(.*@\\)/\\2\\1/
#--------------------------------------------------
s/\(d\+\)\(.*@\)/\2\1/
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
COMM:t d

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
COMM:t d

		:zzclr026
#--------------------------------------------------
t d
		i\
COMM::c
#--------------------------------------------------
:c
		i\
COMM:s/\\(c\\+\\)\\(.*@\\)/\\2\\1/
#--------------------------------------------------
s/\(c\+\)\(.*@\)/\2\1/
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
COMM:t c

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
COMM:t c

		:zzclr027
#--------------------------------------------------
t c
		i\
COMM::b
#--------------------------------------------------
:b
		i\
COMM:s/\\(b\\+\\)\\(.*@\\)/\\2\\1/
#--------------------------------------------------
s/\(b\+\)\(.*@\)/\2\1/
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
COMM:t b

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
COMM:t b

		:zzclr028
#--------------------------------------------------
t b
		i\
COMM::a
#--------------------------------------------------
:a
		i\
COMM:s/\\(a\\+\\)\\(.*@\\)/\\2\\1/
#--------------------------------------------------
s/\(a\+\)\(.*@\)/\2\1/
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
COMM:t a

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
COMM:t a

		:zzclr029
#--------------------------------------------------
t a
# After this second H command, we added to the hold space <word>\n@<signature>
# We'll remove the extra newlines later
		i\
COMM:H
#--------------------------------------------------
H
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
COMM:$ {

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
COMM:$ {

		:zzclr030
#--------------------------------------------------
$ {
# Append a final line feed to hold space, change \n@ to @
		i\
COMM:s/.*//
#--------------------------------------------------
s/.*//
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
COMM:H

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
COMM:H

		:zzclr031
#--------------------------------------------------
H
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
COMM:g

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
COMM:g

		:zzclr032
#--------------------------------------------------
g
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
COMM:s/\\n@/@/g

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
COMM:s/\\n@/@/g

		:zzclr033
#--------------------------------------------------
s/\n@/@/g
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
COMM:h

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
COMM:h

		:zzclr034
#--------------------------------------------------
h
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
COMM:t loop

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
COMM:t loop

		:zzclr035
#--------------------------------------------------
t loop
		i\
COMM::loop
#--------------------------------------------------
:loop
# Search two words with the same signature and print them
# \1 = first word
# \2 = signature
# \3 = anything in the middle (not backref'ed, needed for \?)
# \4 = second word
		i\
COMM:s/^.*\\n\\([a-z]*\\)@\\([a-z]*\\)\\n\\(.*\\n\\)\\?\\([a-z]*\\)@\\2\\n.*$/\\1 \\4/p
#--------------------------------------------------
s/^.*\n\([a-z]*\)@\([a-z]*\)\n\(.*\n\)\?\([a-z]*\)@\2\n.*$/\1 \4/p
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
COMM:g

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
COMM:g

		:zzclr036
#--------------------------------------------------
g
# Remove the second of the two words with the same signature
# so we'll print n-1 pairs instead of n(n-1)/2
# \1 = anything before
# \2 = first word @ signature
# \3 = signature
# \4 = anything in the middle (not backref'ed, needed for \?)
# \5 = anything after
#
# We need to use \1 and \5 to make sure we remove exactly the same
# pair that we printed above
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
COMM:s/^\\(.*\\)\\(\\n[a-z]*@\\([a-z]*\\)\\n\\)\\(.*\\n\\)\\?[a-z]*@\\3\\n\\(.*\\)$/\\1\\2\\4\\5/

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
COMM:s/^\\(.*\\)\\(\\n[a-z]*@\\([a-z]*\\)\\n\\)\\(.*\\n\\)\\?[a-z]*@\\3\\n\\(.*\\)$/\\1\\2\\4\\5/

		:zzclr037
#--------------------------------------------------
s/^\(.*\)\(\n[a-z]*@\([a-z]*\)\n\)\(.*\n\)\?[a-z]*@\3\n\(.*\)$/\1\2\4\5/
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
COMM:h

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
COMM:h

		:zzclr038
#--------------------------------------------------
h
# Look for another anagram if we did find one
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
COMM:t loop

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
COMM:t loop

		:zzclr039
#--------------------------------------------------
t loop
		i\
COMM:}
#--------------------------------------------------
}
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x

# Debugged SED script generated by sedsed (http://aurelio.net/projects/sedsed/)
