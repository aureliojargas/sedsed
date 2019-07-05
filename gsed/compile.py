#!/usr/bin/env python

import sys
from mydefs import *
from basicdefs_h import *
from sed_h import *
from utils_h import *
from utils_c import *

# TODO
# check: python3 -m pylint compile.py | grep redefined-outer-name

# WONTDO
#
# Check if command only accepts one address
# if (cur_cmd->a2) bad_prog (_(ONE_ADDR));
#
# Check if command is a GNU extension
# if (posixicity == POSIXLY_EXTENDED)
#
# Debug messages
# if (debug)


#define YMAP_LENGTH		256
#define VECTOR_ALLOC_INCREMENT	40
#define OPEN_BRACKET	'['
#define CLOSE_BRACKET	']'
#define OPEN_BRACE	'{'
#define CLOSE_BRACE	'}'
YMAP_LENGTH = 256
VECTOR_ALLOC_INCREMENT = 40
OPEN_BRACKET = '['
CLOSE_BRACKET = ']'
OPEN_BRACE = '{'
CLOSE_BRACE = '}'


# struct prog_info {
#   /* When we're reading a script command from a string, `prog.base'
#      points to the first character in the string, 'prog.cur' points
#      to the current character in the string, and 'prog.end' points
#      to the end of the string.  This allows us to compile script
#      strings that contain nulls. */
#   const unsigned char *base;
#   const unsigned char *cur;
#   const unsigned char *end;

#   /* This is the current script file.  If it is NULL, we are reading
#      from a string stored at `prog.cur' instead.  If both `prog.file'
#      and `prog.cur' are NULL, we're in trouble! */
#   FILE *file;
# };
class prog_info:
    base = None  # int
    cur = None  # int
    end = None  # int
    file = None  # file descriptor
    text = None  # str
    # Using None because some code checks for "is not None" to detect unset state


# Information used to give out useful and informative error messages.
# struct error_info {
#   /* This is the name of the current script file. */
#   const char *name;

#   /* This is the number of the current script line that we're compiling. */
#   countT line;

#   /* This is the index of the "-e" expressions on the command line. */
#   countT string_expr_count;
# };
class error_info:
    name = ''
    line = 0
    string_expr_count = 0


# Label structure used to resolve GOTO's, labels, and block beginnings.
# struct sed_label {
#   countT v_index;		/* index of vector element being referenced */
#   char *name;			/* NUL-terminated name of the label */
#   struct error_info err_info;	/* track where `{}' blocks start */
#   struct sed_label *next;	/* linked list (stack) */
# };

# struct special_files {
#   struct output outf;
#   FILE **pfp;
# };

# static FILE *my_stdin, *my_stdout, *my_stderr;
# static struct special_files special_files[] = {
#   { { (char *) "/dev/stdin", false, NULL, NULL }, &my_stdin },
#   { { (char *) "/dev/stdout", false, NULL, NULL }, &my_stdout },
#   { { (char *) "/dev/stderr", false, NULL, NULL }, &my_stderr },
#   { { NULL, false, NULL, NULL }, NULL }
# };

# Where we are in the processing of the input.
# static struct prog_info prog;
# static struct error_info cur_input;
class prog(prog_info):
    pass
class cur_input(error_info):
    pass

# /* Information about labels and jumps-to-labels.  This is used to do
#   the required backpatching after we have compiled all the scripts. */
# static struct sed_label *jumps = NULL;
# static struct sed_label *labels = NULL;
jumps = NULL
labels = NULL

# /* We wish to detect #n magic only in the first input argument;
#   this flag tracks when we have consumed the first file of input. */
# static bool first_script = true;
first_script = True

# Allow for scripts like "sed -e 'i\' -e foo":
# static struct buffer *pending_text = NULL;
# static struct text_buf *old_text_buf = NULL;
pending_text = NULL
old_text_buf = NULL

# /* Information about block start positions.  This is used to backpatch
#   block end positions. */
# static struct sed_label *blocks = NULL;
blocks = 0

# Use an obstack for compilation.
# static struct obstack obs;

# Various error messages we may want to print
# static const char errors[] =
#   "multiple `!'s\0"
#   "unexpected `,'\0"
#   "invalid usage of +N or ~N as first address\0"
#   "unmatched `{'\0"
#   "unexpected `}'\0"
#   "extra characters after command\0"
#   "expected \\ after `a', `c' or `i'\0"
#   "`}' doesn't want any addresses\0"
#   ": doesn't want any addresses\0"
#   "comments don't accept any addresses\0"
#   "missing command\0"
#   "command only uses one address\0"
#   "unterminated address regex\0"
#   "unterminated `s' command\0"
#   "unterminated `y' command\0"
#   "unknown option to `s'\0"
#   "multiple `p' options to `s' command\0"
#   "multiple `g' options to `s' command\0"
#   "multiple number options to `s' command\0"
#   "number option to `s' command may not be zero\0"
#   "strings for `y' command are different lengths\0"
#   "delimiter character is not a single-byte character\0"
#   "expected newer version of sed\0"
#   "invalid usage of line address 0\0"
#   "unknown command: `%c'\0"
#   "incomplete command\0"
#   "\":\" lacks a label\0"
#   "recursive escaping after \\c not allowed\0"
#   "e/r/w commands disabled in sandbox mode\0"
#   "missing filename in r/R/w/W commands";

# #define BAD_BANG (errors)
# #define BAD_COMMA (BAD_BANG + sizeof (N_("multiple `!'s")))
# #define BAD_STEP (BAD_COMMA + sizeof (N_("unexpected `,'")))
# #define EXCESS_OPEN_BRACE (BAD_STEP \
#   + sizeof (N_("invalid usage of +N or ~N as first address")))
# #define EXCESS_CLOSE_BRACE (EXCESS_OPEN_BRACE + sizeof (N_("unmatched `{'")))
# #define EXCESS_JUNK (EXCESS_CLOSE_BRACE + sizeof (N_("unexpected `}'")))
# #define EXPECTED_SLASH (EXCESS_JUNK \
#   + sizeof (N_("extra characters after command")))
# #define NO_CLOSE_BRACE_ADDR (EXPECTED_SLASH \
#   + sizeof (N_("expected \\ after `a', `c' or `i'")))
# #define NO_COLON_ADDR (NO_CLOSE_BRACE_ADDR \
#   + sizeof (N_("`}' doesn't want any addresses")))
# #define NO_SHARP_ADDR (NO_COLON_ADDR \
#   + sizeof (N_(": doesn't want any addresses")))
# #define NO_COMMAND (NO_SHARP_ADDR \
#   + sizeof (N_("comments don't accept any addresses")))
# #define ONE_ADDR (NO_COMMAND + sizeof (N_("missing command")))
# #define UNTERM_ADDR_RE (ONE_ADDR + sizeof (N_("command only uses one address")))
# #define UNTERM_S_CMD (UNTERM_ADDR_RE \
#   + sizeof (N_("unterminated address regex")))
# #define UNTERM_Y_CMD (UNTERM_S_CMD + sizeof (N_("unterminated `s' command")))
# #define UNKNOWN_S_OPT (UNTERM_Y_CMD + sizeof (N_("unterminated `y' command")))
# #define EXCESS_P_OPT (UNKNOWN_S_OPT + sizeof (N_("unknown option to `s'")))
# #define EXCESS_G_OPT (EXCESS_P_OPT \
#   + sizeof (N_("multiple `p' options to `s' command")))
# #define EXCESS_N_OPT (EXCESS_G_OPT \
#   + sizeof (N_("multiple `g' options to `s' command")))
# #define ZERO_N_OPT (EXCESS_N_OPT \
#   + sizeof (N_("multiple number options to `s' command")))
# #define Y_CMD_LEN (ZERO_N_OPT \
#   + sizeof (N_("number option to `s' command may not be zero")))
# #define BAD_DELIM (Y_CMD_LEN \
#   + sizeof (N_("strings for `y' command are different lengths")))
# #define ANCIENT_VERSION (BAD_DELIM \
#   + sizeof (N_("delimiter character is not a single-byte character")))
# #define INVALID_LINE_0 (ANCIENT_VERSION \
#   + sizeof (N_("expected newer version of sed")))
# #define UNKNOWN_CMD (INVALID_LINE_0 \
#   + sizeof (N_("invalid usage of line address 0")))
# #define INCOMPLETE_CMD (UNKNOWN_CMD + sizeof (N_("unknown command: `%c'")))
# #define COLON_LACKS_LABEL (INCOMPLETE_CMD \
#   + sizeof (N_("incomplete command")))
# #define RECURSIVE_ESCAPE_C (COLON_LACKS_LABEL \
#   + sizeof (N_("\":\" lacks a label")))
# #define DISALLOWED_CMD (RECURSIVE_ESCAPE_C \
#   + sizeof (N_("recursive escaping after \\c not allowed")))
# #define MISSING_FILENAME (DISALLOWED_CMD \
#   + sizeof (N_( "e/r/w commands disabled in sandbox mode")))
# /* #define END_ERRORS (DISALLOWED_CMD \
#      + sizeof (N_( "e/r/w commands disabled in sandbox mode"))) */

