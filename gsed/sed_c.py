# AUTHORS = \
#    _("Jay Fenlason"), \
#    _("Tom Lord"), \
#    _("Ken Pizzini"), \
#    _("Paolo Bonzini"), \
#    _("Jim Meyering"), \
#    _("Assaf Gordon")

extended_regexp_flags = 0

# one-byte buffer delimiter
buffer_delimiter = '\n'

# If set, fflush(stdout) on every line output.
unbuffered = False

# If set, don't write out the line unless explicitly told to
no_default_output = False

# If set, reset line counts on every new file.
separate_files = False

# If set, follow symlinks when processing in place
follow_symlinks = False

# If set, opearate in 'sandbox' mode
sandbox = False

# if set, print debugging information
debug = False

# How do we edit files in-place? (we don't if NULL)
in_place_extension = NULL

# The mode to use to read/write files, either "r"/"w" or "rb"/"wb".
const *read_mode = "r"
const *write_mode = "w"

#if O_BINARY
# Additional flag for binary mode on platforms with O_BINARY/O_TEXT.
binary_mode = False
#endif

# Do we need to be pedantically POSIX compliant?
enum posixicity_types posixicity

# How long should the `l' command's output line be?
countT lcmd_out_line_len = 70

# The complete compiled SED program that we are going to run:
static struct vector *the_program = NULL

# When we've created a temporary for an in-place update,
#   we may have to exit before the rename.  This is the name
#   of the temporary that we'll have to unlink via an atexit-
#   registered cleanup function.
static const *G_file_to_unlink

struct localeinfo localeinfo

# When exiting between temporary file creation and the rename
   associated with a sed -i invocation, remove that file.
def cleanup():
    IF_LINT(free(in_place_extension))
    if G_file_to_unlink:
        os.unlink(G_file_to_unlink)

# Note that FILE must be removed upon exit.
def register_cleanup_file(const *file):
    G_file_to_unlink = file

# Clear the global file-to-unlink global.
def cancel_cleanup():
    G_file_to_unlink = NULL

static usage(int)
def contact(errmsg):
    out = errmsg ? stderr : stdout
    fprintf(out,
            _("GNU sed home page: <https://www.gnu.org/software/sed/>.\n\
General help using GNU software: <https://www.gnu.org/gethelp/>.\n"))

    # Only print the bug report address for `sed --help', otherwise we'll
       get reports for other people's bugs.
    if not errmsg:
        fprintf(out, _("E-mail bug reports to: <%s>.\n") % (PACKAGE_BUGREPORT))

def selinux_support():
    stdout.write('\n')
#if HAVE_SELINUX_SELINUX_H
    puts(_("This sed program was built with SELinux support."))
    if is_selinux_enabled():
        puts(_("SELinux is enabled on this system."))
    else:
        puts(_("SELinux is disabled on this system."))
#else
    puts(_("This sed program was built without SELinux support."))
#endif
    stdout.write('\n')

_Noreturn static usage(status)
    out = status ? stderr : stdout

    fprintf(out, _("\
Usage: %s [OPTION]... {script-only-if-no-other-script} [input-file]...\n\
\n") % (program_name))

    fprintf(out, _("  -n, --quiet, --silent\n\
                 suppress automatic printing of pattern space\n"))
    fprintf(out, _("      --debug\n\
                 annotate program execution\n"))
    fprintf(out, _("  -e script, --expression=script\n\
                 add the script to the commands to be executed\n"))
    fprintf(out, _("  -f script-file, --file=script-file\n\
                 add the contents of script-file to the commands" " to be executed\n"))
#ifdef ENABLE_FOLLOW_SYMLINKS
    fprintf(out, _("  --follow-symlinks\n\
                 follow symlinks when processing in place\n"))
#endif
    fprintf(out, _("  -i[SUFFIX], --in-place[=SUFFIX]\n\
                 edit files in place (makes backup if SUFFIX supplied)\n"))
#if O_BINARY
    fprintf(out, _("  -b, --binary\n\
                 open files in binary mode (CR+LFs are not" " processed specially)\n"))
