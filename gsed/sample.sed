#n
# IMPORTANT: This file has significant trailing spaces, do not remove them!
5!H
1,5g
/xxx/IG
2,/xxx/x
\|pipe\n\|\n|,\ space x
$h

1,$ {
  // {
    x
    $!{
      d
    }
  }
}


/no arguments/ {
=
d;D
g;G
h;H
n;N
p;P
z
x
}

/optional numeric argument/ {
q;q1
Q;Q2
l;l 3
L;L 4
v;v 4.2
}

/labels/ {
:abc1
:ABC2 
b abc1 
t ABC2
T abc1
b 
t
T
}

/files/ {
r filer
R fileR
w filew
W fileW
s/foo/bar/gw filesw
}

/aic/ {
a \
text_a
i\
text_i1\
text_i2\

p
c\
text_c1\
text_c2 \
text_c3  
}

/extra useless ;/ { ; 
p;
p ;
p; 
p ; 
p;;;;
p ; ; ; ; 
s/a/b/g;
s/a/b/g ;
s/a/b/g; 
s/a/b/g ; 
r foo;
s/a/b/w filesw;
:foo;
:foo ;
:foo ; 
b foo;
b foo ;
b foo ; 
b;
b ;
b; 
b ; 
q1;
q1 ;
q1; 
q1 ; 
} ; 

e date
s/foo/bar/gpw filesw
s;\n\;\n;\n;3
y/A/B/
y.a.b.
#comment
#    indented