BAD_BANG = "multiple `!'s"
BAD_COMMA = "unexpected `,'"
BAD_STEP = "invalid usage of +N or ~N as first address"
EXCESS_OPEN_BRACE = "unmatched `{'"
EXCESS_CLOSE_BRACE = "unexpected `}'"
EXCESS_JUNK = "extra characters after command"
EXPECTED_SLASH = "expected \\ after `a', `c' or `i'"
NO_CLOSE_BRACE_ADDR = "`}' doesn't want any addresses"
NO_COLON_ADDR = ": doesn't want any addresses"
NO_SHARP_ADDR = "comments don't accept any addresses"
NO_COMMAND = "missing command"
ONE_ADDR = "command only uses one address"
UNTERM_ADDR_RE = "unterminated address regex"
UNTERM_S_CMD = "unterminated `s' command"
UNTERM_Y_CMD = "unterminated `y' command"
UNKNOWN_S_OPT = "unknown option to `s'"
EXCESS_P_OPT = "multiple `p' options to `s' command"
EXCESS_G_OPT = "multiple `g' options to `s' command"
EXCESS_N_OPT = "multiple number options to `s' command"
ZERO_N_OPT = "number option to `s' command may not be zero"
Y_CMD_LEN = "strings for `y' command are different lengths"
BAD_DELIM = "delimiter character is not a single-byte character"
ANCIENT_VERSION = "expected newer version of sed"
INVALID_LINE_0 = "invalid usage of line address 0"
UNKNOWN_CMD = "unknown command: `%c'"
INCOMPLETE_CMD = "incomplete command"
COLON_LACKS_LABEL = "\":\" lacks a label"
RECURSIVE_ESCAPE_C = "recursive escaping after \\c not allowed"
DISALLOWED_CMD = "e/r/w commands disabled in sandbox mode"
MISSING_FILENAME = "missing filename in r/R/w/W commands"

# static struct output *file_read = NULL;
# static struct output *file_write = NULL;

# Complain about an unknown command and exit.
def bad_command(ch):
    bad_prog(UNKNOWN_CMD % ch)
#---------------------------------------------------------------------
#   const char *msg = _(UNKNOWN_CMD);
#   char *unknown_cmd = xmalloc (strlen (msg));
#   sprintf (unknown_cmd, msg, ch);
#   bad_prog (unknown_cmd);

# Complain about a programming error and exit.
def bad_prog(why):
    if cur_input.name:
        msg = "%s: file %s line %d: %s" % (
            program_name, cur_input.name, cur_input.line, why)
    else:
        msg = "%s: -e expression #%d, char %d: %s" % (
            program_name, cur_input.string_expr_count, prog.cur - prog.base, why)
    print(msg, file=sys.stderr)
    sys.exit(EXIT_BAD_USAGE)
#---------------------------------------------------------------------
#   if (cur_input.name)
#     fprintf (stderr, _("%s: file %s line %lu: %s\n"), program_name,
#              cur_input.name, (unsigned long)cur_input.line, why);
#   else
#     fprintf (stderr, _("%s: -e expression #%lu, char %lu: %s\n"),
#              program_name,
#              (unsigned long)cur_input.string_expr_count,
#              (unsigned long)(prog.cur-prog.base),
#              why);
#   exit(EXIT_BAD_USAGE);


# /* Read the next character from the program.  Return EOF if there isn't
#   anything to read.  Keep cur_input.line up to date, so error messages
#   can be meaningful. */
def inchar():
    ch = EOF
    if prog.cur is not None:
        # print("inchar: %s < %s" % (prog.cur, prog.end))
        if prog.cur < prog.end:
            prog.cur += 1
            ch = prog.text[prog.cur]
    elif prog.file:
        # https://stackoverflow.com/a/15599780
        ch = prog.file.read(1)
        if not ch:
            ch = EOF
    if ch == '\n':
        cur_input.line += 1
    debug(ch)
    return ch
#---------------------------------------------------------------------
#   int ch = EOF;
#   if (prog.cur)
#     {
#       if (prog.cur < prog.end)
#         ch = *prog.cur++;
#     }
#   else if (prog.file)
#     {
#       if (!feof (prog.file))
#         ch = getc (prog.file);
#     }
#   if (ch == '\n')
#     ++cur_input.line;
#   return ch;


# unget `ch' so the next call to inchar will return it.
def savchar(ch):
    debug("savchar(%s)" % ch)
    if ch == EOF:
        return
    if ch == '\n' and cur_input.line > 0:
        cur_input.line -= 1
    if prog.cur:
        prog.cur -= 1
        if prog.cur <= prog.base or prog.text[prog.cur+1] != ch:  # XXX not sure about cur+1
            # panic ("Called savchar with unexpected pushback (%s)" % ch)
            panic ("Called savchar with unexpected pushback (curr=%s %s!=%s)" % (prog.cur, prog.text[prog.cur],ch))
    else:
        try:
            # Go back one position in prog.file file descriptor pointer
            prog.file.seek(prog.file.tell() - 1)  # ungetc (ch, prog.file)
        except ValueError:  # negative seek position -1
            pass
#---------------------------------------------------------------------
# #   if (ch == EOF)
#     return;
#   if (ch == '\n' && cur_input.line > 0)
#     --cur_input.line;
#   if (prog.cur)
#     {
#       if (prog.cur <= prog.base || *--prog.cur != ch)
#         panic ("Called savchar with unexpected pushback (%x)",
#               (unsigned int) ch);
#     }
#   else
#     ungetc (ch, prog.file);

# Read the next non-blank character from the program.
def in_nonblank():
    while True:
        ch = inchar()
        if not ISBLANK(ch):
            break
    return ch
#---------------------------------------------------------------------
#   int ch;
#   do
#     ch = inchar ();
#     while (ISBLANK (ch));
#   return ch;


# /* Consume script input until a valid end of command marker is found:
#      comment, closing brace, newline, semicolon or EOF.
#   If any other character is found, die with 'extra characters after command'
#   error.
# */
def read_end_of_cmd():
    ch = in_nonblank()
    if ch in (CLOSE_BRACE, '#'):
        savchar(ch)
    elif ch not in (EOF, '\n', ';'):
        bad_prog(EXCESS_JUNK)
#---------------------------------------------------------------------
#   const int ch = in_nonblank ();
#   if (ch == CLOSE_BRACE || ch == '#')
#     savchar (ch);
#   else if (ch != EOF && ch != '\n' && ch != ';')
#     bad_prog (_(EXCESS_JUNK));

# Read an integer value from the program.
def in_integer(ch):
    num = []
    while ISDIGIT(ch):
        num.append(ch)
        ch = inchar()
    savchar(ch)
    return int(''.join(num))
#---------------------------------------------------------------------
#   countT num = 0;
#   while (ISDIGIT (ch))
#     {
#       num = num * 10 + ch - '0';
#       ch = inchar ();
#     }
#   savchar (ch);
#   return num;

def add_then_next(buffer, ch):
    add1_buffer(buffer, ch)
    return inchar()
#---------------------------------------------------------------------
# add_then_next (struct buffer *b, int ch)
# {
#   add1_buffer (b, ch);
#   return inchar ();
# }

# static char *
# convert_number (char *result, char *buf, const char *bufend, int base)
# {
#   int n = 0;
#   int max = 1;
#   char *p;

#   for (p=buf+1; p < bufend && max <= 255; ++p, max *= base)
#     {
#       int d = -1;
#       switch (*p)
#         {
#         case '0': d = 0x0; break;
#         case '1': d = 0x1; break;
#         case '2': d = 0x2; break;
#         case '3': d = 0x3; break;
#         case '4': d = 0x4; break;
#         case '5': d = 0x5; break;
#         case '6': d = 0x6; break;
#         case '7': d = 0x7; break;
#         case '8': d = 0x8; break;
#         case '9': d = 0x9; break;
#         case 'A': case 'a': d = 0xa; break;
#         case 'B': case 'b': d = 0xb; break;
#         case 'C': case 'c': d = 0xc; break;
#         case 'D': case 'd': d = 0xd; break;
#         case 'E': case 'e': d = 0xe; break;
#         case 'F': case 'f': d = 0xf; break;
#         }
#       if (d < 0 || base <= d)
#         break;
#       n = n * base + d;
#     }
#   if (p == buf+1)
#     *result = *buf;
#   else
#     *result = n;
#   return p;
# }

# Read in a filename for a `r', `w', or `s///w' command.
def read_filename():
    b = init_buffer()
    ch = in_nonblank()
    while ch not in (EOF, '\n'):
        ch = add_then_next(b, ch)
    # add1_buffer(b, '\0');  # not necessary in Python
    return b
#---------------------------------------------------------------------
#   struct buffer *b;
#   int ch;
#
#   if (sandbox)
#     bad_prog (_(DISALLOWED_CMD));
#
#   b = init_buffer ();
#   ch = in_nonblank ();
#   while (ch != EOF && ch != '\n')
#     {
# #if 0 /*XXX ZZZ 1998-09-12 kpp: added, then had second thoughts*/
#       if (posixicity == POSIXLY_EXTENDED)
#         if (ch == ';' || ch == '#')
#           {
#             savchar (ch);
#             break;
#           }
# #endif
#       ch = add_then_next (b, ch);
#     }
#   add1_buffer (b, '\0');
#   return b;


