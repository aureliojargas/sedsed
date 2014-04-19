#n
#! /bin/sed -nf

# Search for anagrams in a line-feed-delimited (i.e. one word per line)
# list of words

H

# Sort the letters of the word (preceding it with a @)
s/$/@/
tz
:z; s/\(z\+\)\(.*@\)/\2\1/; tz
:y; s/\(y\+\)\(.*@\)/\2\1/; ty
:x; s/\(x\+\)\(.*@\)/\2\1/; tx
:w; s/\(w\+\)\(.*@\)/\2\1/; tw
:v; s/\(v\+\)\(.*@\)/\2\1/; tv
:u; s/\(u\+\)\(.*@\)/\2\1/; tu
:t; s/\(t\+\)\(.*@\)/\2\1/; tt
:s; s/\(s\+\)\(.*@\)/\2\1/; ts
:r; s/\(r\+\)\(.*@\)/\2\1/; tr
:q; s/\(q\+\)\(.*@\)/\2\1/; tq
:p; s/\(p\+\)\(.*@\)/\2\1/; tp
:o; s/\(o\+\)\(.*@\)/\2\1/; to
:n; s/\(n\+\)\(.*@\)/\2\1/; tn
:m; s/\(m\+\)\(.*@\)/\2\1/; tm
:l; s/\(l\+\)\(.*@\)/\2\1/; tl
:k; s/\(k\+\)\(.*@\)/\2\1/; tk
:j; s/\(j\+\)\(.*@\)/\2\1/; tj
:i; s/\(i\+\)\(.*@\)/\2\1/; ti
:h; s/\(h\+\)\(.*@\)/\2\1/; th
:g; s/\(g\+\)\(.*@\)/\2\1/; tg
:f; s/\(f\+\)\(.*@\)/\2\1/; tf
:e; s/\(e\+\)\(.*@\)/\2\1/; te
:d; s/\(d\+\)\(.*@\)/\2\1/; td
:c; s/\(c\+\)\(.*@\)/\2\1/; tc
:b; s/\(b\+\)\(.*@\)/\2\1/; tb
:a; s/\(a\+\)\(.*@\)/\2\1/; ta

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
