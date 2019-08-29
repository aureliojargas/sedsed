#!/usr/bin/env python

# WONTDO
#
# Check if command only accepts one address
# if (cur_cmd->a2) bad_prog (_(ONE_ADDR));
#
# Check if command is a GNU extension
# if (posixicity == POSIXLY_EXTENDED)

import argparse
import sys

######################################## ported from regex.h

REG_EXTENDED = 1
REG_ICASE = 2
REG_NEWLINE = 4

program_name = 'sed'
EOF = '<EOF>'  # XXX read https://softwareengineering.stackexchange.com/a/197629
NULL = None

######################################## ported from basicdefs.h

def ISBLANK(c):
    return c == ' ' or c == '\t'

def ISDIGIT(ch):
    return ch in '0123456789'

def ISSPACE(c):
    return c in ' \t\n\v\f\r'

######################################## ported from sed.c

# Nothing. Not used.

######################################## ported from sed.h

# This structure tracks files used by sed so that they may all be
#   closed cleanly at normal program termination.  A flag is kept that tells
#   if a missing newline was encountered, so that it is added on the
#   next line and the two lines are not concatenated.
class struct_output:
    name = ""
    missing_newline = False
    fp = None
    link = None

class struct_text_buf:
    text = []
    text_length = 0
    def __str__(self):
        return ''.join(self.text)[:-1]  # remove trailing \n
    def __repr__(self):
        return repr(''.join(self.text)[:-1])

class struct_regex:
    pattern = ""
    flags = ""  # sedsed: was 0 in the original
    sz = 0
    dfa = None  # struct_dfa()
    begline = False
    endline = False
    re = ""
    slash = ""  # sedsed
    def __repr__(self):
        return "[pattern=%s flags=%s]" % (self.pattern, self.flags)
    def __str__(self):
        return ('\\' if self.slash != '/' else '') + \
               self.slash + self.pattern + self.slash + self.flags

# enum replacement_types {
REPL_ASIS = 0
REPL_UPPERCASE = 1
REPL_LOWERCASE = 2
REPL_UPPERCASE_FIRST = 4
REPL_LOWERCASE_FIRST = 8
REPL_MODIFIERS = REPL_UPPERCASE_FIRST | REPL_LOWERCASE_FIRST
# These are given to aid in debugging
REPL_UPPERCASE_UPPERCASE = REPL_UPPERCASE_FIRST | REPL_UPPERCASE
REPL_UPPERCASE_LOWERCASE = REPL_UPPERCASE_FIRST | REPL_LOWERCASE
REPL_LOWERCASE_UPPERCASE = REPL_LOWERCASE_FIRST | REPL_UPPERCASE
REPL_LOWERCASE_LOWERCASE = REPL_LOWERCASE_FIRST | REPL_LOWERCASE

# enum text_types {
TEXT_BUFFER = 1
TEXT_REPLACEMENT = 2
TEXT_REGEX = 3

# enum addr_state {
RANGE_INACTIVE = 1           # never been active
RANGE_ACTIVE = 2             # between first and second address
RANGE_CLOSED = 3             # like RANGE_INACTIVE, but range has ended once

# enum addr_types {
ADDR_IS_NULL = 1             # null address
ADDR_IS_REGEX = 2            # a.addr_regex is valid
ADDR_IS_NUM = 3              # a.addr_number is valid
ADDR_IS_NUM_MOD = 4          # a.addr_number is valid, addr_step is modulo
ADDR_IS_STEP = 5             # address is +N (only valid for addr2)
ADDR_IS_STEP_MOD = 6         # address is ~N (only valid for addr2)
ADDR_IS_LAST = 7             # address is $

class struct_addr:
    addr_type = ADDR_IS_NULL  # enum addr_types
    addr_number = 0
    addr_step = 0
    addr_regex = struct_regex()
    def __repr__(self):
        return "[type=%s number=%s step=%s regex=%s]" % (
            self.addr_type, self.addr_number, self.addr_step, self.addr_regex)
    def __str__(self):
        #TODO use addr_type
        if self.addr_regex:
            return str(self.addr_regex)
        elif self.addr_number:
            return str(self.addr_number)
        else:
            return '$'

class struct_replacement:
    prefix = ""
    prefix_length = 0
    subst_id = 0
    repl_type = REPL_ASIS  # enum replacement_types
    next_ = None  # struct_replacement
    text = ""  # aur