#def get_openfile(file_ptrs, mode, fail);
#    struct output *p
#
#    b = read_filename()
#    file_name = get_buffer(b)
#    if len(file_name) == 0:
#        bad_prog(_(MISSING_FILENAME))
#
#    free_buffer(b)
#    return p
#---------------------------------------------------------------------
# get_openfile (struct output **file_ptrs, const char *mode, int fail)
# {
#   struct buffer *b;
#   char *file_name;
#   struct output *p;
#
#   b = read_filename ();
#   file_name = get_buffer (b);
#   if (strlen (file_name) == 0)
#     bad_prog (_(MISSING_FILENAME));
#
#   for (p=*file_ptrs; p; p=p->link)
#     if (strcmp (p->name, file_name) == 0)
#       break;
#
#   if (posixicity == POSIXLY_EXTENDED)
#     {
#       /* Check whether it is a special file (stdin, stdout or stderr) */
#       struct special_files *special = special_files;
#
#       /* std* sometimes are not constants, so they
#          cannot be used in the initializer for special_files */
#       my_stdin = stdin; my_stdout = stdout; my_stderr = stderr;
#       for (special = special_files; special->outf.name; special++)
#         if (strcmp (special->outf.name, file_name) == 0)
#           {
#             special->outf.fp = *special->pfp;
#             free_buffer (b);
#             return &special->outf;
#           }
#     }
#
#   if (!p)
#     {
#       p = OB_MALLOC (&obs, 1, struct output);
#       p->name = xstrdup (file_name);
#       p->fp = ck_fopen (p->name, mode, fail);
#       p->missing_newline = false;
#       p->link = *file_ptrs;
#       *file_ptrs = p;
#     }
#   free_buffer (b);
#   return p;
# }


def next_cmd_entry(vector):
    cmd = struct_sed_cmd()
    cmd.a1 = NULL
    cmd.a2 = NULL
    cmd.range_state = RANGE_INACTIVE
    cmd.addr_bang = False
    cmd.cmd = '\0'  # something invalid, to catch bugs early
    vector.append(cmd)
    return cmd
#---------------------------------------------------------------------
# next_cmd_entry (struct vector **vectorp)
# {
#   struct sed_cmd *cmd;
#   struct vector *v;
#
#   v = *vectorp;
#   if (v->v_length == v->v_allocated)
#     {
#       v->v_allocated += VECTOR_ALLOC_INCREMENT;
#       v->v = REALLOC (v->v, v->v_allocated, struct sed_cmd);
#     }
#
#   cmd = v->v + v->v_length;
#   cmd->a1 = NULL;
#   cmd->a2 = NULL;
#   cmd->range_state = RANGE_INACTIVE;
#   cmd->addr_bang = false;
#   cmd->cmd = '\0';	/* something invalid, to catch bugs early */
#
#   *vectorp  = v;
#   return cmd;
# }


def snarf_char_class(b):  #, cur_stat):
    state = 0
    delim = None  # delim IF_LINT( = 0)

    ch = inchar()
    if ch == '^':
        ch = add_then_next(b, ch)
    if ch == CLOSE_BRACKET:
        ch = add_then_next(b, ch)

    # States are:
    #   0 outside a collation element, character class or collation class
    #   1 after the bracket
    #   2 after the opening ./:/=
    #   3 after the closing ./:/=

    # for (;; ch = add_then_next(b, ch)) {
    while True:
        ch = add_then_next(b, ch)
        mb_char = IS_MB_CHAR(ch)  #, cur_stat)

        if ch in (EOF, '\n'):
            return ch

        elif ch in '.:=':
            if mb_char:
                continue

            if state == 1:
                delim = ch
                state = 2
            elif state == 2 and ch == delim:
                state = 3
            # else:
            #     break  # break from C-switch

            continue

        elif ch == OPEN_BRACKET:
            if mb_char:
                continue

            if state == 0:
                state = 1
            continue

        elif ch == CLOSE_BRACKET:
            if mb_char:
                continue

            if state in (0, 1):
                return ch
            elif state == 3:
                state = 0

        # Getting a character different from .=: whilst in state 1
        # goes back to state 0, getting a character different from ]
        # whilst in state 3 goes back to state 2.
        if ch not in '.:=' and state == 1:
            state = 0
        elif ch != CLOSE_BRACKET and state == 3:
            state = 2

        # state &= ~1  # please, no magic
#---------------------------------------------------------------------
# snarf_char_class (struct buffer *b, mbstate_t *cur_stat)
# {
#   int ch;
#   int state = 0;
#   int delim IF_LINT ( = 0) ;
#
#   ch = inchar ();
#   if (ch == '^')
#     ch = add_then_next (b, ch);
#   if (ch == CLOSE_BRACKET)
#     ch = add_then_next (b, ch);
#
#   /* States are:
#         0 outside a collation element, character class or collation class
#         1 after the bracket
#         2 after the opening ./:/=
#         3 after the closing ./:/= */
#
#   for (;; ch = add_then_next (b, ch))
#     {
#       const int mb_char = IS_MB_CHAR (ch, cur_stat);
#
#       switch (ch)
#         {
#         case EOF:
#         case '\n':
#           return ch;
#
#         case '.':
#         case ':':
#         case '=':
#           if (mb_char)
#             continue;
#
#           if (state == 1)
#             {
#               delim = ch;
#               state = 2;
#             }
#           else if (state == 2 && ch == delim)
#             state = 3;
#           else
#             break;
#
#           continue;
#
#         case OPEN_BRACKET:
#           if (mb_char)
#             continue;
#
#           if (state == 0)
#             state = 1;
#           continue;
#
#         case CLOSE_BRACKET:
#           if (mb_char)
#             continue;
#
#           if (state == 0 || state == 1)
#             return ch;
#           else if (state == 3)
#             state = 0;
#
#           break;
#
#         default:
#           break;
#         }
#
#       /* Getting a character different from .=: whilst in state 1
#          goes back to state 0, getting a character different from ]
#          whilst in state 3 goes back to state 2.  */
#       state &= ~1;
#     }
# }


def match_slash(slash, regex):  # char, bool
    # struct buffer *b
    # mbstate_t cur_stat = { 0, }

    # We allow only 1 byte characters for a slash.
    if IS_MB_CHAR(slash):  #, &cur_stat):
        bad_prog(BAD_DELIM)

    # memset(&cur_stat, 0, sizeof cur_stat)

    b = init_buffer()

    # while ((ch = inchar ()) != EOF && ch != '\n')
    while True:
        ch = inchar()
        if ch in (EOF, '\n'):
            break

        # const mb_char = IS_MB_CHAR(ch, &cur_stat)

        if not IS_MB_CHAR(ch):
            if ch == slash:
                return b
            elif ch == '\\':
                ch = inchar()
                if ch == EOF:
                    break
                elif ch == 'n' and regex:
                    ch = '\n'
                elif (ch != '\n' and (ch != slash or (not regex and ch == '&'))):
                    add1_buffer(b, '\\')
            elif ch == OPEN_BRACKET and regex:
                add1_buffer(b, ch)
                ch = snarf_char_class(b)  #, &cur_stat)
                if ch != CLOSE_BRACKET:
                    break

        add1_buffer(b, ch)

    if ch == '\n':
        savchar(ch)  # for proper line number in error report
    free_buffer(b)
    return NULL
#---------------------------------------------------------------------
# static struct buffer *
# match_slash (int slash, int regex)
# {
#   struct buffer *b;
#   int ch;
#   mbstate_t cur_stat = { 0, };
#
#   /* We allow only 1 byte characters for a slash.  */
#   if (IS_MB_CHAR (slash, &cur_stat))
#     bad_prog (BAD_DELIM);
#
#   memset (&cur_stat, 0, sizeof cur_stat);
#
#   b = init_buffer ();
#   while ((ch = inchar ()) != EOF && ch != '\n')
#     {
#       const int mb_char = IS_MB_CHAR (ch, &cur_stat);
#
#       if (!mb_char)
#         {
#           if (ch == slash)
#             return b;
#           else if (ch == '\\')
#             {
#               ch = inchar ();
#               if (ch == EOF)
#                 break;
#               else if (ch == 'n' && regex)
#                 ch = '\n';
#               else if (ch != '\n' && (ch != slash || (!regex && ch == '&')))
#                 add1_buffer (b, '\\');
#             }
#           else if (ch == OPEN_BRACKET && regex)
#             {
#               add1_buffer (b, ch);
#               ch = snarf_char_class (b, &cur_stat);
#               if (ch != CLOSE_BRACKET)
#                 break;
#             }
#         }
#
#       add1_buffer (b, ch);
#     }
#
#   if (ch == '\n')
#     savchar (ch);	/* for proper line number in error report */
#   free_buffer (b);
#   return NULL;
# }


def mark_subst_opts():
    flags = []
    numb = False

    while True:
        ch = in_nonblank()

        if ch in 'iImMe':  # GNU extensions
            flags.append(ch)

        elif ch == 'p':
            if ch in flags:
                bad_prog(EXCESS_P_OPT)
            flags.append(ch)

        elif ch == 'g':
            if ch in flags:
                bad_prog(EXCESS_G_OPT)
            flags.append(ch)

        elif ch in '0123456789':
            if numb:
                bad_prog(EXCESS_N_OPT)
            n = in_integer(ch)
            if int(n) == 0:
                bad_prog(ZERO_N_OPT)
            flags.append(n)
            numb = True

        elif ch == 'w':
            b = read_filename()
            if not b:
                bad_prog(MISSING_FILENAME)
            flags.append("%s %s" % (ch, ''.join(b)))

        elif ch == '#':
            savchar(ch)
            return flags

        elif ch == CLOSE_BRACE:
            savchar(ch)
            return flags

        elif ch in (EOF, '\n', ';'):
            return flags

        elif ch == '\r':
            if inchar() == '\n':
                return flags
            bad_prog(UNKNOWN_S_OPT)

        else:
            bad_prog(UNKNOWN_S_OPT)
         #NOTREACHED
