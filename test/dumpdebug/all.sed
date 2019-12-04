#n
# IMPORTANT: This file has significant trailing spaces, do not remove them!
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
COMM:5 !H

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
COMM:5 !H

		:zzclr001
#--------------------------------------------------
5 !H
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
COMM:1,5 g

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
COMM:1,5 g

		:zzclr002
#--------------------------------------------------
1,5 g
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
COMM:/xxx/I G

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
COMM:/xxx/I G

		:zzclr003
#--------------------------------------------------
/xxx/I G
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
COMM:2,/xxx/ x

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
COMM:2,/xxx/ x

		:zzclr004
#--------------------------------------------------
2,/xxx/ x
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
COMM:\\|pipe\\n\\|\\n|,\\ space  x

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
COMM:\\|pipe\\n\\|\\n|,\\ space  x

		:zzclr005
#--------------------------------------------------
\|pipe\n\|\n|,\ space  x
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
COMM:$ h

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
COMM:$ h

		:zzclr006
#--------------------------------------------------
$ h
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
COMM:1,$ {

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
COMM:1,$ {

		:zzclr007
#--------------------------------------------------
1,$ {
		i\
COMM:// {
		\ space y/!/!/
#--------------------------------------------------
// {
		i\
COMM:x
#--------------------------------------------------
x
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
COMM:$ !{

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
COMM:$ !{

		:zzclr008
#--------------------------------------------------
$ !{
		i\
COMM:d
#--------------------------------------------------
d
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
COMM:}

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
COMM:}

		:zzclr009
#--------------------------------------------------
}
		i\
COMM:}
#--------------------------------------------------
}
		i\
COMM:}
#--------------------------------------------------
}
		i\
COMM:/no arguments/ {
#--------------------------------------------------
/no arguments/ {
		i\
COMM:=
#--------------------------------------------------
=
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:d
#--------------------------------------------------
d
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
COMM:D

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
COMM:D

		:zzclr010
#--------------------------------------------------
D
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
COMM:g

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
COMM:g

		:zzclr011
#--------------------------------------------------
g
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
COMM:G

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
COMM:G

		:zzclr012
#--------------------------------------------------
G
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
COMM:h

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
COMM:h

		:zzclr013
#--------------------------------------------------
h
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
COMM:H

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
COMM:H

		:zzclr014
#--------------------------------------------------
H
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:n
#--------------------------------------------------
n
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
COMM:N

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
COMM:N

		:zzclr015
#--------------------------------------------------
N
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
COMM:p

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
COMM:p

		:zzclr016
#--------------------------------------------------
p
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
COMM:P

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
COMM:P

		:zzclr017
#--------------------------------------------------
P
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
COMM:x

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
COMM:x

		:zzclr018
#--------------------------------------------------
x
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
COMM:}

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
COMM:}

		:zzclr019
#--------------------------------------------------
}
		i\
COMM:/optional numeric argument/ {
#--------------------------------------------------
/optional numeric argument/ {
		i\
COMM:q
#--------------------------------------------------
q
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
COMM:l

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
COMM:l

		:zzclr020
#--------------------------------------------------
l
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
COMM:}

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
COMM:}

		:zzclr021
#--------------------------------------------------
}
		i\
COMM:/labels/ {
#--------------------------------------------------
/labels/ {
		i\
COMM::abc1
#--------------------------------------------------
:abc1
		i\
COMM::ABC2
#--------------------------------------------------
:ABC2
		i\
COMM:b abc1
#--------------------------------------------------
b abc1
		i\
COMM:t ABC2
#--------------------------------------------------
t ABC2
		i\
COMM:b
#--------------------------------------------------
b
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
COMM:t

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
COMM:t

		:zzclr022
#--------------------------------------------------
t
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
COMM:}

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
COMM:}

		:zzclr023
#--------------------------------------------------
}
		i\
COMM:/files/ {
#--------------------------------------------------
/files/ {
		i\
COMM:r filer
#--------------------------------------------------
r filer
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
COMM:w filew

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
COMM:w filew

		:zzclr024
#--------------------------------------------------
w filew
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
COMM:s/foo/bar/gw filesw

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
COMM:s/foo/bar/gw filesw

		:zzclr025
#--------------------------------------------------
s/foo/bar/gw filesw
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
COMM:}

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
COMM:}

		:zzclr026
#--------------------------------------------------
}
		i\
COMM:/aic/ {
#--------------------------------------------------
/aic/ {
		i\
COMM:a\\\\Ntext_a
#--------------------------------------------------
a\
text_a
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
COMM:i\\\\Ntext_i1\\\\Ntext_i2\\\\N

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
COMM:i\\\\Ntext_i1\\\\Ntext_i2\\\\N

		:zzclr027
#--------------------------------------------------
i\
text_i1\
text_i2\
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
COMM:c\\\\Ntext_c1\\\\Ntext_c2 \\\\Ntext_c3  

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
COMM:c\\\\Ntext_c1\\\\Ntext_c2 \\\\Ntext_c3  

		:zzclr029
#--------------------------------------------------
c\
text_c1\
text_c2 \
text_c3  
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
COMM:}

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
COMM:}

		:zzclr030
#--------------------------------------------------
}
		i\
COMM:/extra useless ;/ {
#--------------------------------------------------
/extra useless ;/ {
		i\
COMM:p
#--------------------------------------------------
p
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
COMM:p

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
COMM:p

		:zzclr031
#--------------------------------------------------
p
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
COMM:p

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
COMM:p

		:zzclr032
#--------------------------------------------------
p
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
COMM:s/a/b/g

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
COMM:s/a/b/g

		:zzclr033
#--------------------------------------------------
s/a/b/g
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
COMM:s/a/b/g

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
COMM:s/a/b/g

		:zzclr034
#--------------------------------------------------
s/a/b/g
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
COMM::foo

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
COMM::foo

		:zzclr035
#--------------------------------------------------
:foo
		i\
COMM::foo
#--------------------------------------------------
:foo
		i\
COMM:b foo
#--------------------------------------------------
b foo
		i\
COMM:b foo
#--------------------------------------------------
b foo
		i\
COMM:b
#--------------------------------------------------
b
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
COMM:b

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
COMM:b

		:zzclr036
#--------------------------------------------------
b
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
COMM:}

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
COMM:}

		:zzclr037
#--------------------------------------------------
}
		i\
COMM:s/foo/bar/gpw filesw
#--------------------------------------------------
s/foo/bar/gpw filesw
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
COMM:y/A/B/

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
COMM:y/A/B/

		:zzclr038
#--------------------------------------------------
y/A/B/
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
COMM:y.a.b.

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
COMM:y.a.b.

		:zzclr039
#--------------------------------------------------
y.a.b.
#comment
#    indented
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x

# Debugged SED script generated by sedsed (https://aurelio.net/projects/sedsed/)
