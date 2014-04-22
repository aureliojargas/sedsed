#n
#! /bin/sed -f

# remove all trailing /s
s/\/*$//

# add ./ if there are no path, only filename
/\// !s/^/.\//

# save path+filename
h

# remove path
s/.*\///

# do conversion only on filename
y/ABCDEFGHIJKLMNOPQRSTUVWXYZ/abcdefghijklmnopqrstuvwxyz/

# swap, now line contains original path+file, hold space contains conv filename
x

# add converted file name to line, which now contains something like
# path/file-name\nconverted-file-name
G

# check if converted file name is equal to original file name, if it is, do
# not print nothing
/^.*\/\(.*\)\n\1/ b 

# now, transform path/fromfile\ntofile, into mv path/fromfile path/tofile
# and print it
s/^\(.*\/\)\(.*\)\n\(.*\)$/mv \1\2 \1\3/p