#---------------------------------------------------------------------
# mark_subst_opts (struct subst *cmd)
# {
#   int flags = 0;
#   int ch;
#
#   cmd->global = false;
#   cmd->print = false;
#   cmd->eval = false;
#   cmd->numb = 0;
#   cmd->outf = NULL;
#
#   for (;;)
#     switch ( (ch = in_nonblank ()) )
#       {
#       case 'i':	/* GNU extension */
#       case 'I':	/* GNU extension */
#         if (posixicity == POSIXLY_BASIC)
#           bad_prog (_(UNKNOWN_S_OPT));
#         flags |= REG_ICASE;
#         break;
#
#       case 'm':	/* GNU extension */
#       case 'M':	/* GNU extension */
#         if (posixicity == POSIXLY_BASIC)
#           bad_prog (_(UNKNOWN_S_OPT));
#         flags |= REG_NEWLINE;
#         break;
#
#       case 'e':
#         if (posixicity == POSIXLY_BASIC)
#           bad_prog (_(UNKNOWN_S_OPT));
#         cmd->eval = true;
#         break;
#
#       case 'p':
#         if (cmd->print)
#           bad_prog (_(EXCESS_P_OPT));
#         cmd->print |= (1 << cmd->eval); /* 1=before eval, 2=after */
#         break;
#
#       case 'g':
#         if (cmd->global)
#           bad_prog (_(EXCESS_G_OPT));
#         cmd->global = true;
#         break;
#
#       case 'w':
#         cmd->outf = get_openfile (&file_write, write_mode, true);
#         return flags;
#
#       case '0': case '1': case '2': case '3': case '4':
#       case '5': case '6': case '7': case '8': case '9':
#         if (cmd->numb)
#           bad_prog (_(EXCESS_N_OPT));
#         cmd->numb = in_integer (ch);
#         if (!cmd->numb)
#           bad_prog (_(ZERO_N_OPT));
#         break;
#
#       case CLOSE_BRACE:
#       case '#':
#         savchar (ch);
#         FALLTHROUGH;
#       case EOF:
#       case '\n':
#       case ';':
#         return flags;
#
#       case '\r':
#         if (inchar () == '\n')
#           return flags;
#         FALLTHROUGH;
#
#       default:
#         bad_prog (_(UNKNOWN_S_OPT));
#         /*NOTREACHED*/
#       }
# }

# read in a label for a `:', `b', or `t' command
def read_label():
    b = init_buffer()
    ch = in_nonblank()

    while ch != EOF and ch != '\n' and not ISBLANK (ch) and ch != ';' and ch != CLOSE_BRACE and ch != '#':
        ch = add_then_next(b, ch)

    savchar(ch)
    # add1_buffer(b, '\0')  # not necessary in Python
    ret = ''.join(b)
    free_buffer(b)
    return ret
#---------------------------------------------------------------------
#   struct buffer *b;
#   int ch;
#   char *ret;
#
#   b = init_buffer ();
#   ch = in_nonblank ();
#
#   while (ch != EOF && ch != '\n'
#          && !ISBLANK (ch) && ch != ';' && ch != CLOSE_BRACE && ch != '#')
#     ch = add_then_next (b, ch);
#
#   savchar (ch);
#   add1_buffer (b, '\0');
#   ret = xstrdup (get_buffer (b));
#   free_buffer (b);
#   return ret;


# /* Store a label (or label reference) created by a `:', `b', or `t'
#   command so that the jump to/from the label can be backpatched after
#   compilation is complete, or a reference created by a `{' to be
#   backpatched when the corresponding `}' is found.  */
# static struct sed_label *
# setup_label (struct sed_label *list, countT idx, char *name,
#              const struct error_info *err_info)
# {
#   struct sed_label *ret = OB_MALLOC (&obs, 1, struct sed_label);
#   ret->v_index = idx;
#   ret->name = name;
#   if (err_info)
#     memcpy (&ret->err_info, err_info, sizeof (ret->err_info));
#   ret->next = list;
#   return ret;
# }


# static struct sed_label *
# release_label (struct sed_label *list_head)
# {
#   struct sed_label *ret;
#
#   if (!list_head)
#     return NULL;
#   ret = list_head->next;
#
#   free (list_head->name);
#
# #if 0
#   /* We use obstacks */
#   free (list_head);
# #endif
#   return ret;
# }


# static struct replacement *
# new_replacement (char *text, size_t length, enum replacement_types type)
# {
#   struct replacement *r = OB_MALLOC (&obs, 1, struct replacement);
#
#   r->prefix = text;
#   r->prefix_length = length;
#   r->subst_id = -1;
#   r->repl_type = type;
#
#   /* r-> next = NULL; */
#   return r;
# }

# static void
# setup_replacement (struct subst *sub, const char *text, size_t length)
# {
#   char *base;
#   char *p;
#   char *text_end;
#   enum replacement_types repl_type = REPL_ASIS, save_type = REPL_ASIS;
#   struct replacement root;
#   struct replacement *tail;
#
#   sub->max_id = 0;
#   base = MEMDUP (text, length, char);
#   length = normalize_text (base, length, TEXT_REPLACEMENT);
#
#   IF_LINT (sub->replacement_buffer = base);
#
#   text_end = base + length;
#   tail = &root;
#
#   for (p=base; p<text_end; ++p)
#     {
#       if (*p == '\\')
#         {
#           /* Preceding the backslash may be some literal text: */
#           tail = tail->next =
#             new_replacement (base, (size_t)(p - base), repl_type);
#
#           repl_type = save_type;
#
#           /* Skip the backslash and look for a numeric back-reference,
#              or a case-munging escape if not in POSIX mode: */
#           ++p;
#           if (p == text_end)
#             ++tail->prefix_length;
#
#           else if (posixicity == POSIXLY_BASIC && !ISDIGIT (*p))
#             {
#               p[-1] = *p;
#               ++tail->prefix_length;
#             }
#
#           else
#             switch (*p)
#               {
#               case '0': case '1': case '2': case '3': case '4':
#               case '5': case '6': case '7': case '8': case '9':
#                 tail->subst_id = *p - '0';
#                 if (sub->max_id < tail->subst_id)
#                   sub->max_id = tail->subst_id;
#                 break;
#
#               case 'L':
#                 repl_type = REPL_LOWERCASE;
#                 save_type = REPL_LOWERCASE;
#                 break;
#
#               case 'U':
#                 repl_type = REPL_UPPERCASE;
#                 save_type = REPL_UPPERCASE;
#                 break;
#
#               case 'E':
#                 repl_type = REPL_ASIS;
#                 save_type = REPL_ASIS;
#                 break;
#
#               case 'l':
#                 save_type = repl_type;
#                 repl_type |= REPL_LOWERCASE_FIRST;
#                 break;
#
#               case 'u':
#                 save_type = repl_type;
#                 repl_type |= REPL_UPPERCASE_FIRST;
#                 break;
#
#               default:
#                 p[-1] = *p;
#                 ++tail->prefix_length;
#               }
#
#           base = p + 1;
#         }
#       else if (*p == '&')
#         {
#           /* Preceding the ampersand may be some literal text: */
#           tail = tail->next =
#             new_replacement (base, (size_t)(p - base), repl_type);
#
#           repl_type = save_type;
#           tail->subst_id = 0;
#           base = p + 1;
#         }
#   }
#   /* There may be some trailing literal text: */
#   if (base < text_end)
#     tail = tail->next =
#       new_replacement (base, (size_t)(text_end - base), repl_type);
#
#   tail->next = NULL;
#   sub->replacement = root.next;
# }


def read_text(buf, leadin_ch):
    global pending_text
    global old_text_buf

    if buf:
        if pending_text:
            free_buffer(pending_text)
        pending_text = init_buffer()
        buf.text = []
        buf.text_length = 0
        old_text_buf = buf

    if leadin_ch == EOF:
        return

    if leadin_ch != '\n':
        add1_buffer(pending_text, leadin_ch)

    ch = inchar()
    while ch not in (EOF, '\n'):
        if ch == '\\':
            ch = inchar()
            if ch != EOF:
                add1_buffer(pending_text, '\\')

        if ch == EOF:
            add1_buffer(pending_text, '\n')
            return

        ch = add_then_next(pending_text, ch)

    add1_buffer(pending_text, '\n')

    if not buf:
        buf = old_text_buf
    # buf.text_length = normalize_text(get_buffer (pending_text),
    #                                  size_buffer (pending_text), TEXT_BUFFER)
    buf.text = pending_text
    free_buffer(pending_text)
    pending_text = NULL
