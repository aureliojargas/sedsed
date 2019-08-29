# Address with no spaces
1 {
    x
    s/.*/10/p
    x
}
2,3 {
    x
    s/.*/11/p
    x
}
4,4 {
    x
    s/.*/12/p
    x
}
5,$ {
    x
    s/.*/13/p
    x
}
/one/ {
    x
    s/.*/14/p
    x
}
/two/,/three/ {
    x
    s/.*/15/p
    x
}
/four/,/four/ {
    x
    s/.*/16/p
    x
}
/five/,$ {
    x
    s/.*/17/p
    x
}
1,/three/ {
    x
    s/.*/18/p
    x
}
/four/,5 {
    x
    s/.*/19/p
    x
}
/six/,// {
    x
    s/.*/1A/p
    x
}

# Address with a different delimiter: \,foo, instead of /foo/
\,one, {
    x
    s/.*/21/p
    x
}
\,two,,\,three, {
    x
    s/.*/22/p
    x
}
\,four,,\,four, {
    x
    s/.*/23/p
    x
}
\,five,,$ {
    x
    s/.*/24/p
    x
}
1,\,three, {
    x
    s/.*/25/p
    x
}
\,four,,6 {
    x
    s/.*/26/p
    x
}
\,one,,/two/ {
    x
    s/.*/27/p
    x
}
/three/,\,four, {
    x
    s/.*/28/p
    x
}
\,five,,// {
    x
    s/.*/29/p
    x
}
\,six,,\,, {
    x
    s/.*/2A/p
    x
}

# Address with spaces and tabs (tabstop=8)
1 {
    x
    s/.*/10s/p
    x
}
2,3 {
    x
    s/.*/11s/p
    x
}
4,4 {
    x
    s/.*/12s/p
    x
}
5,$ {
    x
    s/.*/13s/p
    x
}
/one/ {
    x
    s/.*/14s/p
    x
}
/two/,/three/ {
    x
    s/.*/15s/p
    x
}
/four/,/four/ {
    x
    s/.*/16s/p
    x
}
/five/,$ {
    x
    s/.*/17s/p
    x
}
1,/three/ {
    x
    s/.*/18s/p
    x
}
/four/,5 {
    x
    s/.*/19s/p
    x
}
/six/,// {
    x
    s/.*/1As/p
    x
}

# Address with a different delimiter, spaces and tabs
\,one, {
    x
    s/.*/21s/p
    x
}
\,two,,\,three, {
    x
    s/.*/22s/p
    x
}
\,four,,\,four, {
    x
    s/.*/23s/p
    x
}
\,five,,$ {
    x
    s/.*/24s/p
    x
}
1,\,three, {
    x
    s/.*/25s/p
    x
}
\,four,,6 {
    x
    s/.*/26s/p
    x
}
\,one,,/two/ {
    x
    s/.*/27s/p
    x
}
/three/,\,four, {
    x
    s/.*/28s/p
    x
}
\,five,,// {
    x
    s/.*/29s/p
    x
}
\,six,,\,, {
    x
    s/.*/2As/p
    x
}


# Remove the original line
d
