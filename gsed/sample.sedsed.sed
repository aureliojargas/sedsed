#n
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
d
D
g
G
h
H
n
N
p
P
x
}

/optional numeric argument/ {
q
l
}

/labels/ {
:abc1
t abc2
b abc3
t
b
}

/files/ {
r filer
w filew
s/foo/bar/gw filesw
}

/aic/ {
a\
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

/extra useless ;/ {
p;
p ;
p;
p ;
p;;;;
s/a/b/g;
s/a/b/g ;
s/a/b/g;
s/a/b/g ;
r foo
s/a/b/w filesw
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
} ;

s/foo/bar/gpw filesw
y/A/B/
y.a.b.
#comment
#    indented