#---------------------------------------------------------------------
# read_text (struct text_buf *buf, int leadin_ch)
# {
#   int ch;
#
#   /* Should we start afresh (as opposed to continue a partial text)? */
#   if (buf)
#     {
#       if (pending_text)
#         free_buffer (pending_text);
#       pending_text = init_buffer ();
#       buf->text = NULL;
#       buf->text_length = 0;
#       old_text_buf = buf;
#     }
#   /* assert(old_text_buf != NULL); */
#
#   if (leadin_ch == EOF)
#     return;
#
#   if (leadin_ch != '\n')
#     add1_buffer (pending_text, leadin_ch);
#
#   ch = inchar ();
#   while (ch != EOF && ch != '\n')
#     {
#       if (ch == '\\')
#         {
#           ch = inchar ();
#           if (ch != EOF)
#             add1_buffer (pending_text, '\\');
#         }
#
#       if (ch == EOF)
#         {
#           add1_buffer (pending_text, '\n');
#           return;
#         }
#
#       ch = add_then_next (pending_text, ch);
#     }
#
#   add1_buffer (pending_text, '\n');
#   if (!buf)
#     buf = old_text_buf;
#   buf->text_length = normalize_text (get_buffer (pending_text),
#                                      size_buffer (pending_text), TEXT_BUFFER);
#   buf->text = MEMDUP (get_buffer (pending_text), buf->text_length, char);
#   free_buffer (pending_text);
#   pending_text = NULL;
# }


# Try to read an address for a sed command.  If it succeeds,
#   return non-zero and store the resulting address in `*addr'.
#   If the input doesn't look like an address read nothing
#   and return zero.
def compile_address(addr, ch):  # struct_addr, str
    addr.addr_type = ADDR_IS_NULL
    addr.addr_step = 0
    addr.addr_number = 0      # extremely unlikely to ever match
    addr.addr_regex = NULL

    if ch in ('/', '\\'):
        # Instead of using bit flags as regex.c, I'll just save the flags as text
        flags = []
        # flags = 0
        # struct buffer *b

        addr.addr_type = ADDR_IS_REGEX
        if ch == '\\':
            ch = inchar()
        b = match_slash(ch, True)
        if not b:
            bad_prog(UNTERM_ADDR_RE)

        while True:
            ch = in_nonblank()
            # if posixicity == POSIXLY_BASIC:
            #     goto posix_address_modifier
            if ch == 'I':  # GNU extension
                # flags |= REG_ICASE
                flags.append(ch)
            elif ch == 'M':  # GNU extension
                # flags |= REG_NEWLINE
                flags.append(ch)
            else:
            #   posix_address_modifier:  # GOTO label
                savchar(ch)
                addr.addr_regex = compile_regex(b, flags)
                free_buffer(b)
                return True

    elif ISDIGIT(ch):
        addr.addr_number = in_integer(ch)
        addr.addr_type = ADDR_IS_NUM
        ch = in_nonblank()
        if ch != '~':  # or posixicity == POSIXLY_BASIC:
            savchar(ch)
        else:
            step = in_integer(in_nonblank())
            if step > 0:
                addr.addr_step = step
                addr.addr_type = ADDR_IS_NUM_MOD

    elif ch in '+~':  #and posixicity != POSIXLY_BASIC:
        addr.addr_step = in_integer(in_nonblank())
        if addr.addr_step == 0:
            pass  # default to ADDR_IS_NULL; forces matching to stop on next line
        elif ch == '+':
            addr.addr_type = ADDR_IS_STEP
        else:
            addr.addr_type = ADDR_IS_STEP_MOD

    elif ch == '$':
        addr.addr_type = ADDR_IS_LAST

    else:
        return False
    return True
#---------------------------------------------------------------------
# static bool
# compile_address (struct addr *addr, int ch)
# {
#   addr->addr_type = ADDR_IS_NULL;
#   addr->addr_step = 0;
#   addr->addr_number = ~(countT)0;  /* extremely unlikely to ever match */
#   addr->addr_regex = NULL;
#
#   if (ch == '/' || ch == '\\')
#     {
#       int flags = 0;
#       struct buffer *b;
#       addr->addr_type = ADDR_IS_REGEX;
#       if (ch == '\\')
#         ch = inchar ();
#       if ( !(b = match_slash (ch, true)) )
#         bad_prog (_(UNTERM_ADDR_RE));
#
#       for (;;)
#         {
#           ch = in_nonblank ();
#           if (posixicity == POSIXLY_BASIC)
#             goto posix_address_modifier;
#           switch (ch)
#             {
#             case 'I':	/* GNU extension */
#               flags |= REG_ICASE;
#               break;
#
#             case 'M':	/* GNU extension */
#               flags |= REG_NEWLINE;
#               break;
#
#             default:
#             posix_address_modifier:
#               savchar (ch);
#               addr->addr_regex = compile_regex (b, flags, 0);
#               free_buffer (b);
#               return true;
#             }
#         }
#     }
#   else if (ISDIGIT (ch))
#     {
#       addr->addr_number = in_integer (ch);
#       addr->addr_type = ADDR_IS_NUM;
#       ch = in_nonblank ();
#       if (ch != '~' || posixicity == POSIXLY_BASIC)
#         {
#           savchar (ch);
#         }
#       else
#         {
#           countT step = in_integer (in_nonblank ());
#           if (step > 0)
#             {
#               addr->addr_step = step;
#               addr->addr_type = ADDR_IS_NUM_MOD;
#             }
#         }
#     }
#   else if ((ch == '+' || ch == '~') && posixicity != POSIXLY_BASIC)
#     {
#       addr->addr_step = in_integer (in_nonblank ());
#       if (addr->addr_step==0)
#         ; /* default to ADDR_IS_NULL; forces matching to stop on next line */
#       else if (ch == '+')
#         addr->addr_type = ADDR_IS_STEP;
#       else
#         addr->addr_type = ADDR_IS_STEP_MOD;
#     }
#   else if (ch == '$')
#     {
#       addr->addr_type = ADDR_IS_LAST;
#     }
#   else
#     return false;
#
#   return true;
# }


# Read a program (or a subprogram within `{' `}' pairs) in and store
# the compiled form in `*vector'.  Return a pointer to the new vector.
def compile_program(vector):
    global blocks

    if not vector:
        vector = []
    if pending_text:
        read_text(NULL, '\n')

    while True:

        a = struct_addr()

        while True:
            ch = inchar()
            if ch != ';' and not ISSPACE(ch):
                break

        if ch == EOF:
            break

        cur_cmd = next_cmd_entry(vector)

        if compile_address(a, ch):
            if a.addr_type == ADDR_IS_STEP or a.addr_type == ADDR_IS_STEP_MOD:
                bad_prog(BAD_STEP)

            cur_cmd.a1 = a  # MEMDUP(&a, 1, struct addr)
            print("----- Found address 1: %r" % cur_cmd.a1)


            a = struct_addr()  # reset a
            ch = in_nonblank()
            if ch == ',':
                if not compile_address(a, in_nonblank()):
                    bad_prog(BAD_COMMA)

                cur_cmd.a2 = a  # MEMDUP(&a, 1, struct addr)
                print("----- Found address 2: %r" % cur_cmd.a2)
                ch = in_nonblank()

            if (cur_cmd.a1.addr_type == ADDR_IS_NUM and cur_cmd.a1.addr_number == 0) \
                    and (not cur_cmd.a2 or cur_cmd.a2.addr_type != ADDR_IS_REGEX):
                    #or posixicity == POSIXLY_BASIC)):
                bad_prog(INVALID_LINE_0)

        if ch == '!':
            cur_cmd.addr_bang = True
            print("----- Found negation: !")
            ch = in_nonblank()
            if ch == '!':
                bad_prog(BAD_BANG)

        # Do not accept extended commands in --posix mode.  Also,
        # a few commands only accept one address in that mode.
        # SKIPPED

        cur_cmd.cmd = ch
        print("----- Found command: %r" % ch)

        if ch == '#':
            # if (cur_cmd->a1)
            #     bad_prog (_(NO_SHARP_ADDR));

            ## I think I won't need this #n detection
            # ch = inchar()
            # if ch == 'n' and first_script and cur_input.line < 2:
            #     if (prog.base and prog.cur == 2 + prog.base):
            #     # or (prog.file and not prog.base and 2 == ftell(prog.file)):
            #       no_default_output = true

            # GNU sed discards the comment contents, but I must save it
            # Using read_filename because it's the same logic of reading until \n or EOF
            b = read_filename()
            print("comment: %r" % ''.join(b))
            free_buffer(b)
            # while ch != EOF and ch != '\n':
            #     ch = inchar()
            continue  # redundant

        elif ch == '{':
            blocks += 1
            cur_cmd.addr_bang = not cur_cmd.addr_bang

        elif ch == '}':
            if not blocks:
                bad_prog(EXCESS_CLOSE_BRACE)
            if cur_cmd.a1:
                bad_prog(NO_CLOSE_BRACE_ADDR)

            read_end_of_cmd()
            blocks -= 1  # done with this entry

        elif ch in 'ev':
            argument = read_label()
            print("argument: %s" % argument)

        elif ch in 'aic':
            ch = in_nonblank()

#GOTO read_text_to_slash:
            if ch == EOF:
                bad_prog(EXPECTED_SLASH)

            if ch == '\\':
                ch = inchar()
            else:
                # if posixicity == POSIXLY_BASIC:
                #     bad_prog(EXPECTED_SLASH)
                savchar(ch)
                ch = '\n'

            read_text(cur_cmd.x.cmd_txt, ch)
            print("text: %s" % cur_cmd.x.cmd_txt)
#ENDGOTO

        elif ch in ':Tbt':