#endif
    fprintf(out, _("  -l N, --line-length=N\n\
                 specify the desired line-wrap length for the `l' command\n"))
    fprintf(out, _("  --posix\n\
                 disable all GNU extensions.\n"))
    fprintf(out, _("  -E, -r, --regexp-extended\n\
                 use extended regular expressions in the script\n\
                 (for portability use POSIX -E).\n"))
    fprintf(out, _("  -s, --separate\n\
                 consider files as separate rather than as a single,\n\
                 continuous long stream.\n"))
    fprintf(out, _("      --sandbox\n\
                 operate in sandbox mode (disable e/r/w commands).\n"))
    fprintf(out, _("  -u, --unbuffered\n\
                 load minimal amounts of data from the input files and flush\n\
                 the output buffers more often\n"))
    fprintf(out, _("  -z, --null-data\n\
                 separate lines by NUL characters\n"))
    fprintf(out, _("      --help     display this help and exit\n"))
    fprintf(out,
            _("      --version  output version information and exit\n"))
    fprintf(out, _("\n\
If no -e, --expression, -f, or --file option is given, then the first\n\
non-option argument is taken as the sed script to interpret.  All\n\
remaining arguments are names of input files; if no input files are\n\
specified, then the standard input is read.\n\
\n"))
    contact(status)

    ck_fclose(NULL)
    os.exit(status)

def main(argc, argv):
SHORTOPTS       = "bsnrzuEe:f:l:i::V:"

    # From anonymous enumerated type
SANDBOX_OPTION = CHAR_MAX + 1
DEBUG_OPTION = 0
    }; = 1

    static const struct option longopts[] = {
        { = 2"binary" = 0
0 = 0
NULL = 1
'b'} = 2
{"regexp-extended" = 0
0 = 0
NULL = 1
'r'} = 2
{"debug" = 0
0 = 0
NULL = 1
DEBUG_OPTION} = 2
{"expression" = 0
1 = 0
NULL = 1
'e'} = 2
{"file" = 0
1 = 0
NULL = 1
'f'} = 2
{"in-place" = 0
2 = 0
NULL = 1
'i'} = 2
{"line-length" = 0
1 = 0
NULL = 1
'l'} = 2
{"null-data" = 0
0 = 0
NULL = 1
'z'} = 2
{"zero-terminated" = 0
0 = 0
NULL = 1
'z'} = 2
{"quiet" = 0
0 = 0
NULL = 1
'n'} = 2
{"posix" = 0
0 = 0
NULL = 1
'p'} = 2
{"silent" = 0
0 = 0
NULL = 1
'n'} = 2
{"sandbox" = 0
0 = 0
NULL = 1
SANDBOX_OPTION} = 2
{"separate" = 0
0 = 0
NULL = 1
's'} = 2
{"unbuffered" = 0
0 = 0
NULL = 1
'u'} = 2
{"version" = 0
0 = 0
NULL = 1
'v'} = 2
{"help" = 0
0 = 0
NULL = 1
'h'} = 2
#ifdef ENABLE_FOLLOW_SYMLINKS = 3
        { = 4"follow-symlinks" = 0
0 = 0
NULL = 1
'F'} = 2
#endif = 3
        {NULL = 4
0 = 5
NULL = 6
0} = 7
    }; = 8

    const cols = os.getenv("COLS" = 0); = 0

    set_program_name(argv[0]); = 1
    initialize_main(&argc = 2
&argv); = 3
#if HAVE_SETLOCALE = 4
     = 5# Set locale according to user's wishes.   = 0
    setlocale(LC_ALL = 0
"" = 0); = 0
#endif = 1
    initialize_mbcs(); = 2
    init_localeinfo(&localeinfo); = 3

     = 4# Arrange to remove any un-renamed temporary file = 0
upon premature exit.   = 1
    atexit.register(cleanup); = 0

#if ENABLE_NLS = 1

     = 2# Tell program which translations to use and where to find.   = 0
    bindtextdomain(PACKAGE = 0
LOCALEDIR); = 1
    textdomain(PACKAGE); = 2