class struct_subst:
    regx = struct_regex()
    replacement = struct_replacement()
    numb = 0  # if >0, only substitute for match number "numb"
    outf = struct_output()  # 'w' option given
    global_ = False  # 'g' option given
    print_ = False  # 'p' option given (before/after eval)
    eval_ = False  # 'e' option given
    max_id = 0  # maximum backreference on the RHS
    replacement_buffer = ""  #ifdef lint
    flags = ""  # aur
    slash = ""  # aur
    def __str__(self):
        return self.slash + str(self.regx.pattern) + \
               self.slash + str(self.replacement.text) + \
               self.slash + self.flags

class struct_sed_cmd_x:
    "auxiliary data for various commands"
    # This structure is used for a, i, and c commands.
    cmd_txt = struct_text_buf()
    # This is used for the l, q and Q commands.
    int_arg = 0
    # This is used for the {}, b, and t commands.
    jump_index = 0
    # This is used for the r command. (sedsed: and RwW)
    fname = ""
    # This is used for the hairy s command. (sedsed: and y)
    cmd_subst = struct_subst()
    # This is used for the w command.
    outf = struct_output()
    # This is used for the R command.
    # (despite the struct name, it is used for both in and out files).
    inf = struct_output()
    # This is used for the y command.
    translate = ""
    translatemb = ""
    # This is used for the ':' command (debug only).
    label_name = ""
    comment = ""  # aur

class struct_sed_cmd:
    a1 = struct_addr()
    a2 = struct_addr()
    range_state = RANGE_INACTIVE  # See enum addr_state
    addr_bang = False  # Non-zero if command is to be applied to non-matches. (sedsed: using bool)
    cmd = ""  # The actual command character.
    x = struct_sed_cmd_x()

    def __str__(self):
        ret = []

        if self.a1:
            ret.append(str(self.a1))
        if self.a2:
            ret.append(',%s' % self.a2)
        if ret:
            ret.append(' ')

        if self.addr_bang:
            ret.append('!')

        ret.append(self.cmd)

        if self.cmd == '\n':
            pass
        elif self.cmd == '#':
            ret.append(self.x.comment)
        elif self.cmd == ':':
            ret.append(self.x.label_name)
        elif self.cmd in 'sy':
            ret.append(str(self.x.cmd_subst))
        elif self.x.label_name:
            ret.append(' ' + self.x.label_name)
        elif self.x.fname:
            ret.append(' ' + self.x.fname)
        elif self.x.int_arg and self.x.int_arg > -1:
            ret.append(' %s' % self.x.int_arg)
        elif self.x.cmd_txt.text:  # aic
            ret.append('\\\n%s' % self.x.cmd_txt)

        return ''.join(ret)

# Struct vector is used to describe a compiled sed program.
class struct_vector:
    v = struct_sed_cmd()
    v_allocated = 0
    v_length = 0

# sedsed: This is probably from regex.c, but I'll fake it here
# just saving the collected strings
def compile_regex(pattern, flags):
    r = struct_regex()
    r.pattern = ''.join(pattern)
    r.flags = ''.join(flags)
    return r

def IS_MB_CHAR(ch):
    return ch != EOF and ord(ch) > 127
    # This exception is because I chose to store EOF as '<EOF>'

######################################## ported from utils.h

# enum exit_codes {
EXIT_SUCCESS = 0            # is already defined as 0
EXIT_BAD_USAGE = 1          # bad program syntax, invalid command-line options
EXIT_BAD_INPUT = 2          # failed to open some of the input files
EXIT_PANIC = 4              # PANIC during program execution

######################################## ported from utils.c

# Print an error message and exit
def panic(msg):
    print("%s: %s" % (program_name, msg), file=sys.stderr)
    sys.exit(EXIT_PANIC)

MIN_ALLOCATE = 50

def init_buffer():
    return []

def add1_buffer(buffer, ch):
    if ch != EOF:
        buffer.append(ch)  # in-place
    # the return is never used

def free_buffer(b):
    del b

######################################## ported from compile.c

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


# Where we are in the processing of the input.
class prog(prog_info):
    pass
class cur_input(error_info):
    pass

# /* Information about labels and jumps-to-labels.  This is used to do
#   the required backpatching after we have compiled all the scripts. */
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

# Various error messages we may want to print
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

# Complain about an unknown command and exit.
def bad_command(ch):
    bad_prog(UNKNOWN_CMD % ch)

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


# /* Read the next character from the program.  Return EOF if there isn't
#   anything to read.  Keep cur_input.line up to date, so error messages
#   can be meaningful. */
def inchar():
    ch = EOF
    if prog.cur is not None:
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
    debug(ch, stats=True)
    return ch