#           if (cur_cmd->a1)
#             bad_prog (_(NO_COLON_ADDR));
            label = read_label()
            print("label: %s" % label)
            if not label:
                bad_prog(COLON_LACKS_LABEL)
            # labels = setup_label (labels, vector->v_length, label, NULL);

        elif ch in 'QqLl':
            ch = in_nonblank()
            if ISDIGIT(ch):
                cur_cmd.x.int_arg = in_integer(ch)
                print("int_arg: %s" % in_integer(ch))
            else:
                cur_cmd.x.int_arg = -1
                print("int_arg: -1")
                savchar(ch)
            read_end_of_cmd()

        elif ch in '=dDFgGhHnNpPzx':
            read_end_of_cmd()

        elif ch in 'rRwW':
            b = read_filename()
            if not b:
                bad_prog(MISSING_FILENAME)
            cur_cmd.x.fname = ''.join(b)
            print("filename: %s" % cur_cmd.x.fname)
            free_buffer(b)

        elif ch == 's':
            slash = inchar()
            b = match_slash(slash, True)
            if not b:
                bad_prog(UNTERM_S_CMD)
            print("s pattern: %s" % ''.join(b))

            b2 = match_slash(slash, False)
            if not b2:
                bad_prog(UNTERM_S_CMD)
            print("s replacement: %s" % ''.join(b2))

            # setup_replacement(cur_cmd.x.cmd_subst, b2)
            free_buffer(b2)

            flags = mark_subst_opts()  #cur_cmd.x.cmd_subst)
            print("s flags: %s" % ''.join(flags))
            # cur_cmd.x.cmd_subst.regx = compile_regex(b, flags, cur_cmd.x.cmd_subst.max_id + 1)
            free_buffer(b)

            # if cur_cmd.x.cmd_subst.eval and sandbox:
            #     bad_prog(_(DISALLOWED_CMD))

        elif ch == 'y':
            slash = inchar()
            b = match_slash(slash, False)
            if not b:
                bad_prog(UNTERM_Y_CMD)
            print("y pattern: %s" % ''.join(b))

            b2 = match_slash(slash, False)
            if not b2:
                bad_prog(UNTERM_Y_CMD)
            print("y replacement: %s" % ''.join(b2))

            # sedsed doesn't need to check this
            # if len(normalize_text(b)) != len(normalize_text(b2)):
            #     bad_prog(Y_CMD_LEN)

            read_end_of_cmd()
            free_buffer(b)
            free_buffer(b2)

        elif ch == EOF:
            bad_prog(NO_COMMAND)
            # /*NOTREACHED*/
        else:
            bad_command(ch)
            # /*NOTREACHED*/
        vector.append(cur_cmd)
    # no return, vector edited in place
#---------------------------------------------------------------------
#   struct sed_cmd *cur_cmd;
#   struct buffer *b;
#   int ch;
#
#   if (!vector)
#     {
#       vector = XCALLOC (1, struct vector);
#       vector->v = NULL;
#       vector->v_allocated = 0;
#       vector->v_length = 0;
#
#       obstack_init (&obs);
#     }
#   if (pending_text)
#     read_text (NULL, '\n');
#
#   for (;;)
#     {
#       struct addr a;
#
#       while ((ch=inchar ()) == ';' || ISSPACE (ch))
#         ;
#       if (ch == EOF)
#         break;
#
#       cur_cmd = next_cmd_entry (&vector);
#       if (compile_address (&a, ch))
#         {
#           if (a.addr_type == ADDR_IS_STEP
#               || a.addr_type == ADDR_IS_STEP_MOD)
#             bad_prog (_(BAD_STEP));
#
#           cur_cmd->a1 = MEMDUP (&a, 1, struct addr);
#           ch = in_nonblank ();
#           if (ch == ',')
#             {
#               if (!compile_address (&a, in_nonblank ()))
#                 bad_prog (_(BAD_COMMA));
#
#               cur_cmd->a2 = MEMDUP (&a, 1, struct addr);
#               ch = in_nonblank ();
#             }
#
#           if ((cur_cmd->a1->addr_type == ADDR_IS_NUM
#               && cur_cmd->a1->addr_number == 0)
#               && ((!cur_cmd->a2 || cur_cmd->a2->addr_type != ADDR_IS_REGEX)
#                   || posixicity == POSIXLY_BASIC))
#             bad_prog (_(INVALID_LINE_0));
#         }
#       if (ch == '!')
#         {
#           cur_cmd->addr_bang = true;
#           ch = in_nonblank ();
#           if (ch == '!')
#             bad_prog (_(BAD_BANG));
#         }
#
#       /* Do not accept extended commands in --posix mode.  Also,
#          a few commands only accept one address in that mode.  */
#       if (posixicity == POSIXLY_BASIC)
#       switch (ch)
#          {
#           case 'e': case 'F': case 'v': case 'z': case 'L':
#           case 'Q': case 'T': case 'R': case 'W':
#              bad_command (ch);
#              FALLTHROUGH;
#
#             case 'a': case 'i': case 'l':
#             case '=': case 'r':
#               if (cur_cmd->a2)
#                 bad_prog (_(ONE_ADDR));
#           }
#
#       cur_cmd->cmd = ch;
#       switch (ch)
#         {
#         case '#':
#           if (cur_cmd->a1)
#             bad_prog (_(NO_SHARP_ADDR));
#           ch = inchar ();
#           if (ch=='n' && first_script && cur_input.line < 2)
#             if (   (prog.base && prog.cur==2+prog.base)
#                 || (prog.file && !prog.base && 2==ftell (prog.file)))
#               no_default_output = true;
#           while (ch != EOF && ch != '\n')
#             ch = inchar ();
#           continue;	/* restart the for (;;) loop */
#
#         case 'v':
#           /* This is an extension.  Programs needing GNU sed might start
#           * with a `v' command so that other seds will stop.
#           * We compare the version and ignore POSIXLY_CORRECT.
#           */
#           {
#             char *version = read_label ();
#             char const *compared_version;
#             compared_version = (*version == '\0') ? "4.0" : version;
#             if (strverscmp (compared_version, PACKAGE_VERSION) > 0)
#               bad_prog (_(ANCIENT_VERSION));
#
#             free (version);
#             posixicity = POSIXLY_EXTENDED;
#           }
#           continue;
#
#         case '{':
#           blocks = setup_label (blocks, vector->v_length, NULL, &cur_input);
#           cur_cmd->addr_bang = !cur_cmd->addr_bang;
#           break;
#
#         case '}':
#           if (!blocks)
#             bad_prog (_(EXCESS_CLOSE_BRACE));
#           if (cur_cmd->a1)
#             bad_prog (_(NO_CLOSE_BRACE_ADDR));
#
#           read_end_of_cmd ();
#
#           vector->v[blocks->v_index].x.jump_index = vector->v_length;
#           blocks = release_label (blocks);	/* done with this entry */
#           break;
#
#         case 'e':
#           if (sandbox)
#             bad_prog (_(DISALLOWED_CMD));
#
#           ch = in_nonblank ();
#           if (ch == EOF || ch == '\n')
#             {
#               cur_cmd->x.cmd_txt.text_length = 0;
#               break;
#             }
#           else
#             goto read_text_to_slash;
#
#         case 'a':
#         case 'i':
#         case 'c':
#           ch = in_nonblank ();
#
#         read_text_to_slash:
#           if (ch == EOF)
#             bad_prog (_(EXPECTED_SLASH));
#
#           if (ch == '\\')
#             ch = inchar ();
#           else
#             {
#               if (posixicity == POSIXLY_BASIC)
#                 bad_prog (_(EXPECTED_SLASH));
#               savchar (ch);
#               ch = '\n';
#             }
#
#           read_text (&cur_cmd->x.cmd_txt, ch);
#           break;
#
#         case ':':
#           if (cur_cmd->a1)
#             bad_prog (_(NO_COLON_ADDR));
#           {
#             char *label = read_label ();
#             if (!*label)
#               bad_prog (_(COLON_LACKS_LABEL));
#             labels = setup_label (labels, vector->v_length, label, NULL);
#
#             if (debug)
#               cur_cmd->x.label_name = strdup (label);
#           }
#           break;
#
#         case 'T':
#         case 'b':
#         case 't':
#           jumps = setup_label (jumps, vector->v_length, read_label (), NULL);
#           break;
#
#         case 'Q':
#         case 'q':
#           if (cur_cmd->a2)
#             bad_prog (_(ONE_ADDR));
#           FALLTHROUGH;
#
#         case 'L':
#         case 'l':
#           ch = in_nonblank ();
#           if (ISDIGIT (ch) && posixicity != POSIXLY_BASIC)
#             {
#               cur_cmd->x.int_arg = in_integer (ch);
#             }
#           else
#             {
#               cur_cmd->x.int_arg = -1;
#               savchar (ch);
#             }
#
#           read_end_of_cmd ();
#           break;
#
#       case '=':
#       case 'd':
#       case 'D':
#       case 'F':
#       case 'g':
#       case 'G':
#       case 'h':
#         case 'H':
#         case 'n':
#         case 'N':
#         case 'p':
#         case 'P':
#         case 'z':
#         case 'x':
#           read_end_of_cmd ();
#           break;
#
#         case 'r':
#           b = read_filename ();
#           if (strlen (get_buffer (b)) == 0)
#             bad_prog (_(MISSING_FILENAME));
#           cur_cmd->x.fname = xstrdup (get_buffer (b));
#           free_buffer (b);
#           break;
#
#         case 'R':
#           cur_cmd->x.inf = get_openfile (&file_read, read_mode, false);
#           break;
#
#         case 'W':
#         case 'w':
#           cur_cmd->x.outf = get_openfile (&file_write, write_mode, true);
#           break;
#
#         case 's':
#           {
#             struct buffer *b2;
#             int flags;
#             int slash;
#
#             slash = inchar ();
#             if ( !(b  = match_slash (slash, true)) )
#               bad_prog (_(UNTERM_S_CMD));
#             if ( !(b2 = match_slash (slash, false)) )
#               bad_prog (_(UNTERM_S_CMD));
#
#             cur_cmd->x.cmd_subst = OB_MALLOC (&obs, 1, struct subst);
#             setup_replacement (cur_cmd->x.cmd_subst,
#                               get_buffer (b2), size_buffer (b2));
#             free_buffer (b2);
#
#             flags = mark_subst_opts (cur_cmd->x.cmd_subst);
#             cur_cmd->x.cmd_subst->regx =
#               compile_regex (b, flags, cur_cmd->x.cmd_subst->max_id + 1);
#             free_buffer (b);
#
#             if (cur_cmd->x.cmd_subst->eval && sandbox)
#               bad_prog (_(DISALLOWED_CMD));
#           }
#           break;
#
#         case 'y':
#           {
#             size_t len, dest_len;
#             int slash;
#             struct buffer *b2;
#             char *src_buf, *dest_buf;
#
#             slash = inchar ();
#             if ( !(b = match_slash (slash, false)) )
#               bad_prog (_(UNTERM_Y_CMD));
#             src_buf = get_buffer (b);
#             len = normalize_text (src_buf, size_buffer (b), TEXT_BUFFER);
#
#             if ( !(b2 = match_slash (slash, false)) )
#               bad_prog (_(UNTERM_Y_CMD));
#             dest_buf = get_buffer (b2);
#             dest_len = normalize_text (dest_buf, size_buffer (b2), TEXT_BUFFER);
#
#             if (mb_cur_max > 1)
#               {
#                 size_t i, j, idx, src_char_num;
#                 size_t *src_lens = XCALLOC (len, size_t);
#                 char **trans_pairs;
#                 size_t mbclen;
#                 mbstate_t cur_stat = { 0, };
#
#                 /* Enumerate how many character the source buffer has.  */
#                 for (i = 0, j = 0; i < len;)
#                   {
#                     mbclen = MBRLEN (src_buf + i, len - i, &cur_stat);
#                     /* An invalid sequence, or a truncated multibyte character.
#                       We treat it as a single-byte character.  */
#                     if (mbclen == (size_t) -1 || mbclen == (size_t) -2
#                         || mbclen == 0)
#                       mbclen = 1;
#                     src_lens[j++] = mbclen;
#                     i += mbclen;
#                   }
#                 src_char_num = j;
#
#                 memset (&cur_stat, 0, sizeof cur_stat);
#                 idx = 0;
#
#                 /* trans_pairs = {src(0), dest(0), src(1), dest(1), ..., NULL}
#                      src(i) : pointer to i-th source character.
#                      dest(i) : pointer to i-th destination character.
#                      NULL : terminator */
#                 trans_pairs = XCALLOC (2 * src_char_num + 1, char*);
#                 cur_cmd->x.translatemb = trans_pairs;
#                 for (i = 0; i < src_char_num; i++)
#                   {
#                     if (idx >= dest_len)
#                       bad_prog (_(Y_CMD_LEN));
#
#                     /* Set the i-th source character.  */
#                     trans_pairs[2 * i] = XCALLOC (src_lens[i] + 1, char);
#                     memcpy (trans_pairs[2 * i], src_buf, src_lens[i]);
#                     trans_pairs[2 * i][src_lens[i]] = '\0';
#                     src_buf += src_lens[i]; /* Forward to next character.  */
#
#                     /* Fetch the i-th destination character.  */
#                     mbclen = MBRLEN (dest_buf + idx, dest_len - idx, &cur_stat);
#                     /* An invalid sequence, or a truncated multibyte character.
#                       We treat it as a single-byte character.  */
#                     if (mbclen == (size_t) -1 || mbclen == (size_t) -2
#                         || mbclen == 0)
#                       mbclen = 1;
#
#                     /* Set the i-th destination character.  */
#                     trans_pairs[2 * i + 1] = XCALLOC (mbclen + 1, char);
#                     memcpy (trans_pairs[2 * i + 1], dest_buf + idx, mbclen);
#                     trans_pairs[2 * i + 1][mbclen] = '\0';
#                     idx += mbclen; /* Forward to next character.  */
#                   }
#                 trans_pairs[2 * i] = NULL;
#                 if (idx != dest_len)
#                   bad_prog (_(Y_CMD_LEN));
#
#                 IF_LINT (free (src_lens));
#               }
#             else
#               {
#                 unsigned char *translate =
#                   OB_MALLOC (&obs, YMAP_LENGTH, unsigned char);
#                 unsigned char *ustring = (unsigned char *)src_buf;
#
#                 if (len != dest_len)
#                   bad_prog (_(Y_CMD_LEN));
#
#                 for (len = 0; len < YMAP_LENGTH; len++)
#                   translate[len] = len;
#
#                 while (dest_len--)
#                   translate[*ustring++] = (unsigned char)*dest_buf++;
#
#                 cur_cmd->x.translate = translate;
#               }
#
#             read_end_of_cmd ();
#
#             free_buffer (b);
#             free_buffer (b2);
#           }
#         break;
#
#         case EOF:
#           bad_prog (_(NO_COMMAND));
#           /*NOTREACHED*/
#
#         default:
#           bad_command (ch);
#           /*NOTREACHED*/
#         }
#
#       /* this is buried down here so that "continue" statements will miss it */
#       ++vector->v_length;
#     }
#   if (posixicity == POSIXLY_BASIC && pending_text)
#     bad_prog (_(INCOMPLETE_CMD));
#   return vector;
# }