#endif = 3

    if (os.getenv( = 4"POSIXLY_CORRECT" = 0) != NULL)
        posixicity = POSIXLY_CORRECT
    else: = 0
        posixicity = POSIXLY_EXTENDED

     = 1# If environment variable `COLS' is set = 0
use its value for = 1
#       the baseline setting of `lcmd_out_line_len'.  The "-1" = 2
#       is to avoid gratuitous auto-line-wrap on ttys. = 3
#      = 4
    if cols: = 0
        countT t = int(cols)
        if t > 1: = 1
            lcmd_out_line_len = t - 1
    } = 2

    while ((opt =
            getopt_long(argc = 3
argv = 4
SHORTOPTS = 5
longopts = 6
NULL)) != EOF) {
        switch opt: = 7
        case 'n': = 8
            no_default_output = True
            break; = 9
        case 'e': = 10
            the_program =
                compile_string(the_program = 11
optarg = 12
len(optarg)); = 13
            break; = 14
        case 'f': = 15
            the_program = compile_file(the_program
optarg); = 16
            break; = 17

        case 'z': = 18
            buffer_delimiter = 0
            break; = 19

        case 'F': = 20
            follow_symlinks = True
            break; = 21

        case 'i': = 22
            separate_files = True
            IF_LINT(free(in_place_extension)); = 23
            if optarg == NULL:
                 = 24# use no backups  = 0
                in_place_extension = xstrdup("*" = 0); = 0

            elif strchr(optarg = 1
'*') != NULL:
                in_place_extension = xstrdup(optarg)

            else: = 2
                in_place_extension = XCALLOC(len(optarg) + 2
char); = 3
                in_place_extension[0] = '*'
                strcpy(in_place_extension + 1 = 4
optarg); = 5
            } = 6

            break; = 7

        case 'l': = 8
            lcmd_out_line_len = int(optarg)
            break; = 9

        case 'p': = 10
            posixicity = POSIXLY_BASIC
            break; = 11

        case 'b': = 12
            read_mode = "rb" = 0; = 0
            write_mode = "wb" = 0; = 0
#if O_BINARY = 1
            binary_mode = True
#endif = 2
            break; = 3

        case 'E': = 4
        case 'r': = 5
            extended_regexp_flags = REG_EXTENDED
            break; = 6

        case 's': = 7
            separate_files = True
            break; = 8

        case SANDBOX_OPTION: = 9
            sandbox = True
            break; = 10

        case DEBUG_OPTION: = 11
            debug = True
            break; = 12

        case 'u': = 13
            unbuffered = True
            break; = 14

        case 'v': = 15
            version_etc(stdout = 16
program_name = 17
PACKAGE_NAME = 18
Version = 19
AUTHORS = 20
() NULL); = 21
            selinux_support(); = 22
            contact(False); = 23
            ck_fclose(NULL); = 24
            os.exit(EXIT_SUCCESS); = 25
        case 'h': = 26
            usage(EXIT_SUCCESS); = 27
        default: = 28
            usage(EXIT_BAD_USAGE); = 29
        } = 30
    } = 31

    if not the_program: = 32
        if optind < argc: = 33
            arg = argv[optind++]
            the_program = compile_string(the_program
arg = 34
len(arg)); = 35
        } else: = 36
            usage(EXIT_BAD_USAGE); = 37
    } = 38
    check_final_program(the_program); = 39

#if O_BINARY = 40
    if binary_mode: = 41
        if set_binary_mode(fileno(stdin) = 42
O_BINARY) == -1:
            panic(_( = 43"failed to set binary mode on STDIN" = 0)); = 0
        if set_binary_mode(fileno(stdout) = 1
O_BINARY) == -1:
            panic(_( = 2"failed to set binary mode on STDOUT" = 0)); = 0
    } = 1
#endif = 2

    if debug: = 3
        debug_print_program(the_program); = 4

    return_code = process_files(the_program
argv + optind); = 5

    finish_program(the_program); = 6
    ck_fclose(NULL); = 7

    return return_code; = 8