# unget `ch' so the next call to inchar will return it.
def savchar(ch):
    debug("savchar(%s)" % ch, stats=True)
    if ch == EOF:
        return
    if ch == '\n' and cur_input.line > 0:
        cur_input.line -= 1
    if prog.cur:
        prog.cur -= 1
        if prog.cur <= prog.base or prog.text[prog.cur+1] != ch:  # XXX not sure about cur+1
            # panic("Called savchar with unexpected pushback (%s)" % ch)
            panic("Called savchar with unexpected pushback (curr=%s %s!=%s)" % (prog.cur, prog.text[prog.cur], ch))
    else:
        try:
            # Go back one position in prog.file file descriptor pointer
            prog.file.seek(prog.file.tell() - 1)  # ungetc (ch, prog.file)
        except ValueError:  # negative seek position -1
            pass


# Read the next non-blank character from the program.
def in_nonblank():
    while True:
        ch = inchar()
        if not ISBLANK(ch):
            break
    return ch


# sedsed: Ignore multiple trailing blanks and ; until EOC/EOL/EOF
# Skipping those chars avoids \n incorrectly being considered a new command and
# producing a new undesired blank line in the output.
def ignore_trailing_fluff():
    while True:
        ch = in_nonblank()
        if ch == ';':  # skip it
            pass
        elif ch in ('EOF', '\n'):  # EOF, EOL
            return
        else:  # start of a new command
            savchar(ch)
            return

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

    # sedsed: Ignore multiple trailing blanks and ; until EOC/EOL/EOF
    elif ch == ';':
        ignore_trailing_fluff()


# Read an integer value from the program.
def in_integer(ch):
    num = []
    while ISDIGIT(ch):
        num.append(ch)
        ch = inchar()
    savchar(ch)
    return int(''.join(num))


def add_then_next(buffer, ch):
    add1_buffer(buffer, ch)
    return inchar()


# This is a copy of read_filename, but preserving blanks
def read_comment():
    b = init_buffer()
    ch = inchar()
    while ch not in (EOF, '\n'):
        ch = add_then_next(b, ch)
    return b


# Read in a filename for a `r', `w', or `s///w' command.
def read_filename():
    b = init_buffer()
    ch = in_nonblank()
    while ch not in (EOF, '\n'):
        ch = add_then_next(b, ch)
    # add1_buffer(b, '\0');  # not necessary in Python
    return b


def next_cmd_entry(vector):
    cmd = struct_sed_cmd()
    cmd.a1 = NULL
    cmd.a2 = NULL
    cmd.range_state = RANGE_INACTIVE
    cmd.addr_bang = False
    cmd.cmd = '\0'  # something invalid, to catch bugs early
    #TODO fix this struct reset mess
    cmd.x = struct_sed_cmd_x()
    cmd.x.cmd_txt = struct_text_buf()
    cmd.x.cmd_subst = struct_subst()
    cmd.x.cmd_subst.regx = struct_regex()
    cmd.x.cmd_subst.replacement = struct_replacement()
    cmd.x.cmd_subst.outf = struct_output()
    cmd.x.outf = struct_output()
    cmd.x.inf = struct_output()
    vector.append(cmd)
    return cmd


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
    first_loop_run = True
    while True:
        if not first_loop_run:
            ch = add_then_next(b, ch)
        first_loop_run = False

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
                # # GNU sed interprets \n here, we don't
                # elif ch == 'n' and regex:
                #     ch = '\n'
                # # Those exceptions remove the leading \ from known situations
                # # For example, s/a\/b/.../ becames 'a/b' not 'a\/b'
                # # Since I want to keep the original user text, this is disabled
                # elif (ch != '\n' and (ch != slash or (not regex and ch == '&'))):
                else:
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


def mark_subst_opts():
    flags = []
    numb = False

    while True:
        ch = in_nonblank()
        debug("s flag candidate: %r" % ch)

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
            flags.append(str(n))
            numb = True

        elif ch == 'w':
            b = read_filename()
            if not b:
                bad_prog(MISSING_FILENAME)
            debug("s flag filename: %r" % ''.join(b))
            flags.append("%s %s" % (ch, ''.join(b)))
            return flags

        elif ch == '#':
            savchar(ch)
            return flags

        elif ch == CLOSE_BRACE:
            savchar(ch)
            return flags

        # sedsed: Ignore multiple trailing blanks and ; until EOC/EOL/EOF
        elif ch == ';':
            ignore_trailing_fluff()
            return flags

        elif ch in (EOF, '\n'):
            return flags

        elif ch == '\r':
            if inchar() == '\n':
                return flags
            bad_prog(UNKNOWN_S_OPT)

        else:
            bad_prog(UNKNOWN_S_OPT)
         #NOTREACHED


