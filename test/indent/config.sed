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
/^[	 ]*$/ b is_eof


# process a comment
#
/^[	 ]*#/ b is_eof


# process an assignment via equals ('=')
#
/^[	 ]*[A-Za-z_][0-9A-Za-z\.\/:_-]*[	 ]*=/ {

    # copy the name into the hold space, removing both extraneous whitespace
    # and the operator
    #
    h
    s/^[	 ]*\([^	 =]*\).*$/\1/
    x
    s/^[^=]*=[	 ]*\(.*\)$/\1/

    # unfold lines before the value
    #
    :unfold
    /^\\$/ {
        $ {
            s/^.*$/2/
            b quit
        }
        N
        s/\\\n[	 ]*//
        b unfold
    }

    # process a null value
    #
    /^$/ b is_eof

    # process a null value with a comment
    #
    /^#/ b is_eof

    # process an unquoted value
    #
    /^[^"']/ {
        :unfold0

        # reset the replacement test
        #
        t reset0
        :reset0

        # replace a trailing comment with a space (the space prevents
        # unintended line folding)
        #
        s/\([^\\]\)\(\\*\)\2#.*$/\1\2\2 /
        t trim0

        # unfold lines within the value
        #
        /[^\\]\(\\*\)\1\\$/ {
            $ {
                s/^.*$/3/
                b quit
            }
            N
            s/\\\n//
            b unfold0
        }

        :trim0
        # remove trailing whitespace
        #
        s/[	 ]*$//

        # remove each backslash used to escape a pound sign or a single
        # quote
        #
        s/^\(\\*\)\1\\\([#']\)/\1\1\2/g
        s/\([^\\]\)\(\\*\)\1\\\([#']\)/\1\2\2\3/g

        b decode
    }

    # process a single-quoted value
    #
    /^'/ {
        :unfold1

        # reset the replacement test
        #
        t reset1
        :reset1

        # remove a trailing comment
        #
        s/\(.'[	 ]*\)#.*$/\1/
        t trim1

        # handle an extraneous quote
        #
        /.'[	 ]*[^	 ]/ {
            s/^.*$/6/
            b quit
        }

        # unfold lines within the value
        #
        /\\$/ {
            $ {
                s/^.*$/4/
                b quit
            }
            N
            s/\\\n//
            b unfold1
        }

        :trim1
        # remove trailing whitespace
        #
        s/[	 ]*$//

        # handle a missing closing quote
        #
        /'$/ !{
            s/^.*$/5/
            b quit
        }

        # remove the opening quote and the closing quote
        #
        s/^'\(.*\)'$/\1/

        b encode
    }

    # process a double-quoted value
    #
    /^"/ {
        :unfold2

        # reset the replacement test
        #
        t reset2
        :reset2

        # remove a trailing comment
        #
        s/\([^\\]\)\(\\*\)\2"[	 ]*#.*$/\1\2\2"/
        t trim2

        # handle an extraneous quote
        #
        /[^\\]\(\\*\)\1"[	 ]*[^	 ]/ {
            s/^.*$/9/
            b quit
        }

        # unfold lines within the value
        #
        /[^\\]\(\\*\)\1\\$/ {
            $ {
                s/^.*$/7/
                b quit
            }
            N
            s/\\\n//
            b unfold2
        }

        :trim2
        # remove trailing whitespace
        #
        s/[	 ]*$//

        # handle a missing closing quote
        #
        /"$/ !{
            s/^.*$/8/
            b quit
        }

        # remove the opening quote and the closing quote
        #
        s/^"\(.*\)"$/\1/

        b decode
    }
}


# process an assignment via here document ('<<' or '<<-')
#
/^[	 ]*[A-Za-z_][0-9A-Za-z\.\/:_-]*[	 ]*<</ {

    # copy the name into the hold space, removing extraneous whitespace
    # while retaining the operator
    #
    h
    s/^[	 ]*\([^	 <]*\).*$/\1/
    x
    s/^[^<]*\(<<.*\)$/\1/

    # process a null value
    #
    /^<<-\{0,1\}[	 ]*$/ b is_eof

    # process a value as an unindented here document
    #
    /^<<[^-]/ {

        # remove the operator
        #
        s/^<<[	 ]*\(.*\)$/\1/

        # add each line of the here document
        #
        :here0
        $ {
            s/^.*$/10/
            b quit
        }
        N
        /^\(.*\)\n.*\n\1$/ !{
            b here0
        }

        # remove the opening word, the final newline, and the closing
        # word
        #
        s/^\(.*\)\n\(.*\)\n\1$/\2/

        b encode
    }

    # process a value as an indented here document
    #
    /^<<-.*$/ {

        # remove the operator
        #
        s/^<<-[	 ]*\(.*\)$/\1/

        # add each line of the here document, removing leading tabs
        #
        :here1
        $ {
            s/^.*$/11/
            b quit
        }
        N
        s/^\(.*\n\)	*\(.*\)$/\1\2/
        /^\(.*\)\n.*\n\1$/ !{
            b here1
        }

        # remove the opening word, the final newline, and the closing
        # word
        #
        s/^\(.*\)\n\(.*\)\n\1$/\2/

        b encode
    }
}


# process an invalid line
#
h
s/^.*$/1/


# output the results of an invalid assignment and quit; the hold space should
# contain either a line with an invalid name or a valid name that was to be
# assigned an invalid value, and the pattern space should contain a status code
# that indicates the error
#
:quit
x
p
=
x
p
q


# decode the value; remove each backslash used to escape a double quote, a
# dollar sign, a grave accent, or another backslash
#
:decode
s/^\(\\*\)\1\\\(["$`]\)/\1\1\2/g
s/\([^\\]\)\(\\*\)\1\\\(["$`]\)/\1\2\2\3/g
s/\\\\/\\/g

# encode the value; add a backslash to escape each double quote, dollar sign,
# grave accent, and backslash; replace each newlin with the escape sequence '\n'
#
:encode
s/\\/\\\\/g
s/\(["$`]\)/\\\1/g
s/\n/\\n/g

# output the results of a valid assignment; the hold space contains the name,
# name, and the pattern space contains the encoded value
#
x
s/^\(.*\)$/\1=/
G
s/\n//
p


# determine if the last line was just processed; if so, output a status code
# that indicates success
#
:is_eof
$ {
    s/^.*$/0/
    p
}
