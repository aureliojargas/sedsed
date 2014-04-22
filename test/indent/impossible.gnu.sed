#n
#!/bin/sed -f
#  Sort, partition, and number a list of names in only 14 sed commands.
#  By Greg Ubben, 14 Nov 1996
#
#  Use with -n option to prevent a trailing blank line.
#  Assumes no control characters, even though the sort handles tabs.

#  Sed insertion sort by Greg Ubben, 26 April 1989.  All rights reserved.
#  Note that the code contains some unprintable Ctrl-A and Tab characters.
#  The \(\(.\)\) have been unnested to allow for some brain-damaged seds.
#  Some overlap with next; s:/:/.: the last command for a stand-alone sort.

G
1 s/\n/&&	 !"#$%\&'()*+,-.\/0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~/
s/\([	 -~]*\)\(\n\)/\2\1/
s/^\(.[	 -~]*\)\([	 -~]\)\([	 -~]*\)\(.*\1\)\([	 -~]\)\([	 -~]*\)\(.*\n.*\5[	 -~]*\2[ -~]*\)$/\4\5\6\1\2\3\7/
h
$ !d
s///g
s/\(.*\)\n.*/\1/

#  Output, adding a blank line between sections and numbering each section.
#  The do-nothing X* below is needed on the SunOS 4.1 sed to work around a
#  RE bug that occurs when a non-null c* closure precedes a null \n recall.

:loop
s/\([0-9]*\)[ -~]*\n/\1;9876543210990090 /
s/\([0-8]\{0,1\}\)\(9*\);[^1]*\(.\)\1[0-9]*X*\2\(0*\)[^ ]*/\3\4/
P
/^[0-9]* \(.\).*\n\1/ !s/[ -~]*//
/^\n/ P
/./ b loop
