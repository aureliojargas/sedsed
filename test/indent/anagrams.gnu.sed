#n
#! /bin/sed -nf

# Search for anagrams in a line-feed-delimited (i.e. one word per line)
# list of words

H

# Sort the letters of the word (preceding it with a @)
s/$/@/
t z
:z
s/\(z\+\)\(.*@\)/\2\1/
t z
:y
s/\(y\+\)\(.*@\)/\2\1/
t y
:x
s/\(x\+\)\(.*@\)/\2\1/
t x
:w
s/\(w\+\)\(.*@\)/\2\1/
t w
:v
s/\(v\+\)\(.*@\)/\2\1/
t v
:u
s/\(u\+\)\(.*@\)/\2\1/
t u
:t
s/\(t\+\)\(.*@\)/\2\1/
t t
:s
s/\(s\+\)\(.*@\)/\2\1/
t s
:r
s/\(r\+\)\(.*@\)/\2\1/
t r
:q
s/\(q\+\)\(.*@\)/\2\1/
t q
:p
s/\(p\+\)\(.*@\)/\2\1/
t p
:o
s/\(o\+\)\(.*@\)/\2\1/
t o
:n
s/\(n\+\)\(.*@\)/\2\1/
t n
:m
s/\(m\+\)\(.*@\)/\2\1/
t m
:l
s/\(l\+\)\(.*@\)/\2\1/
t l
:k
s/\(k\+\)\(.*@\)/\2\1/
t k
:j
s/\(j\+\)\(.*@\)/\2\1/
t j
:i
s/\(i\+\)\(.*@\)/\2\1/
t i
:h
s/\(h\+\)\(.*@\)/\2\1/
t h
:g
s/\(g\+\)\(.*@\)/\2\1/
t g
:f
s/\(f\+\)\(.*@\)/\2\1/
t f
:e
s/\(e\+\)\(.*@\)/\2\1/
t e
:d
s/\(d\+\)\(.*@\)/\2\1/
t d
:c
s/\(c\+\)\(.*@\)/\2\1/
t c
:b
s/\(b\+\)\(.*@\)/\2\1/
t b
:a
s/\(a\+\)\(.*@\)/\2\1/
t a

# After this second H command, we added to the hold space <word>\n@<signature>
# We'll remove the extra newlines later
H

$ {
    # Append a final line feed to hold space, change \n@ to @
    s/.*//
    H
    g
    s/\n@/@/g
    h

    t loop
    :loop
    # Search two words with the same signature and print them
    # \1 = first word
    # \2 = signature
    # \3 = anything in the middle (not backref'ed, needed for \?)
    # \4 = second word
    s/^.*\n\([a-z]*\)@\([a-z]*\)\n\(.*\n\)\?\([a-z]*\)@\2\n.*$/\1 \4/p
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
    s/^\(.*\)\(\n[a-z]*@\([a-z]*\)\n\)\(.*\n\)\?[a-z]*@\3\n\(.*\)$/\1\2\4\5/
    h

    # Look for another anagram if we did find one
    t loop
}
