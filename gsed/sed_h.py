# This structure tracks files used by sed so that they may all be
#   closed cleanly at normal program termination.  A flag is kept that tells
#   if a missing newline was encountered, so that it is added on the
#   next line and the two lines are not concatenated.
class struct_output:
    name = ""
    missing_newline = False
    fp = None
    link = None
# struct output {
#   char *name;
#   bool missing_newline;
#   FILE *fp;
#   struct output *link;
# };

class struct_text_buf:
    text = []
    text_length = 0
    def __str__(self):
        return ''.join(self.text)
    __repr__ = __str__
# struct text_buf {
#   char *text;
#   size_t text_length;
# };

class struct_regex:
    pattern = ""
    flags = 0
    sz = 0
    dfa = None  # struct_dfa()
    begline = False
    endline = False
    re = ""
    def __str__(self):
        return "[pattern=%s flags=%s]" % (self.pattern, self.flags)
    __repr__ = __str__

# struct regex {
#   regex_t pattern;
#   int flags;
#   size_t sz;
#   struct dfa *dfa;
#   bool begline;
#   bool endline;
#   char re[1];
# };

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

# enum posixicity_types {
#     POSIXLY_EXTENDED,           # with GNU extensions
#     POSIXLY_CORRECT,            # with POSIX-compatible GNU extensions
#     POSIXLY_BASIC               # pedantically POSIX

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
    def __str__(self):
        return "[type=%s number=%s step=%s regex=%s]" % (
            self.addr_type, self.addr_number, self.addr_step, self.addr_regex)
    __repr__ = __str__
# struct addr {
#   enum addr_types addr_type;
#   countT addr_number;
#   countT addr_step;
#   struct regex *addr_regex;
# };

class struct_replacement:
    prefix = ""
    prefix_length = 0
    subst_id = 0
    repl_type = REPL_ASIS  # enum replacement_types
    next_ = None  # struct_replacement
# struct replacement {
#   char *prefix;
#   size_t prefix_length;
#   int subst_id;
#   enum replacement_types repl_type;
#   struct replacement *next;
# };

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
# struct subst {
#   struct regex *regx;
#   struct replacement *replacement;
#   countT numb;		/* if >0, only substitute for match number "numb" */
#   struct output *outf;	/* 'w' option given */
#   unsigned global : 1;	/* 'g' option given */
#   unsigned print : 2;	/* 'p' option given (before/after eval) */
#   unsigned eval : 1;	/* 'e' option given */
#   unsigned max_id : 4;  /* maximum backreference on the RHS */
# #ifdef lint
#   char* replacement_buffer;
# #endif
# };


class struct_sed_cmd_x:
    "auxiliary data for various commands"
    # This structure is used for a, i, and c commands.
    cmd_txt = struct_text_buf()
    # This is used for the l, q and Q commands.
    int_arg = 0
    # This is used for the {}, b, and t commands.
    jump_index = 0
    # This is used for the r command.
    fname = ""
    # This is used for the hairy s command.
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

class struct_sed_cmd:
    a1 = struct_addr()
    a2 = struct_addr()
    range_state = RANGE_INACTIVE  # See enum addr_state
    addr_bang = 0  # Non-zero if command is to be applied to non-matches.
    cmd = ""  # The actual command character.
    x = struct_sed_cmd_x()

# struct sed_cmd {
#   struct addr *a1;	/* save space: usually is NULL */
#   struct addr *a2;

#   /* See description the enum, above.  */
#   enum addr_state range_state;

#   /* Non-zero if command is to be applied to non-matches. */
#   char addr_bang;

#   /* The actual command character. */
#   char cmd;

#   /* auxiliary data for various commands */
#   union {
#     /* This structure is used for a, i, and c commands. */
#     struct text_buf cmd_txt;

#     /* This is used for the l, q and Q commands. */
#     int int_arg;

#     /* This is used for the {}, b, and t commands. */
#     countT jump_index;

#     /* This is used for the r command. */
#     char *fname;

#     /* This is used for the hairy s command. */
#     struct subst *cmd_subst;

#     /* This is used for the w command. */
#     struct output *outf;

#     /* This is used for the R command.
#       (despite the struct name, it is used for both in and out files). */
#     struct output *inf;

#     /* This is used for the y command. */
#     unsigned char *translate;
#     char **translatemb;

#     /* This is used for the ':' command (debug only).  */
#     char* label_name;
#   } x;
# };