# deal with \X escapes
# size_t
# normalize_text (char *buf, size_t len, enum text_types buftype)
# {
#   const char *bufend = buf + len;
#   char *p = buf;
#   char *q = buf;
#   char ch;
#   int base;
#
#   /* This variable prevents normalizing text within bracket
#      subexpressions when conforming to POSIX.  If 0, we
#      are not within a bracket expression.  If -1, we are within a
#      bracket expression but are not within [.FOO.], [=FOO=],
#      or [:FOO:].  Otherwise, this is the '.', '=', or ':'
#      respectively within these three types of subexpressions.  */
#   int bracket_state = 0;
#
#   int mbclen;
#   mbstate_t cur_stat = { 0, };
#
#   while (p < bufend)
#     {
#       mbclen = MBRLEN (p, bufend - p, &cur_stat);
#       if (mbclen != 1)
#         {
#           /* An invalid sequence, or a truncated multibyte character.
#              We treat it as a single-byte character.  */
#           if (mbclen == (size_t) -1 || mbclen == (size_t) -2 || mbclen == 0)
#             mbclen = 1;
#
#           memmove (q, p, mbclen);
#           q += mbclen;
#           p += mbclen;
#           continue;
#         }
#
#       if (*p == '\\' && p+1 < bufend && bracket_state == 0)
#         switch (*++p)
#           {
# #if defined __STDC__ && __STDC__-0
#           case 'a': *q++ = '\a'; p++; continue;
# #else /* Not STDC; we'll just assume ASCII */
#           case 'a': *q++ = '\007'; p++; continue;
# #endif
#           /* case 'b': *q++ = '\b'; p++; continue; --- conflicts with \b RE */
#           case 'f': *q++ = '\f'; p++; continue;
#           case '\n': /*fall through */
#           case 'n': *q++ = '\n'; p++; continue;
#           case 'r': *q++ = '\r'; p++; continue;
#           case 't': *q++ = '\t'; p++; continue;
#           case 'v': *q++ = '\v'; p++; continue;
#
#           case 'd': /* decimal byte */
#             base = 10;
#             goto convert;
#
#           case 'x': /* hexadecimal byte */
#             base = 16;
#             goto convert;
#
#           case 'o': /* octal byte */
#             base = 8;
# convert:
#             p = convert_number (&ch, p, bufend, base);
#
#             /* for an ampersand in a replacement, pass the \ up one level */
#             if (buftype == TEXT_REPLACEMENT && (ch == '&' || ch == '\\'))
#               *q++ = '\\';
#             *q++ = ch;
#             continue;
#
#           case 'c':
#             if (++p < bufend)
#               {
#                 *q++ = toupper ((unsigned char) *p) ^ 0x40;
#                 if (*p == '\\')
#                   {
#                     p++;
#                     if (*p != '\\')
#                       bad_prog (RECURSIVE_ESCAPE_C);
#                   }
#                 p++;
#                 continue;
#               }
#             else
#               {
#                 /* we just pass the \ up one level for interpretation */
#                 if (buftype != TEXT_BUFFER)
#                   *q++ = '\\';
#                 continue;
#               }
#
#           default:
#             /* we just pass the \ up one level for interpretation */
#             if (buftype != TEXT_BUFFER)
#               *q++ = '\\';
#             break;
#           }
#       else if (buftype == TEXT_REGEX && posixicity != POSIXLY_EXTENDED)
#         switch (*p)
#           {
#           case '[':
#             if (!bracket_state)
#               bracket_state = -1;
#             break;
#
#           case ':':
#           case '.':
#           case '=':
#             if (bracket_state == -1 && p[-1] == '[')
#               bracket_state = *p;
#             break;
#
#           case ']':
#             if (bracket_state == 0)
#               ;
#             else if (bracket_state == -1)
#               bracket_state = 0;
#             else if (p[-2] != bracket_state && p[-1] == bracket_state)
#               bracket_state = -1;
#             break;
#           }
#
#       *q++ = *p++;
#     }
#     return (size_t)(q - buf);
# }


