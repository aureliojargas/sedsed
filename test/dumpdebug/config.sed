#n
#! /bin/sed -nf
####### DESCRIPTION ############################################################
#
# config.sed
# version 1.0
#
# This script processes a configuration file.
#
# The input to the script is a configuration file. Each line of the
# configuration file should be one of the following:
#
# 	1) a blank line (with or without whitespace);
# 	2) a comment;
# 	3) an assignment via equals ('=');
# 	4) an assignment via here document ('<<' or '<<-').
#
# The syntax of a comment is:
#
# 	[<ws>] '#' [<text>]
#
# The syntax of an assignment via equals is:
#
# 	[<ws>] <name> [<ws>] '=' [<ws>] [<value>] [<comment>]
#
# The name must begin with a letter or underscore and can contain any
# combination of digits, letters, dashes, periods, slashes, colons, and
# underscores.
#
# If the value is not present, the entire line will be treated as a comment. If
# the value is present, it must be either unquoted, single-quoted, or
# double-quoted. The value may begin on a subsequent line if each newline after
# the operator (and before the value) is immediately preceded by a backslash,
# and the backslash is the first non-whitespace character after the operator (or
# the first non-whitespace character of the line, in the case of intermittent
# lines). The value may continue over multiple lines if each newline within the
# value is immediately preceeded by a backslash. Such backslash-newline pairs
# will be removed and will not be included as part of the value. A newline
# cannot be part of a value assigned via equals.
#
# An unquoted value extends from the first non-whitespace character to the last
# non-whitespace character (or to the last non-whitespace character before a
# comment, if a comment is present). A pound sign may be included as part of the
# value if escaped by a backslash; the backslash will be removed and will not be
# included as part of the value. Each single quote and double quote (other than
# as the first character) will be treated as if escaped by a backslash (that is,
# no split tokenization will be performed. Each dollar sign, grave accent, and
# backslash (other than a backslash used to escape another character or a
# newline) will be treated as if escaped by a backslash (that is, no parameter
# substitution or command substitution will be performed); if such a backslash
# is present, it will be removed and will not be included as part of the value.
# Otherwise, each backslash (other than a backslash used to escape a newline)
# will be treated literally.
#
# A single-quoted value extends from the first character after the opening quote
# to the last character before the closing quote. A single quote cannot be
# included as part of the value. Each backslash (other than a backslash used to
# escape a newline) will be treated literally.
#
# A double-quoted value extends from the first character after the opening quote
# to the last character before the closing quote. A double quote may be included
# as part of the value if escaped by a backslash; the backslash will be removed
# and will not be included as part of the value. Each dollar sign, grave accent,
# and backslash (other than a backslash used to escape another character or a
# newline) will be treated as if escaped by a backslash (that is, no parameter
# substitution or command substitution will be performed); if such a backslash
# is present, it will be removed and will not be included as part of the value.
# Otherwise, each backslash (other than a backslash used to escape a newline)
# will be treated literally.
#
# The syntax of an assignment via here document is:
#
# 	[<ws>] <name> [<ws>] { '<<' | '<<-' } [<ws>] [<word> [<ws>]
# 	[<value-line>...]
# 	<word>]
#
# The name must adhere to the same syntax as specified for an assignment by
# equals.
#
# If the first occurrance of the word is not present, the entire line will be
# treated as a comment and processing will continue with the next line,
# interpreting it outside the context of a here document. If the first
# occurrance of the word is present, it extends from the first non-whitespace
# character after the operator to the last non-whitespace character, and will be
# treated literally (that is, no parameter substitution or command substitution
# will be performed, either in the word or in any of the value lines).
#
# If the operator is '<<' (meaning the here document is unindented), the value
# will be the concatenation of value lines, read literally, until the second
# occurrance of the word is encountered on a line by itself. The value will
# include each newline that separates a pair of value lines, but will not
# include the newline that separates the last value line from the second
# occurrance of the word.
#
# If the operator is '<<-' (meaning the here document is indented), the result
# will be the same as if the operator was '<<' except that leading tabs will be
# stripped from each line (including the second occurrance of the word).
#
# Since the here document is read literally, comments that appear in the here
# document will be included as part of the value. Also, note that this is not a
# true here document, since it is stored by sed and not in a temporary file.
#
# Because each value is stored by sed, the maximum length of a value is
# approximately eight kilobytes.
#
# The output of the script is a series of lines, one line per assignment in the
# configuration file. The syntax of each output line is:
#
# 	<name> '=' <encoded-value>
#
# Note that each name is guaranteed not to contain an equals sign, and each
# output line will contain no whitespace, unless whitespace is part of the
# value. Thus, the name of the assignment is the first character of the line to
# the last character before the first equals sign, and the encoded value of the
# assignment is the first character after the first equals sign to the last
# character of the line (not including the newline).
#
# In each encoded value, each double quote, dollar sign, grave accent, and
# backslash will be escaped by a backslash, and each newline (present only if
# assigned via here document) will be represented by the escape sequence '\n'.
# This is necessary for representing a newline and useful for assigning both an
# encoded value and a decoded value to shell parameters. Assuming the shell
# parameter 'LINE' contains an output line, consider the following:
#
# 	NAME=`echo $LINE | cut -f 1 -d "="`
# 	VALUE_ENCODED=`echo $LINE | cut -f 2- -d "="`
# 	eval "VALUE_DECODED=\"$VALUE_ENCODED\""
#
# The script will output a line as each assignment in the configuration file is
# processed, until the end of the configuration file is reached or until a
# syntax error is encountered in the configuration file. If the end of the
# configuration file is reached, the last output line will be a status code that
# indicates success. If a syntax error is encountered in the configuration file,
# the last output line will be a status code that indicates the error. The
# status code will be one of the following:
#
# 	 0  success;
# 	 1  invalid name;
# 	 2  beginning of value is folded beyond end-of-file;
# 	 3  unquoted value is folded beyond end-of-file;
# 	 4  single-quoted value is folded beyond end-of-file;
# 	 5  single-quoted value is missing closing quote;
# 	 6  single-quoted value contains extraneous quote;
# 	 7  double-quoted value is folded beyond end-of-file;
# 	 8  double-quoted value is missing closing quote;
# 	 9  double-quoted value contains extraneous quote;
# 	10  unindented here document continues beyond end-of-file;
# 	11  indented here document continues beyond end-of-file.
#
# If the status code is greater than 0, the second-to-last output line will be
# the line number at which the syntax error was encountered. If the status code
# is 1, the third-to-last output line will be the line of the configuration file
# with the invalid name. If the status code is greater than 1, the third-to-last
# output line will be the name that was to be assigned an invalid value.
#
#
####### HISTORY ################################################################
#
# 2001.11.28	Nathan D. Ryan <ryannd@cs.colorado.edu>
# 		Initial implementation. This probably would have been easier in
#		perl, but I got carried away...
#
#
# process a blank line
#
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
COMM:/^[	 ]*$/ b is_eof

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
COMM:/^[	 ]*$/ b is_eof

		:zzclr001