# read in a label for a `:', `b', or `t' command
def read_label():
    b = init_buffer()
    ch = in_nonblank()

    while ch != EOF and ch != '\n' and not ISBLANK(ch) and ch != ';' and ch != CLOSE_BRACE and ch != '#':
        ch = add_then_next(b, ch)

    # sedsed: Ignore multiple trailing blanks and ; until EOC/EOL/EOF
    if ch == ';' or ISBLANK(ch):
        ignore_trailing_fluff()

    # add1_buffer(b, '\0')  # not necessary in Python
    ret = ''.join(b)
    free_buffer(b)
    return ret


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
        if b == NULL:
            bad_prog(UNTERM_ADDR_RE)
        slash = ch

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
                addr.addr_regex.slash = slash
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


# Read a program (or a subprogram within `{' `}' pairs) in and store
# the compiled form in `*vector'.  Return a pointer to the new vector.
def compile_program(vector):
    global blocks

    if pending_text:
        read_text(NULL, '\n')

    while True:

        a = struct_addr()

#       while ((ch=inchar ()) == ';' || ISSPACE (ch))
#         ;
#       if (ch == EOF)
#         break;
        while True:
            ch = inchar()

            # sedsed:
            # GNU sed parser discards the \n used as command separator.
            # Sedsed keeps all cosmetic line breaks (i.e. \n\n) when formatting
            # code. It creates the concept of the \n command, to identify and
            # preserve those breaks.
            if ch == '\n':
                break

            if ch != ';' and not ISSPACE(ch):
                break

        if ch == EOF:
            break

        cur_cmd = next_cmd_entry(vector)

        if compile_address(a, ch):
            if a.addr_type == ADDR_IS_STEP or a.addr_type == ADDR_IS_STEP_MOD:
                bad_prog(BAD_STEP)

            cur_cmd.a1 = a  # MEMDUP(&a, 1, struct addr)
            debug("----- Found address 1: %r" % cur_cmd.a1)


            a = struct_addr()  # reset a
            ch = in_nonblank()
            if ch == ',':
                if not compile_address(a, in_nonblank()):
                    bad_prog(BAD_COMMA)

                cur_cmd.a2 = a  # MEMDUP(&a, 1, struct addr)
                debug("----- Found address 2: %r" % cur_cmd.a2)
                ch = in_nonblank()

            if (cur_cmd.a1.addr_type == ADDR_IS_NUM and cur_cmd.a1.addr_number == 0) \
                    and (not cur_cmd.a2 or cur_cmd.a2.addr_type != ADDR_IS_REGEX):
                    #or posixicity == POSIXLY_BASIC)):
                bad_prog(INVALID_LINE_0)

        if ch == '!':
            cur_cmd.addr_bang = True
            debug("----- Found negation: !")
            ch = in_nonblank()
            if ch == '!':
                bad_prog(BAD_BANG)

        # Do not accept extended commands in --posix mode.  Also,
        # a few commands only accept one address in that mode.
        # SKIPPED

        cur_cmd.cmd = ch
        debug("----- Found command: %r" % ch)

        # sedsed
        if ch == '\n':
            pass  # nothing to do, command already saved

        elif ch == '#':
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
            b = read_comment()
            cur_cmd.x.comment = ''.join(b)
            debug("comment: %r" % cur_cmd.x.comment)
            free_buffer(b)
            # while ch != EOF and ch != '\n':
            #     ch = inchar()
            # continue

        elif ch == '{':
            blocks += 1

            # sedsed: Ignore multiple trailing blanks and ; until EOC/EOL/EOF
            ignore_trailing_fluff()

            # cur_cmd.addr_bang = not cur_cmd.addr_bang  # ?

        elif ch == '}':
            if not blocks:
                bad_prog(EXCESS_CLOSE_BRACE)
            if cur_cmd.a1:
                bad_prog(NO_CLOSE_BRACE_ADDR)

            read_end_of_cmd()
            blocks -= 1  # done with this entry

        elif ch in 'ev':
            argument = read_label()
            cur_cmd.x.label_name = argument
            debug("argument: %s" % argument)

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
            debug("text: %r" % cur_cmd.x.cmd_txt)