# /* `str' is a string (from the command line) that contains a sed command.
#   Compile the command, and add it to the end of `cur_program'. */
def compile_string(cur_program, string):
    global first_script

    # string_expr_count = 0

    # prog and cur_input are global classes

    prog.file = NULL
    prog.base = 0  # first char of the string (will be 1-based)
    prog.cur = prog.base
    prog.end = prog.cur + len(string)
    prog.text = '@' + string  # the leading @ is ignored, it's a 1-based index

    cur_input.line = 1  # original was zero
    cur_input.name = NULL
    # string_expr_count += 1
    cur_input.string_expr_count += 1

    compile_program(cur_program)

    # Reseting here breaks check_final_program() error messages (bad_prog())
    # prog.base = NULL
    # prog.cur = NULL
    # prog.end = NULL

    first_script = False
    # no return, cur_program edited in place
#---------------------------------------------------------------------
# struct vector *
# compile_string (struct vector *cur_program, char *str, size_t len)
# {
#   static countT string_expr_count = 0;
#   struct vector *ret;
#
#   prog.file = NULL;
#   prog.base = (unsigned char *)str;
#   prog.cur = prog.base;
#   prog.end = prog.cur + len;
#
#   cur_input.line = 0;
#   cur_input.name = NULL;
#   cur_input.string_expr_count = ++string_expr_count;
#
#   ret = compile_program (cur_program);
#   prog.base = NULL;
#   prog.cur = NULL;
#   prog.end = NULL;
#
#   first_script = false;
#   return ret;
# }


# `cmdfile' is the name of a file containing sed commands.
#   Read them in and add them to the end of `cur_program'.
#
def compile_file(cur_program, cmdfile):
    # prog and cur_input are global classes
    global first_script

    prog.file = sys.stdin
    if cmdfile[0] != '-':  # or cmdfile[1] != '\0':
        prog.file = open(cmdfile, "r")

    cur_input.line = 1
    cur_input.name = cmdfile
    cur_input.string_expr_count = 0

    compile_program(cur_program)

    if prog.file != sys.stdin:
        prog.file.close()
    # Reseting here breaks check_final_program() error messages (bad_prog())
    # prog.file = NULL

    first_script = False
    # no return, cur_program edited in place
#---------------------------------------------------------------------
# compile_file (struct vector *cur_program, const char *cmdfile)
# {
#   struct vector *ret;
#
#   prog.file = stdin;
#   if (cmdfile[0] != '-' || cmdfile[1] != '\0')
#     {
# #ifdef HAVE_FOPEN_RT
#       prog.file = ck_fopen (cmdfile, "rt", true);
# #else
#       prog.file = ck_fopen (cmdfile, "r", true);
# #endif
#     }
#
#   cur_input.line = 1;
#   cur_input.name = cmdfile;
#   cur_input.string_expr_count = 0;
#
#   ret = compile_program (cur_program);
#   if (prog.file != stdin)
#     ck_fclose (prog.file);
#   prog.file = NULL;
#
#   first_script = false;
#   return ret;
# }


# static void
# cleanup_program_filenames (void)
# {
#   {
#     struct output *p;
#
#     for (p = file_read; p; p = p->link)
#       if (p->name)
#         {
#           free (p->name);
#           p->name = NULL;
#         }
#
#     for (p = file_write; p; p = p->link)
#       if (p->name)
#         {
#           free (p->name);
#           p->name = NULL;
#         }
#   }
# }


# Make any checks which require the whole program to have been read.
#   In particular: this backpatches the jump targets.
#   Any cleanup which can be done after these checks is done here also.
def check_final_program():  #program):
    global pending_text

    # do all "{"s have a corresponding "}"?
    if blocks:
        bad_prog(EXCESS_OPEN_BRACE)

    # was the final command an unterminated a/c/i command?
    if pending_text:
        print("pending_text:", pending_text)
        old_text_buf.text = pending_text
        free_buffer(pending_text)
        pending_text = NULL
#---------------------------------------------------------------------
# check_final_program (struct vector *program)
# {
#   struct sed_label *go;
#   struct sed_label *lbl;
#
#   /* do all "{"s have a corresponding "}"? */
#   if (blocks)
#     {
#       /* update info for error reporting: */
#       memcpy (&cur_input, &blocks->err_info, sizeof (cur_input));
#       bad_prog (_(EXCESS_OPEN_BRACE));
#     }
#
#   /* was the final command an unterminated a/c/i command? */
#   if (pending_text)
#     {
#       old_text_buf->text_length = size_buffer (pending_text);
#       if (old_text_buf->text_length)
#         old_text_buf->text = MEMDUP (get_buffer (pending_text),
#                                      old_text_buf->text_length, char);
#       free_buffer (pending_text);
#       pending_text = NULL;
#     }
#
#   for (go = jumps; go; go = release_label (go))
#     {
#       for (lbl = labels; lbl; lbl = lbl->next)
#         if (strcmp (lbl->name, go->name) == 0)
#           break;
#       if (lbl)
#         {
#           program->v[go->v_index].x.jump_index = lbl->v_index;
#         }
#       else
#         {
#           if (*go->name)
#             panic (_("can't find label for jump to `%s'"), go->name);
#           program->v[go->v_index].x.jump_index = program->v_length;
#         }
#     }
#   jumps = NULL;
#
#   for (lbl = labels; lbl; lbl = release_label (lbl))
#     ;
#   labels = NULL;
# }


# Rewind all resources which were allocated in this module.
# void
# rewind_read_files (void)
# {
#   struct output *p;
#
#   for (p=file_read; p; p=p->link)
#     if (p->fp)
#       rewind (p->fp);
# }


# Release all resources which were allocated in this module.
# void
# finish_program (struct vector *program)
# {
#   cleanup_program_filenames ();
#
#   /* close all files... */
#   {
#     struct output *p, *q;
#
#     for (p=file_read; p; p=q)
#       {
#         if (p->fp)
#           ck_fclose (p->fp);
#         q = p->link;
# #if 0
#         /* We use obstacks. */
#         free (p);
# #endif
#       }
#
#     for (p=file_write; p; p=q)
#       {
#         if (p->fp)
#           ck_fclose (p->fp);
#         q = p->link;
# #if 0
#         /* We use obstacks. */
#         free (p);
# #endif
#       }
#     file_read = file_write = NULL;
#   }
#
# #ifdef lint
#   for (int i = 0; i < program->v_length; ++i)
#     {
#       const struct sed_cmd *sc = &program->v[i];
#
#       if (sc->a1 && sc->a1->addr_regex)
#         release_regex (sc->a1->addr_regex);
#       if (sc->a2 && sc->a2->addr_regex)
#         release_regex (sc->a2->addr_regex);
#
#       switch (sc->cmd)
#         {
#         case 's':
#           free (sc->x.cmd_subst->replacement_buffer);
#           if (sc->x.cmd_subst->regx)
#             release_regex (sc->x.cmd_subst->regx);
#           break;
#         }
#     }
#
#   obstack_free (&obs, NULL);
# #else
#   (void)program;
# #endif /* lint */
#
# }


def debug(ch):
    print("exp=%s line=%s cur=%s end=%s text=%r ch=%r" % (
        cur_input.string_expr_count, cur_input.line, prog.cur, prog.end, prog.text, ch))

if __name__ == '__main__':

    the_program = []
    test = 17

    if len(sys.argv) > 1:
        print("Will parse file:", sys.argv[1])
        compile_file(the_program, sys.argv[1])
        sys.exit(0)

    if test == 1:
        pass
    elif test == 2:
        compile_string(the_program, "y/abc/xyz/;y/AB/X/")
    elif test == 3:  # 123
        compile_string(the_program, "q123")
    elif test == 4:
        compile_string(the_program, "d;\np; ")
    elif test == 5:
        compile_string(the_program, "e date;v;v 4.2")
    elif test == 6:  # r
        compile_string(the_program, "r filer\nw filew")
    elif test == 7:  # q l
        compile_string(the_program, "q;Q;\nL;l\n;q123;L123")
    elif test == 8:  # q l
        compile_string(the_program, ":label1;bfoo;t bar #comment")
    elif test == 9:  # a i c
        compile_string(the_program, "a\\foo\\\nbar")
    elif test == 10:  # !
        compile_string(the_program, "!p;!!d")
    elif test == 11:  # address
        compile_string(the_program, r"1,10!p;/foo/I,\|bar|MI!d;/abc/p")
    elif test == 12:  # address tricky
        compile_string(the_program, r"/a\/b[/]c/ p")
    elif test == 13:  # s no flags
        compile_string(the_program, "s/a/b/")
    elif test == 14:  # comment after s
        compile_string(the_program, "s/a/b/g # foo")
    elif test == 15:  # s with w flag
        compile_string(the_program, "s/a/b/gw filew")
    elif test == 16:  # s with }
        compile_string(the_program, "{s/a/b/g}")
    elif test == 17:  # unterminated a i c
        compile_string(the_program, "a\\")
        # check_final_program()