#--------------------------------------------------
/^[	 ]*$/ b is_eof
# process a comment
#
		i\
COMM:/^[	 ]*#/ b is_eof
#--------------------------------------------------
/^[	 ]*#/ b is_eof
# process an assignment via equals ('=')
#
		i\
COMM:/^[	 ]*[A-Za-z_][0-9A-Za-z\\.\\/:_-]*[	 ]*=/ {
#--------------------------------------------------
/^[	 ]*[A-Za-z_][0-9A-Za-z\.\/:_-]*[	 ]*=/ {
# copy the name into the hold space, removing both extraneous whitespace
# and the operator
#
		i\
COMM:h
#--------------------------------------------------
h
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
COMM:s/^[	 ]*\\([^	 =]*\\).*$/\\1/

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
COMM:s/^[	 ]*\\([^	 =]*\\).*$/\\1/

		:zzclr002
#--------------------------------------------------
s/^[	 ]*\([^	 =]*\).*$/\1/
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
COMM:x

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
COMM:x

		:zzclr003
#--------------------------------------------------
x
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
COMM:s/^[^=]*=[	 ]*\\(.*\\)$/\\1/

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
COMM:s/^[^=]*=[	 ]*\\(.*\\)$/\\1/

		:zzclr004
#--------------------------------------------------
s/^[^=]*=[	 ]*\(.*\)$/\1/
# unfold lines before the value
#
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
COMM::unfold

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
COMM::unfold

		:zzclr005
#--------------------------------------------------
:unfold
		i\
COMM:/^\\\\$/ {
#--------------------------------------------------
/^\\$/ {
		i\
COMM:$ {
#--------------------------------------------------
$ {
		i\
COMM:s/^.*$/2/
#--------------------------------------------------
s/^.*$/2/
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
COMM:b quit

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
COMM:b quit

		:zzclr006
#--------------------------------------------------
b quit
		i\
COMM:}
#--------------------------------------------------
}
		i\
COMM:N
#--------------------------------------------------
N
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
COMM:s/\\\\\\n[	 ]*//

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
COMM:s/\\\\\\n[	 ]*//

		:zzclr007
#--------------------------------------------------
s/\\\n[	 ]*//
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
COMM:b unfold

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
COMM:b unfold

		:zzclr008
#--------------------------------------------------
b unfold
		i\
COMM:}
#--------------------------------------------------
}
# process a null value
#
		i\
COMM:/^$/ b is_eof
#--------------------------------------------------
/^$/ b is_eof
# process a null value with a comment
#
		i\
COMM:/^#/ b is_eof
#--------------------------------------------------
/^#/ b is_eof
# process an unquoted value
#
		i\
COMM:/^[^"']/ {
#--------------------------------------------------
/^[^"']/ {
		i\
COMM::unfold0
#--------------------------------------------------
:unfold0
# reset the replacement test
#
		i\
COMM:t reset0
#--------------------------------------------------
t reset0
		i\
COMM::reset0
#--------------------------------------------------
:reset0
# replace a trailing comment with a space (the space prevents
# unintended line folding)
#
		i\
COMM:s/\\([^\\\\]\\)\\(\\\\*\\)\\2#.*$/\\1\\2\\2 /
#--------------------------------------------------
s/\([^\\]\)\(\\*\)\2#.*$/\1\2\2 /
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
COMM:t trim0

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
COMM:t trim0

		:zzclr009
#--------------------------------------------------
t trim0
# unfold lines within the value
#
		i\
COMM:/[^\\\\]\\(\\\\*\\)\\1\\\\$/ {
#--------------------------------------------------
/[^\\]\(\\*\)\1\\$/ {
		i\
COMM:$ {
#--------------------------------------------------
$ {
		i\
COMM:s/^.*$/3/
#--------------------------------------------------
s/^.*$/3/
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
COMM:b quit

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
COMM:b quit

		:zzclr010
#--------------------------------------------------
b quit
		i\
COMM:}
#--------------------------------------------------
}
		i\
COMM:N
#--------------------------------------------------
N
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
COMM:s/\\\\\\n//

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
COMM:s/\\\\\\n//

		:zzclr011
#--------------------------------------------------
s/\\\n//
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
COMM:b unfold0

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
COMM:b unfold0

		:zzclr012
#--------------------------------------------------
b unfold0
		i\
COMM:}
#--------------------------------------------------
}
		i\
COMM::trim0
#--------------------------------------------------
:trim0
# remove trailing whitespace
#
		i\
COMM:s/[	 ]*$//
#--------------------------------------------------
s/[	 ]*$//
# remove each backslash used to escape a pound sign or a single
# quote
#
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
COMM:s/^\\(\\\\*\\)\\1\\\\\\([#']\\)/\\1\\1\\2/g

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
COMM:s/^\\(\\\\*\\)\\1\\\\\\([#']\\)/\\1\\1\\2/g

		:zzclr013
#--------------------------------------------------
s/^\(\\*\)\1\\\([#']\)/\1\1\2/g
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
COMM:s/\\([^\\\\]\\)\\(\\\\*\\)\\1\\\\\\([#']\\)/\\1\\2\\2\\3/g

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
COMM:s/\\([^\\\\]\\)\\(\\\\*\\)\\1\\\\\\([#']\\)/\\1\\2\\2\\3/g

		:zzclr014
#--------------------------------------------------
s/\([^\\]\)\(\\*\)\1\\\([#']\)/\1\2\2\3/g
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
COMM:b decode

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
COMM:b decode

		:zzclr015
#--------------------------------------------------
b decode
		i\
COMM:}
#--------------------------------------------------
}
# process a single-quoted value
#
		i\
COMM:/^'/ {
#--------------------------------------------------
/^'/ {
		i\
COMM::unfold1
#--------------------------------------------------
:unfold1
# reset the replacement test
#
		i\
COMM:t reset1
#--------------------------------------------------
t reset1
		i\
COMM::reset1
#--------------------------------------------------
:reset1
# remove a trailing comment
#
		i\
COMM:s/\\(.'[	 ]*\\)#.*$/\\1/
#--------------------------------------------------
s/\(.'[	 ]*\)#.*$/\1/
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
COMM:t trim1

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
COMM:t trim1

		:zzclr016
#--------------------------------------------------
t trim1
# handle an extraneous quote
#
		i\
COMM:/.'[	 ]*[^	 ]/ {
#--------------------------------------------------
/.'[	 ]*[^	 ]/ {
		i\
COMM:s/^.*$/6/
#--------------------------------------------------
s/^.*$/6/
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
COMM:b quit

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
COMM:b quit

		:zzclr017
#--------------------------------------------------
b quit
		i\
COMM:}
#--------------------------------------------------
}
# unfold lines within the value
#
		i\
COMM:/\\\\$/ {
#--------------------------------------------------
/\\$/ {
		i\
COMM:$ {
#--------------------------------------------------
$ {
		i\
COMM:s/^.*$/4/
#--------------------------------------------------
s/^.*$/4/
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
COMM:b quit

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
COMM:b quit

		:zzclr018
#--------------------------------------------------
b quit
		i\
COMM:}
#--------------------------------------------------
}
		i\
COMM:N
#--------------------------------------------------
N
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
COMM:s/\\\\\\n//

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
COMM:s/\\\\\\n//

		:zzclr019
#--------------------------------------------------
s/\\\n//
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
COMM:b unfold1

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
COMM:b unfold1

		:zzclr020
#--------------------------------------------------
b unfold1
		i\
COMM:}
#--------------------------------------------------
}
		i\
COMM::trim1
#--------------------------------------------------
:trim1
# remove trailing whitespace
#
		i\
COMM:s/[	 ]*$//
#--------------------------------------------------
s/[	 ]*$//
# handle a missing closing quote
#
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
COMM:/'$/ !{

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
COMM:/'$/ !{

		:zzclr021
#--------------------------------------------------
/'$/ !{
		i\
COMM:s/^.*$/5/
#--------------------------------------------------
s/^.*$/5/
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
COMM:b quit

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
COMM:b quit

		:zzclr022
#--------------------------------------------------
b quit
		i\
COMM:}
#--------------------------------------------------
}
# remove the opening quote and the closing quote
#
		i\
COMM:s/^'\\(.*\\)'$/\\1/
#--------------------------------------------------
s/^'\(.*\)'$/\1/
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
COMM:b encode

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
COMM:b encode

		:zzclr023
#--------------------------------------------------
b encode
		i\
COMM:}
#--------------------------------------------------
}
# process a double-quoted value
#
		i\
COMM:/^"/ {
#--------------------------------------------------
/^"/ {
		i\
COMM::unfold2
#--------------------------------------------------
:unfold2
# reset the replacement test
#
		i\
COMM:t reset2
#--------------------------------------------------
t reset2
		i\
COMM::reset2
#--------------------------------------------------
:reset2
# remove a trailing comment
#
		i\
COMM:s/\\([^\\\\]\\)\\(\\\\*\\)\\2"[	 ]*#.*$/\\1\\2\\2"/
#--------------------------------------------------
s/\([^\\]\)\(\\*\)\2"[	 ]*#.*$/\1\2\2"/
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
COMM:t trim2

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
COMM:t trim2

		:zzclr024
#--------------------------------------------------
t trim2
# handle an extraneous quote
#
		i\
COMM:/[^\\\\]\\(\\\\*\\)\\1"[	 ]*[^	 ]/ {
#--------------------------------------------------
/[^\\]\(\\*\)\1"[	 ]*[^	 ]/ {
		i\
COMM:s/^.*$/9/
#--------------------------------------------------
s/^.*$/9/
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
COMM:b quit

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
COMM:b quit

		:zzclr025
#--------------------------------------------------
b quit
		i\
COMM:}
#--------------------------------------------------
}
# unfold lines within the value
#
		i\
COMM:/[^\\\\]\\(\\\\*\\)\\1\\\\$/ {
#--------------------------------------------------
/[^\\]\(\\*\)\1\\$/ {
		i\
COMM:$ {
#--------------------------------------------------
$ {
		i\
COMM:s/^.*$/7/
#--------------------------------------------------
s/^.*$/7/
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
COMM:b quit

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
COMM:b quit

		:zzclr026
#--------------------------------------------------
b quit
		i\
COMM:}
#--------------------------------------------------
}
		i\
COMM:N
#--------------------------------------------------
N
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
COMM:s/\\\\\\n//

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
COMM:s/\\\\\\n//

		:zzclr027
#--------------------------------------------------
s/\\\n//
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
COMM:b unfold2

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
COMM:b unfold2

		:zzclr028
#--------------------------------------------------
b unfold2
		i\
COMM:}
#--------------------------------------------------
}
		i\
COMM::trim2
#--------------------------------------------------
:trim2
# remove trailing whitespace
#
		i\
COMM:s/[	 ]*$//
#--------------------------------------------------
s/[	 ]*$//
# handle a missing closing quote
#
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
COMM:/"$/ !{

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
COMM:/"$/ !{

		:zzclr029
#--------------------------------------------------
/"$/ !{
		i\
COMM:s/^.*$/8/
#--------------------------------------------------
s/^.*$/8/
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
COMM:b quit

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
COMM:b quit

		:zzclr030
#--------------------------------------------------
b quit
		i\
COMM:}
#--------------------------------------------------
}
# remove the opening quote and the closing quote
#
		i\
COMM:s/^"\\(.*\\)"$/\\1/
#--------------------------------------------------
s/^"\(.*\)"$/\1/
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
COMM:b decode

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
COMM:b decode

		:zzclr031
#--------------------------------------------------
b decode
		i\
COMM:}
#--------------------------------------------------
}
		i\
COMM:}
#--------------------------------------------------
}
# process an assignment via here document ('<<' or '<<-')
#
		i\
COMM:/^[	 ]*[A-Za-z_][0-9A-Za-z\\.\\/:_-]*[	 ]*<</ {
#--------------------------------------------------
/^[	 ]*[A-Za-z_][0-9A-Za-z\.\/:_-]*[	 ]*<</ {
# copy the name into the hold space, removing extraneous whitespace
# while retaining the operator
#
		i\
COMM:h
#--------------------------------------------------
h
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
COMM:s/^[	 ]*\\([^	 <]*\\).*$/\\1/

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
COMM:s/^[	 ]*\\([^	 <]*\\).*$/\\1/

		:zzclr032
#--------------------------------------------------
s/^[	 ]*\([^	 <]*\).*$/\1/
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
COMM:x

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
COMM:x

		:zzclr033
#--------------------------------------------------
x
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
COMM:s/^[^<]*\\(<<.*\\)$/\\1/

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
COMM:s/^[^<]*\\(<<.*\\)$/\\1/

		:zzclr034
#--------------------------------------------------
s/^[^<]*\(<<.*\)$/\1/
# process a null value
#
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
COMM:/^<<-\\{0,1\\}[	 ]*$/ b is_eof

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
COMM:/^<<-\\{0,1\\}[	 ]*$/ b is_eof

		:zzclr035
#--------------------------------------------------
/^<<-\{0,1\}[	 ]*$/ b is_eof
# process a value as an unindented here document
#
		i\
COMM:/^<<[^-]/ {
#--------------------------------------------------
/^<<[^-]/ {
# remove the operator
#
		i\
COMM:s/^<<[	 ]*\\(.*\\)$/\\1/
#--------------------------------------------------
s/^<<[	 ]*\(.*\)$/\1/
# add each line of the here document
#
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
COMM::here0

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
COMM::here0

		:zzclr036
#--------------------------------------------------
:here0
		i\
COMM:$ {
#--------------------------------------------------
$ {
		i\
COMM:s/^.*$/10/
#--------------------------------------------------
s/^.*$/10/
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
COMM:b quit

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
COMM:b quit

		:zzclr037
#--------------------------------------------------
b quit
		i\
COMM:}
#--------------------------------------------------
}
		i\
COMM:N
#--------------------------------------------------
N
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
COMM:/^\\(.*\\)\\n.*\\n\\1$/ !{

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
COMM:/^\\(.*\\)\\n.*\\n\\1$/ !{

		:zzclr038
#--------------------------------------------------
/^\(.*\)\n.*\n\1$/ !{
		i\
COMM:b here0
#--------------------------------------------------
b here0
		i\
COMM:}
#--------------------------------------------------
}
# remove the opening word, the final newline, and the closing
# word
#
		i\
COMM:s/^\\(.*\\)\\n\\(.*\\)\\n\\1$/\\2/
#--------------------------------------------------
s/^\(.*\)\n\(.*\)\n\1$/\2/
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
COMM:b encode

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
COMM:b encode

		:zzclr039
#--------------------------------------------------
b encode
		i\
COMM:}
#--------------------------------------------------
}
# process a value as an indented here document
#
		i\
COMM:/^<<-.*$/ {
#--------------------------------------------------
/^<<-.*$/ {
# remove the operator
#
		i\
COMM:s/^<<-[	 ]*\\(.*\\)$/\\1/
#--------------------------------------------------
s/^<<-[	 ]*\(.*\)$/\1/
# add each line of the here document, removing leading tabs
#
		t zzset040
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM::here1

		t zzclr040
		:zzset040
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM::here1

		:zzclr040
#--------------------------------------------------
:here1
		i\
COMM:$ {
#--------------------------------------------------
$ {
		i\
COMM:s/^.*$/11/
#--------------------------------------------------
s/^.*$/11/
		t zzset041
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b quit

		t zzclr041
		:zzset041
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b quit

		:zzclr041
#--------------------------------------------------
b quit
		i\
COMM:}
#--------------------------------------------------
}
		i\
COMM:N
#--------------------------------------------------
N
		t zzset042
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/^\\(.*\\n\\)	*\\(.*\\)$/\\1\\2/

		t zzclr042
		:zzset042
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/^\\(.*\\n\\)	*\\(.*\\)$/\\1\\2/

		:zzclr042
#--------------------------------------------------
s/^\(.*\n\)	*\(.*\)$/\1\2/
		t zzset043
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:/^\\(.*\\)\\n.*\\n\\1$/ !{

		t zzclr043
		:zzset043
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:/^\\(.*\\)\\n.*\\n\\1$/ !{

		:zzclr043
#--------------------------------------------------
/^\(.*\)\n.*\n\1$/ !{
		i\
COMM:b here1
#--------------------------------------------------
b here1
		i\
COMM:}
#--------------------------------------------------
}
# remove the opening word, the final newline, and the closing
# word
#
		i\
COMM:s/^\\(.*\\)\\n\\(.*\\)\\n\\1$/\\2/
#--------------------------------------------------
s/^\(.*\)\n\(.*\)\n\1$/\2/
		t zzset044
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b encode

		t zzclr044
		:zzset044
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b encode

		:zzclr044
#--------------------------------------------------
b encode
		i\
COMM:}
#--------------------------------------------------
}
		i\
COMM:}
#--------------------------------------------------
}
# process an invalid line
#
		i\
COMM:h
#--------------------------------------------------
h
		t zzset045
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/^.*$/1/

		t zzclr045
		:zzset045
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/^.*$/1/

		:zzclr045
#--------------------------------------------------
s/^.*$/1/
# output the results of an invalid assignment and quit; the hold space should
# contain either a line with an invalid name or a valid name that was to be
# assigned an invalid value, and the pattern space should contain a status code
# that indicates the error
#
		t zzset046
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM::quit

		t zzclr046
		:zzset046
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM::quit

		:zzclr046
#--------------------------------------------------
:quit
		i\
COMM:x
#--------------------------------------------------
x
		t zzset047
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

		t zzclr047
		:zzset047
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

		:zzclr047
#--------------------------------------------------
p
		t zzset048
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:=

		t zzclr048
		:zzset048
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:=

		:zzclr048
#--------------------------------------------------
=
		t zzset049
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

		t zzclr049
		:zzset049
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

		:zzclr049
#--------------------------------------------------
x
		t zzset050
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

		t zzclr050
		:zzset050
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

		:zzclr050
#--------------------------------------------------
p
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:q
#--------------------------------------------------
q
# decode the value; remove each backslash used to escape a double quote, a
# dollar sign, a grave accent, or another backslash
#
		t zzset051
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM::decode

		t zzclr051
		:zzset051
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM::decode

		:zzclr051
#--------------------------------------------------
:decode
		i\
COMM:s/^\\(\\\\*\\)\\1\\\\\\(["$`]\\)/\\1\\1\\2/g
#--------------------------------------------------
s/^\(\\*\)\1\\\(["$`]\)/\1\1\2/g
		t zzset052
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/\\([^\\\\]\\)\\(\\\\*\\)\\1\\\\\\(["$`]\\)/\\1\\2\\2\\3/g

		t zzclr052
		:zzset052
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/\\([^\\\\]\\)\\(\\\\*\\)\\1\\\\\\(["$`]\\)/\\1\\2\\2\\3/g

		:zzclr052
#--------------------------------------------------
s/\([^\\]\)\(\\*\)\1\\\(["$`]\)/\1\2\2\3/g
		t zzset053
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/\\\\\\\\/\\\\/g

		t zzclr053
		:zzset053
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/\\\\\\\\/\\\\/g

		:zzclr053
#--------------------------------------------------
s/\\\\/\\/g
# encode the value; add a backslash to escape each double quote, dollar sign,
# grave accent, and backslash; replace each newlin with the escape sequence '\n'
#
		t zzset054
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM::encode

		t zzclr054
		:zzset054
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM::encode

		:zzclr054
#--------------------------------------------------
:encode
		i\
COMM:s/\\\\/\\\\\\\\/g
#--------------------------------------------------
s/\\/\\\\/g
		t zzset055
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/\\(["$`]\\)/\\\\\\1/g

		t zzclr055
		:zzset055
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/\\(["$`]\\)/\\\\\\1/g

		:zzclr055
#--------------------------------------------------
s/\(["$`]\)/\\\1/g
		t zzset056
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/\\n/\\\\n/g

		t zzclr056
		:zzset056
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/\\n/\\\\n/g

		:zzclr056
#--------------------------------------------------
s/\n/\\n/g
# output the results of a valid assignment; the hold space contains the name,
# name, and the pattern space contains the encoded value
#
		t zzset057
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

		t zzclr057
		:zzset057
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

		:zzclr057
#--------------------------------------------------
x
		t zzset058
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/^\\(.*\\)$/\\1=/

		t zzclr058
		:zzset058
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/^\\(.*\\)$/\\1=/

		:zzclr058
#--------------------------------------------------
s/^\(.*\)$/\1=/
		t zzset059
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

		t zzclr059
		:zzset059
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

		:zzclr059
#--------------------------------------------------
G
		t zzset060
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/\\n//

		t zzclr060
		:zzset060
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/\\n//

		:zzclr060
#--------------------------------------------------
s/\n//
		t zzset061
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

		t zzclr061
		:zzset061
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

		:zzclr061
#--------------------------------------------------
p
# determine if the last line was just processed; if so, output a status code
# that indicates success
#
		t zzset062
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM::is_eof

		t zzclr062
		:zzset062
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM::is_eof

		:zzclr062
#--------------------------------------------------
:is_eof
		i\
COMM:$ {
#--------------------------------------------------
$ {
		i\
COMM:s/^.*$/0/
#--------------------------------------------------
s/^.*$/0/
		t zzset063
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

		t zzclr063
		:zzset063
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

		:zzclr063
#--------------------------------------------------
p
		t zzset064
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

		t zzclr064
		:zzset064
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

		:zzclr064
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

# Debugged SED script generated by sedsed (https://aurelio.net/projects/sedsed/)