#ENDGOTO

        elif ch in ':Tbt':
#           if (cur_cmd->a1)
#             bad_prog (_(NO_COLON_ADDR));
            label = read_label()
            cur_cmd.x.label_name = label
            debug("label: %r" % label)
            if ch == ':' and not label:
                bad_prog(COLON_LACKS_LABEL)
            # labels = setup_label (labels, vector->v_length, label, NULL);

        elif ch in 'QqLl':
            ch = in_nonblank()
            if ISDIGIT(ch):
                cur_cmd.x.int_arg = in_integer(ch)
                debug("int_arg: %r" % in_integer(ch))
            else:
                cur_cmd.x.int_arg = -1
                debug("int_arg: -1")
                savchar(ch)
            read_end_of_cmd()

        elif ch in '=dDFgGhHnNpPzx':
            read_end_of_cmd()

        elif ch in 'rRwW':
            b = read_filename()
            if not b:
                bad_prog(MISSING_FILENAME)
            cur_cmd.x.fname = ''.join(b)
            debug("filename: %r" % cur_cmd.x.fname)
            free_buffer(b)

        elif ch == 's':
            slash = inchar()
            cur_cmd.x.cmd_subst.slash = slash
            b = match_slash(slash, True)
            if b == NULL:
                bad_prog(UNTERM_S_CMD)
            cur_cmd.x.cmd_subst.regx.pattern = ''.join(b)
            debug("s pattern: %r" % cur_cmd.x.cmd_subst.regx.pattern)

            b2 = match_slash(slash, False)
            if b2 == NULL:
                bad_prog(UNTERM_S_CMD)
            cur_cmd.x.cmd_subst.replacement.text = ''.join(b2)
            debug("s replacement: %r" % cur_cmd.x.cmd_subst.replacement.text)

            # setup_replacement(cur_cmd.x.cmd_subst, b2)
            free_buffer(b2)

            flags = mark_subst_opts()  #cur_cmd.x.cmd_subst)
            cur_cmd.x.cmd_subst.flags = ''.join(flags)
            debug("s flags: %r" % cur_cmd.x.cmd_subst.flags)
            # cur_cmd.x.cmd_subst.regx = compile_regex(b, flags, cur_cmd.x.cmd_subst.max_id + 1)
            free_buffer(b)

            # if cur_cmd.x.cmd_subst.eval and sandbox:
            #     bad_prog(_(DISALLOWED_CMD))

        elif ch == 'y':
            slash = inchar()
            cur_cmd.x.cmd_subst.slash = slash
            b = match_slash(slash, False)
            if b == NULL:
                bad_prog(UNTERM_Y_CMD)
            cur_cmd.x.cmd_subst.regx.pattern = ''.join(b)
            debug("y pattern: %r" % cur_cmd.x.cmd_subst.regx.pattern)

            b2 = match_slash(slash, False)
            if b2 == NULL:
                bad_prog(UNTERM_Y_CMD)
            cur_cmd.x.cmd_subst.replacement.text = ''.join(b2)
            debug("y replacement: %r" % cur_cmd.x.cmd_subst.replacement.text)

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
    # no return, vector edited in place


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
        debug("pending_text: %r" % pending_text)
        old_text_buf.text = pending_text
        free_buffer(pending_text)
        pending_text = NULL


PARSER_DEBUG = False
def debug(msg, stats=False):
    if PARSER_DEBUG:
        if stats:
            print("exp=%s line=%s cur=%s end=%s text=%r ch=%r" % (
                cur_input.string_expr_count, cur_input.line, prog.cur, prog.end, prog.text, msg))
        else:
            print(msg)

if __name__ == '__main__':

    the_program = []
    test = 17

    argparser = argparse.ArgumentParser()
    argparser.add_argument('-v', '--verbose', action='store_true', help='verbose mode')
    argparser.add_argument('files', metavar='FILE', nargs='*', help='input files')
    args = argparser.parse_args()

    PARSER_DEBUG = args.verbose

    if args.files:
        debug("Will parse file: %s" % args.files[0])
        compile_file(the_program, args.files[0])
        indent_level = 0
        indent_prefix = ' ' * 4
        for x in the_program:
            if x.cmd == '}':
                indent_level -= 1

            if x.cmd == '\n':
                print()
            else:
                print('%s%s' % ((indent_prefix * indent_level), x))

            if x.cmd == '{':
                indent_level += 1
        sys.exit(0)

    PARSER_DEBUG = True
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
