# from regex.h
REG_EXTENDED = 1
REG_ICASE = 2
REG_NEWLINE = 4
# /* POSIX 'cflags' bits (i.e., information for 'regcomp').  */
# /* If this bit is set, then use extended regular expression syntax.
#   If not set, then use basic regular expression syntax.  */
# #define REG_EXTENDED 1
# /* If this bit is set, then ignore case when matching.
#   If not set, then case is significant.  */
# #define REG_ICASE (1 << 1)
# /* If this bit is set, then anchors do not match at newline
#      characters in the string.
#   If not set, then anchors do match at newlines.  */
# #define REG_NEWLINE (1 << 2)

program_name = 'sed'
EOF = '<EOF>'  # XXX read https://softwareengineering.stackexchange.com/a/197629
NULL = None