# Struct vector is used to describe a compiled sed program.
class struct_vector:
    v = struct_sed_cmd()
    v_allocated = 0
    v_length = 0
# struct vector {
#     struct sed_cmd *v           # a dynamically allocated array
#     size_t v_allocated          # ... number of slots allocated
#     size_t v_length             # ... number of slots in use


# _Noreturn void bad_prog (const char *why);
# size_t normalize_text (char *text, size_t len, enum text_types buftype);
# struct vector *compile_string (struct vector *, char *str, size_t len);
# struct vector *compile_file (struct vector *, const char *cmdfile);
# void check_final_program (struct vector *);
# void rewind_read_files (void);
# void finish_program (struct vector *);

# This is probably from regex.c, but I'll fake it here
# just saving the collected strings
def compile_regex(pattern, flags):
    r = struct_regex()
    r.pattern = ''.join(pattern)
    r.flags = ''.join(flags)
    return r


# struct regex *compile_regex (struct buffer *b, int flags, int needed_sub);
# int match_regex (struct regex *regex,
#                  char *buf, size_t buflen, size_t buf_start_offset,
#                  struct re_registers *regarray, int regsize);
# #ifdef lint
# void release_regex (struct regex *);
# #endif

# void
# debug_print_command (const struct vector *program, const struct sed_cmd *sc);
# void
# debug_print_program (const struct vector *program);
# void
# debug_print_char (char c);

# int process_files (struct vector *, char **argv);

# int main (int, char **);

# extern struct localeinfo localeinfo;

# extern int extended_regexp_flags;

# /* one-byte buffer delimiter */
# extern char buffer_delimiter;

# /* If set, fflush(stdout) on every line output,
#   and turn off stream buffering on inputs.  */
# extern bool unbuffered;

# /* If set, don't write out the line unless explicitly told to. */
# extern bool no_default_output;

# /* If set, reset line counts on every new file. */
# extern bool separate_files;

# /* If set, follow symlinks when invoked with -i option */
# extern bool follow_symlinks;

# /* Do we need to be pedantically POSIX compliant? */
# extern enum posixicity_types posixicity;

# /* How long should the `l' command's output line be? */
# extern countT lcmd_out_line_len;

# /* How do we edit files in-place? (we don't if NULL) */
# extern char *in_place_extension;

# /* The mode to use to read and write files, either "rt"/"w" or "rb"/"wb".  */
# extern char const *read_mode;
# extern char const *write_mode;

# /* Should we use EREs? */
# extern bool use_extended_syntax_p;

# /* Declarations for multibyte character sets.  */
# extern int mb_cur_max;
# extern bool is_utf8;

# /* If set, operate in 'sandbox' mode - disable e/r/w commands */
# extern bool sandbox;

# /* If set, print debugging information.  */
# extern bool debug;

# #define MBRTOWC(pwc, s, n, ps) \
#   (mb_cur_max == 1 ? \
#   (*(pwc) = btowc (*(unsigned char *) (s)), 1) : \
#   mbrtowc ((pwc), (s), (n), (ps)))

# #define WCRTOMB(s, wc, ps) \
#   (mb_cur_max == 1 ? \
#   (*(s) = wctob ((wint_t) (wc)), 1) : \
#   wcrtomb ((s), (wc), (ps)))

# #define MBSINIT(s) \
#   (mb_cur_max == 1 ? 1 : mbsinit ((s)))

# #define MBRLEN(s, n, ps) \
#   (mb_cur_max == 1 ? 1 : mbrtowc (NULL, s, n, ps))

# #define IS_MB_CHAR(ch, ps)                \
#   (mb_cur_max == 1 ? 0 : is_mb_char (ch, ps))
def IS_MB_CHAR(ch):
    return ord(ch) > 127

# extern int is_mb_char (int ch, mbstate_t *ps);
# extern void initialize_mbcs (void);
# extern void register_cleanup_file (char const *file);
# extern void cancel_cleanup (void);

# /* Use this to suppress gcc's '...may be used before initialized' warnings. */
# #ifdef lint
# # define IF_LINT(Code) Code
# #else
# # define IF_LINT(Code) /* empty */
# #endif

# #ifndef FALLTHROUGH
# # if __GNUC__ < 7
# #  define FALLTHROUGH ((void) 0)
# # else
# #  define FALLTHROUGH __attribute__ ((__fallthrough__))
# # endif
# #endif
