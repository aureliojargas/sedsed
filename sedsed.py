#!/usr/bin/env python
# sedsed - Debugger and code formatter for sed scripts
# Since 27 November 2001, by Aurelio Jargas

# pylint: disable=bad-whitespace
# pylint: disable=invalid-name
# pylint: disable=redefined-outer-name
# pylint: disable=too-many-branches
# pylint: disable=too-many-lines
# pylint: disable=too-many-locals
# pylint: disable=too-many-statements

from __future__ import print_function  # pylint: disable=unused-variable
import sys
import re
import os
import getopt
import tempfile

# sedparse is a translation to Python of the GNU sed parser C code
# https://github.com/aureliojargas/sedparse
import sedparse

__version__ = "2.0.0"
myname = "sedsed"
myhome = "https://aurelio.net/projects/sedsed/"


# Default config
# fmt: off
sedbin = "sed"                # name (or full path) of the sed program
color = 1                     # colored output or not? (--color, --nocolor)
dump_debug = 0                # dump debug script to screen? (--dump-debug)
indent_prefix = " "*4         # default indent prefix for blocks (--prefix)
debug_prefix = "\t\t"         # default prefix for debug commands
action = "indent"             # default action if none specified (-d,-i,-t,-H)
DEBUG = 0                     # set developer's debug level [0-3]
# fmt: on

# HTML data for --htmlize
# You may edit here to change the defaults
html_colors = {
    # fmt: off
    "addr1":     "#8080ff",
    "addr1flag": "#ff6060",
    "addr2":     "#8080ff",
    "addr2flag": "#ff6060",
    "lastaddr":  "",
    "modifier":  "#ff6060",
    "id":        "#ffff00",
    "content":   "#ff00ff",
    "delimiter": "#ff6060",
    "pattern":   "#8080ff",
    "replace":   "",
    "flag":      "#00ff00",
    "comment":   "#00ffff",
    "escape":    "#ff6060",
    "special":   "#00ff00",
    "pattmeta":  "#ff00ff",
    "plaintext": "",
    "branch":    "",
    "BGCOLOR":   "#000000",
    "TEXT":      "#ffffff",
    "LINK":      "#ff00ff",
    "ALINK":     "#ff00ff",
    "VLINK":     "#ff00ff"
}

# Note that the %s will be expanded later
html_header = """\
<html>
<head><meta name="Generator" content="sedsed --htmlize">
<title>Colorized %s</title></head>
<body bgcolor="{BGCOLOR}" text="{TEXT}"
      link="{LINK}" alink="{ALINK}" vlink="{VLINK}">
<pre>\
""".format(
    **html_colors
)

html_footer = """
<font color="{}"><b>### colorized by <a href="{}">sedsed</a>, \
a debugger and code formatter for sed scripts</b></font>

</pre></body></html>\
""".format(
    html_colors["comment"], myhome
)

# sedsed expects multiline text (aic text, s/// replacement) to have this
# odd string instead of inner \n's in the string
linesep = "@#linesep#@"

# Data holders that will be set by command line options
# fmt: off
action_modifiers = []  # --hide contents and others
sedscript = []         # join all scripts found here
script_file = ""       # last sedscript filename for --htmlize
quiet_flag = 0         # tell if the #n is needed or not
E_flag = 0             # pass -E to sedbin (extended RE)
textfiles = []
# fmt: on

# Color-related variables, will be set in set_colors()
color_YLW = ""
color_RED = ""
color_REV = ""
color_NO = ""

# Color-dependent variable, will be set after the command line parsing
newlineshow = ""

# Debug-related variables, will be set by set_debug_commands()
showpatt = ""
showhold = ""
save_t = ""
showcomm = ""
nullcomm = ""

# Regex to match the shebang, grouping the sed options
topopts_regex = r"#!\s*/[^\s]+\s+-([nf]+)"

# All sed commands grouped by kind
sedcmds = {
    "file": "rw" + "RW",  # standard + GNU sed
    "multi": "sy",
    "solo": "=dDgGhHnNpPx" + "Fz",  # standard + GNU sed
    "text": "aci" + "e",  # standard + GNU sed
    "jump": ":bt" + "T",  # standard + GNU sed
    "block": "{}",
    "int": "qQlL",  # standard (q, l), GNU sed (q<n>, l<n>, Q, L)
    "misc": "v",  # GNU sed
}

# All fields used by the sedsed AST dictionary
cmdfields = [
    "linenr",
    "addr1",
    "addr1flag",
    "addr2",
    "addr2flag",
    "lastaddr",
    "modifier",
    "id",
    "content",
    "delimiter",
    "pattern",
    "replace",
    "flag",
    "comment",
]


# -----------------------------------------------------------------------------
#                              Special adjustments
# -----------------------------------------------------------------------------


# The identifier recognized by sed as STDIN
# - BSD sed does not support '-'
# - Windows, Termux and others do not have /dev/stdin
if os.path.exists("/dev/stdin"):
    stdin_id = "/dev/stdin"
else:
    stdin_id = "-"

# Turn color OFF on Windows because ANSI.SYS is not installed by default.
# Windows users who have ANSI.SYS configured, can use the --color option
# or comment the following line.
# ANSI.SYS resources:
#   http://www.evergreen.edu/biophysics/technotes/program/ansi_esc.htm#notes
#   http://www3.sympatico.ca/rhwatson/dos7/v-ansi-escseq.html
if os.name == "nt":
    color = 0


# -----------------------------------------------------------------------------
#                              General Functions
# -----------------------------------------------------------------------------


def print_usage(exitcode=1):
    print(
        """
Usage: sedsed OPTION [-e sedscript] [-f sedscriptfile] [inputfile]

OPTIONS:

     -f, --file          add file contents to the commands to be parsed
     -e, --expression    add the script to the commands to be parsed
     -n, --quiet         suppress automatic printing of pattern space
         --silent        alias to --quiet

     -d, --debug         debug the sed script
         --hide          hide some debug info (options: PATT,HOLD,COMM)
         --color         shows debug output in colors (default: ON)
         --nocolor       no colors on debug output
         --dump-debug    dumps to screen the debugged sed script

     -i, --indent        script beautifier, prints indented and
                         one-command-per-line output do STDOUT
         --prefix        indent prefix string (default: 4 spaces)
         --sedbin        specify sed executable (name or full path)

     -t, --tokenize      script tokenizer, prints extensive
                         command by command information
     -E                  pass -E (usually for extended RE) to sed
     -H, --htmlize       converts sed script to a colorful HTML page

     -V, --version       prints the program version and exit
     -h, --help          prints this help message and exit
"""
    )
    print("Website: %s\n" % myhome)
    sys.exit(exitcode)


def fatal_error(msg):
    "All error messages are handled by me"
    print("ERROR: %s: %s" % (myname, msg), file=sys.stderr)
    sys.exit(1)


def echo(msg):  # pylint: disable=unused-variable
    print("\033[33;1m%s\033[m" % msg)


def devdebug(msg, level=1):  # pylint: disable=unused-variable
    if DEBUG and DEBUG >= level:
        print("+++ DEBUG%d: %s" % (level, msg))


def read_file(file_path):
    "Reads a file into a list, removing line breaks"

    if file_path in (stdin_id, "-"):
        try:
            data = sys.stdin.readlines()

        except KeyboardInterrupt:  # ^C
            sys.exit(1)
            # Ideally the exit code should be 128+signal.SIGINT in Unix, but
            # I'm not sure about other platforms. So I'll keep it simple.
    else:
        try:
            with open(file_path) as f:
                data = f.readlines()

        except IOError as e:
            fatal_error("Cannot read file: %s\n%s" % (file_path, e))

    return [re.sub("[\n\r]+$", "", x) for x in data]


def write_file(file_path, lines):
    "Writes a list contents into file, adding correct line breaks"

    try:
        with open(file_path, "w") as f:
            # TODO maybe use os.linesep? - all this is really necessary?
            # ensuring line break
            lines = [re.sub("\n$", "", x) + "\n" for x in lines]
            f.writelines(lines)

    except IOError as e:
        fatal_error("Cannot write file: %s\n%s" % (file_path, e))


def system_command(cmd):
    "Returns a (#exit_code, program_output[]) tuple"
    ret = None
    output = []

    fd = os.popen(cmd)
    for line in fd.readlines():
        output.append(line.rstrip())  # stripping \s*\n
    ret = fd.close()
    if ret:
        ret = ret / 256  # 16bit number

    return ret, output


def validate_script_syntax(script_text):
    """Validate a sed script using system's sed."""

    # Using tmpfile2 because "sed -f script /dev/null" won't work in Windows
    tmpfile1 = tempfile.mktemp()
    tmpfile2 = tempfile.mktemp()
    write_file(tmpfile1, script_text)
    write_file(tmpfile2, "")

    E_opt = '-E' if E_flag else ''

    # Note that even when running against an empty file, there could be
    # consequences on the system, such as a 'w' command writing files.
    # sed -f sed_script empty_file
    ret, _ = system_command("%s %s -f '%s' '%s'" % (sedbin, E_opt, tmpfile1, tmpfile2))
    os.remove(tmpfile1)
    os.remove(tmpfile2)

    # The sed command will fail when there's something wrong:
    # - syntax error
    # - unknown command
    # - permission denied for file read/write commands (r, w, s///w)
    #   Example: touch a; chmod 000 a; sedsed -d -e 'w a'
    if ret:
        # At this point, the sed error message was already shown to the user,
        # explaining the reason for the failure. So now we abort giving some
        # context of what we were trying to do.
        fatal_error(
            "%d: Failed validating your script using system's sed: %s" % (ret, sedbin)
        )


def set_colors():
    # pylint: disable=global-statement
    global color_YLW
    global color_RED
    global color_REV
    global color_NO

    # Add the terminal escapes for color (or not):
    # yellow text, red text, reverse video, back to default
    if color:
        color_YLW = "\033[33;1m"
        color_RED = "\033[31;1m"
        color_REV = "\033[7m"
        color_NO = "\033[m"
    else:
        color_YLW = color_RED = color_REV = color_NO = ""


# -----------------------------------------------------------------------------
#                                 Command line
# -----------------------------------------------------------------------------


def parse_command_line(arguments=None):
    # pylint: disable=global-statement
    global action
    global action_modifiers
    global color
    global DEBUG
    global dump_debug
    global indent_prefix
    global newlineshow
    global quiet_flag
    global E_flag
    global script_file
    global sedscript
    global sedbin
    global textfiles

    arguments = arguments or sys.argv[1:]

    # Here's all the valid command line options
    short_options = "he:f:ditVHEn"
    long_options = [
        # actions
        "debug",
        "tokenize",
        "htmlize",
        "indent",
        # sed-like
        "version",
        "help",
        "file=",
        "expression=",
        "silent",
        "quiet",
        # misc
        "nocolor",
        "color",
        "hide=",
        "prefix=",
        "sedbin=",
        # other
        "dump-debug",
        # admin
        "_debuglevel=",
        "_stdout-only",
        "dumpcute",
    ]

    # Check it!
    try:
        opt, args = getopt.getopt(arguments, short_options, long_options)
    except getopt.error as errmsg:
        fatal_error("%s (try --help)" % errmsg)

    # Command Line is OK, now let's parse its values
    for o in opt:
        if o[0] in ("-d", "--debug"):
            action = "debug"

        elif o[0] in ("-i", "--indent"):
            action = "indent"
            color = 0

        elif o[0] in ("-t", "--tokenize"):
            action = "token"
            color = 0

        elif o[0] == "-E":
            E_flag = 1

        elif o[0] in ("-H", "--htmlize"):
            action = "html"
            color = 0

        elif o[0] in ("-n", "--quiet", "--silent"):
            quiet_flag = 1

        elif o[0] in ("-e", "--expression"):
            sedscript.extend(o[1].split("\n"))

        elif o[0] in ("-f", "--file"):
            sedscript.extend(read_file(o[1]))
            script_file = o[1]

        elif o[0] in ("-h", "--help"):
            print_usage(0)

        elif o[0] in ("-V", "--version"):
            print("%s v%s" % (myname, __version__))
            sys.exit(0)

        elif o[0] == "--dump-debug":
            action = "debug"
            dump_debug = 1
            color = 0

        elif o[0] == "--nocolor":
            color = 0

        elif o[0] == "--color":
            color = 1

        elif o[0] == "--hide":
            # --hide=comm,hold  ==>  action_modifiers = ['nocomm', 'nohold']
            for hide in o[1].split(","):
                hide_me = hide.strip().lower()
                action_modifiers.append("no" + hide_me)

        elif o[0] == "--prefix":
            # Is the prefix valid?
            if re.sub(r"\s", "", o[1]):
                fatal_error("--prefix: must be spaces and/or TABs")
            indent_prefix = o[1]

        elif o[0] == "--sedbin":
            sedbin = o[1]

        # Undocumented admin options

        elif o[0] == "--_debuglevel":
            DEBUG = int(o[1])

        elif o[0] == "--_stdout-only":
            action = "debug"
            action_modifiers.append(o[0][2:])

        elif o[0] == "--dumpcute":
            action = "dumpcute"
            DEBUG = 0
            color = 1

    # There's a SED script?
    if not sedscript:
        if args:
            # the script is the only argument (echo | sed 's///')
            sedscript.append(args.pop(0))
        else:
            fatal_error("there's no SED script to parse! (try --help)")

    # Get all text files, if none, use STDIN
    textfiles = args or [stdin_id]

    # All command line arguments were read and parsed. Now we need to do some
    # adjustments in the data, based on the current config state.

    # Add the leading #n to the sed script, when using -n
    if quiet_flag:
        sedscript.insert(0, "#n")

    # At this point we know if colors are configured or not
    set_colors()

    # When showing the inner \n's to the user use this red \N
    newlineshow = "%s\\N%s" % (color_RED, color_NO)


# The SED debugger magic lines
# ----------------------------
#
# Here is where the 'magic' lives. The heart of this program are the
# following lines, which are the special SED commands responsible for
# the DEBUG behaviour. For *each* command of the original script,
# several commands are added before, to show buffers and command
# contents. Some tricks are needed to preserve script's original
# behaviour, they are explained ahead.
#
# 1. Show PATTERN SPACE contents:
#    The 'PATT:' prefix is added, then the 'l' command shows the
#    buffer contents, then the prefix is removed.
#
# 2. Show HOLD SPACE contents:
#    Similar to PATTERN SPACE, but use the 'x' command to access and
#    restore the HOLD buffer contents. The prefix used is 'HOLD:'.
#
# 3. Show current SED COMMAND:
#    Uses a single 'i' command to show the full 'COMM:' line, as it
#    does not depend on execution data. The color codes are added or
#    not, depending on user options.
#
# 4. 'Last Address' trick:
#    On SED, the empty address // refers to the last address matched.
#    As this behaviour can be affected when several DEBUG lines are
#    inserted before the command, sedsed uses a trick to force it.
#    The last address used on the original script is repeated with a
#    null command (/last-address/ y/!/!/). This way sedsed repeat the
#    addressing, ensuring the next command will have it as the right
#    'last' address.
#
# 5. 't Status' trick:
#    The 't' command behaviour, from SED manual page:
#
#        If a s/// has done a successful substitution since the last
#        input line was read and since the last t command, then branch
#        to label
#
#    As all the DEBUG commands use lots of 's///' commands, the 't'
#    status is always true. The trick here is to add fake labels
#    between *any* command and fake 't' commands to jump to them:
#
#        <last command, possibly s///>
#        t zzset001
#        ... debug commands ...
#        t zzclr001
#        : zzset001
#        ... debug commands ...
#        : zzclr001
#        <next command, possibly t>
#
#    The DEBUG commands are repeated and placed into two distinct
#    blocks: 'zzset' and 'zzclr', which represents the 't' status
#    of the last command. The execution order follows:
#
#       zzset: 1st jump (t), then debug (s///), t status is ON
#       zzclr: 1st debug (s///), then jump (t), t status is OFF
#
#    The 001 count is incremented on each command to have unique
#    labels.
#
#    For the GNU sed 'T' command, the behaviour is the opposite: it only
#    branches when there was *no* successful substitution. Luckily, the
#    trick used for 't' applies to 'T' with no changes, because we can
#    save and restore the correct last 's///' status.
#
#
#                   --- THANK YOU VERY MUCH ---
#
# - Paolo Bonzini (GNU sed 4.x maintainer) for the idea of the
#   't status' trick.
#
# - Thobias Salazar Trevisan for the idea of using the 'i'
#   command for the COMM: lines.
#
def set_debug_commands():
    # pylint: disable=global-statement
    global showpatt
    global showhold
    global save_t
    global showcomm
    global nullcomm

    # show pattern space, show hold space, show sed command
    # null sed command to restore last address, 't' and 'T' status trick
    # fmt: off
    showpatt = [     "s/^/PATT:/", "l", "s/^PATT://"     ]
    showhold = ["x", "s/^/HOLD:/", "l", "s/^HOLD://", "x"]
    showcomm = ["i\\", "COMM:%s\a%s" % (color_YLW, color_NO)]
    nullcomm = ["y/!/!/"]
    save_t   = ["t zzset\a\n#DEBUG#", "t zzclr\a",
                ":zzset\a\n#DEBUG#", ":zzclr\a"]
    # fmt: on

    def format_debugcmds(cmds):
        "One per line, with prefix (spaces)"
        return debug_prefix + ("\n" + debug_prefix).join(cmds) + "\n"

    showpatt = format_debugcmds(showpatt)
    showhold = format_debugcmds(showhold)
    save_t = format_debugcmds(save_t)
    showcomm = debug_prefix + "\n".join(showcomm) + "\n"
    nullcomm = nullcomm[0]

    # If user specified --hide, unset DEBUG commands for them
    if "nopatt" in action_modifiers:
        showpatt = ""
    if "nohold" in action_modifiers:
        showhold = ""
    if "nocomm" in action_modifiers:
        showcomm = ""


# -----------------------------------------------------------------------------
#                         Auxiliary Functions - Tools
# -----------------------------------------------------------------------------


def escape_text_commands_specials(text):
    text = text.replace("\\", "\\\\")  # escape the escape
    return text


def paint_html(element, txt=""):
    if not txt:
        return txt  # nothing to paint

    # Escape HTML special chars
    txt = txt.replace("&", "&amp;")
    txt = txt.replace(">", "&gt;")
    txt = txt.replace("<", "&lt;")

    # Some color adjustments and emphasis
    if element == "id" and txt in sedcmds["block"]:
        element = "delimiter"

    elif element == "id" and txt == ":":
        element = "content"

    elif element == "replace":
        # highlight \n, & and \$
        newtxt = paint_html("special", "\\" + linesep)
        txt = txt.replace("\\" + linesep, newtxt)
        txt = re.sub("(\\\\[1-9]|&amp;)", paint_html("special", "\\1"), txt)

    elif element == "pattern":
        # highlight ( and |
        txt = re.sub("(\\\\)([(|])", "\\1" + paint_html("pattmeta", "\\2"), txt)

    elif element == "plaintext":
        # highlight \$
        newtxt = paint_html("special", "\\" + linesep)
        txt = txt.replace("\\" + linesep, newtxt)

    elif element == "branch":
        # nice link to the label
        txt = '<a href="#%s">%s</a>' % (txt, txt)

    elif element == "target":
        # link target
        txt = '<a name="%s">%s</a>' % (txt, txt)
        element = "content"

    # Paint it!
    if html_colors.get(element) and txt:
        font_color = html_colors[element]
        txt = '<font color="%s"><b>%s</b></font>' % (font_color, txt)
    return txt


# -----------------------------------------------------------------------------
#                 Hardcore Address/Command Composer Functions
# -----------------------------------------------------------------------------


def compose_sed_address(data):
    """Format the full sed address as plain text or HTML."""
    if not data["addr1"]:
        return ""  # no address

    if action == "html":
        address1 = "%s%s" % (
            data["addr1html"],
            paint_html("addr1flag", data.get("addr1flag")),
        )
        address2 = "%s%s" % (
            data.get("addr2html"),
            paint_html("addr2flag", data.get("addr2flag")),
        )
    else:
        address1 = "%s%s" % (data.get("addr1"), data.get("addr1flag"))
        address2 = "%s%s" % (data.get("addr2"), data.get("addr2flag"))

    if data["addr2"]:
        address = "%s,%s" % (address1, address2)
    else:
        address = address1

    return address + " "  # address, space, (command)


def compose_sed_command(data):
    if data["delimiter"]:  # s///
        if action != "html":
            cmd = "%s%s%s%s%s%s%s%s" % (
                data["modifier"],
                data["id"],
                data["delimiter"],
                data["pattern"],
                data["delimiter"],
                data["replace"],
                data["delimiter"],
                data["flag"],
            )
            if data["content"]:  # s///w filename
                cmd = cmd + " " + data["content"]
        else:
            cmd = """%s%s%s%s%s%s%s%s""" % (
                # fmt: off
                paint_html("modifier",  data["modifier"]),
                paint_html("id",        data["id"]),
                paint_html("delimiter", data["delimiter"]),
                paint_html("pattern",   data["pattern"]),
                paint_html("delimiter", data["delimiter"]),
                paint_html("replace",   data["replace"]),
                paint_html("delimiter", data["delimiter"]),
                paint_html("flag",      data["flag"]),
            )
            if data["content"]:  # s///w filename
                painted = paint_html("content", data["content"])
                cmd = "%s %s" % (cmd, painted)
    else:
        idsep = ""
        # spacer on r,w,b,t,v commands only
        spaceme = sedcmds["file"] + sedcmds["jump"] + sedcmds["int"] + "v"
        spaceme = spaceme.replace(":", "")  # : label (no space!)
        if data["id"] in spaceme and data["content"]:
            idsep = " "
        cmd = "%s%s%s%s" % (data["modifier"], data["id"], idsep, data["content"])
        if action == "html":
            if data["id"] in sedcmds["text"]:
                content_type = "plaintext"
            elif data["id"] in ("b", "t", "T"):
                content_type = "branch"
            elif data["id"] == ":":
                content_type = "target"
            else:
                content_type = "content"

            cmd = "%s%s%s%s" % (
                paint_html("modifier", data["modifier"]),
                paint_html("id", data["id"]),
                idsep,
                paint_html(content_type, data["content"]),
            )
    cmd = cmd.replace(linesep, "\n")
    return cmd


# -----------------------------------------------------------------------------
#                    The dump* Functions - They 4mat 4you!
# -----------------------------------------------------------------------------


def dump_key_value_pair(datalist):
    "Returns field:value command data line by line (lots of lines!)"
    outlist = []
    for data in datalist[1:]:  # skip headers at 0
        if not data["id"]:  # blank line
            continue
        for key in datalist[0]["fields"]:
            if key == "replace":
                data[key] = data[key].replace(linesep, newlineshow)
            outlist.append("%10s:%s" % (key, data[key]))
        outlist.append("")
    return outlist


# Format: line:ad1:ad1f:ad2:ad2f:mod:cmd:content:delim:patt:rplc:flag:comment
def dump_oneliner(datalist, fancy=0):  # pylint: disable=unused-variable
    "Returns a command per line, elements separated by : (looooong lines)"
    outlist = []
    r = n = ""
    if fancy:
        r = "\033[7m"
        n = "\033[m"
    for data in datalist[1:]:  # skip headers at 0
        outline = data["linenr"]
        if data["id"]:
            for key in datalist[0]["fields"][1:]:  # skip linenr
                outline = "%s:%s%s%s" % (outline, r, data[key], n)
        outlist.append(outline)
    return outlist


def dump_cute(datalist):
    "Returns a strange representation of SED commands. Use --dumpcute."
    outlist = []
    r = color_REV
    n = color_NO
    for data in datalist[1:]:  # skip headers at 0
        if not data["id"]:
            outlist.append("%40s" % "[blank]")
        elif data["id"] == "#":
            outlist.append(data["comment"])
        else:
            idsep = ""
            if data["id"] in ("b", "t", "T"):
                idsep = " "
            cmd = "%s%s%s%s" % (data["modifier"], data["id"], idsep, data["content"])
            if data["delimiter"]:
                cmd = "%s%s%s%s%s%s%s" % (
                    cmd,
                    data["delimiter"],
                    data["pattern"],
                    data["delimiter"],
                    data["replace"],
                    data["delimiter"],
                    data["flag"],
                )
            cmd = cmd.replace(linesep, n + newlineshow + r)
            outlist.append("%s" % "-" * 40)
            outlist.append(
                "adr: %s%s%s%s  :::  %s%s%s%s"
                % (
                    r,
                    data["addr1"],
                    data["addr1flag"],
                    n,
                    r,
                    data["addr2"],
                    data["addr2flag"],
                    n,
                )
            )
            outlist.append("cmd: %s%s%s   [%s]" % (r, cmd, n, data["comment"]))
    return outlist


# dump_script: This is a handy function, used by --indent AND --htmlize
# It formats the SED script in a human-friendly way, with one command
# per line and adding spaces on the right places. If --htmlize, it
# also adds the HTML code to the script.
#
def dump_script(datalist, indent_prefix):
    "Returns the indented script in plain text or HTML"
    indfmt = {"string": indent_prefix, "initlevel": 0}
    outlist = []
    indent = indfmt["initlevel"]

    if action == "html":
        outlist.append(html_header % os.path.basename(script_file))

    for data in datalist[1:]:  # skip headers at 0
        if not data["id"]:  # blank line
            outlist.append("")
            continue
        if data["id"] == "#":
            indentstr = indfmt["string"] * indent
            if action != "html":
                outlist.append(indentstr + data["comment"])
            else:
                outlist.append(indentstr + paint_html("comment", data["comment"]))
        else:
            if data["id"] == "}":
                indent = indent - 1

            # only indent++ after open {
            indentstr = indfmt["string"] * indent
            if data["id"] == "{":
                indent = indent + 1

            cmd = compose_sed_command(data)
            addr = compose_sed_address(data)

            # saving full line
            cmd = "%s%s%s" % (indentstr, addr, cmd)
            if data["comment"]:
                # Inline comments are aligned at column 40
                # The leading ; before # is required by non-GNU seds
                outlist.append("%-39s;%s" % (cmd, data["comment"]))
            else:
                outlist.append(cmd)

    if action == "html":
        outlist.append(html_footer)

    return outlist


# -----------------------------------------------------------------------------
#                    do_debug - Here is where the fun begins
# -----------------------------------------------------------------------------
#
# This function performs the --debug action.
#
# After the SED script was parsed by the parser (below), this function
# is called with the script data found. It loops, shouts and screams,
# inserting the nice DEBUG lines between the SED script commands.
#
# After all lines are composed, it call the system's SED to run the
# script, and SED will do its job, but this time showing you all the
# secrets that the PATTERN SPACE and HOLD SPACE buffers holds.
#
def do_debug(datalist):
    outlist = []
    cmdlineopts = "f"
    t_count = 0
    hideregisters = 0

    set_debug_commands()

    if "topopts" in datalist[0]:
        cmdlineopts = datalist[0]["topopts"]

    # If we have at least one 't' or 'T' command on the script, we need
    # to save the t command status between debug commands. As they perform
    # s/// commands, the t status of the "last substitution" is lost.
    # So, we save the status doing a nice loop trick before *every*
    # command (necessary overhead). This loops uses the :zzsetNNN and
    # zzclrNNN labels, where NNN is the label count.
    # TIP: t status resets: line read, t call
    if datalist[0]["has_t"]:
        t_count = 1

    for i, data in enumerate(datalist):
        if i == 0:
            continue  # skip headers at 0
        if not data["id"]:
            continue  # ignore blank line
        if data["id"] == "#":
            outlist.append("%s\n" % (data["comment"]))
        else:
            cmd = compose_sed_command(data)
            addr = compose_sed_address(data)

            cmdshow = cmd.replace("\n", newlineshow + color_YLW)
            cmdshow = escape_text_commands_specials(addr + cmdshow)
            showsedcmd = showcomm.replace("\a", cmdshow)

            registers = showpatt + showhold
            if hideregisters:
                registers = ""

            showall = "%s%s" % (registers, showsedcmd)

            # Add the 't status' trick to commands.
            # Exception: read-next-line commands (n,d,q)
            # Exception: no PATT/HOLD registers to show (no s///)
            if t_count and showall:
                if data["id"] not in ("n", "d", "q") and registers:
                    tmp = save_t.replace("\a", "%03d" % t_count)
                    showall = tmp.replace("#DEBUG#", showall)
                    t_count = t_count + 1

            # null cmd to restore last addr: /addr/y/!/!/
            # Bug: https://github.com/aureliojargas/sedsed/issues/15
            if data["lastaddr"]:
                showall = showall + debug_prefix + data["lastaddr"] + nullcomm + "\n"

            # after jump, block or void commands don't show
            # registers, because they're not affected.
            # exception: after b or t without target
            # (read next line)
            hideregisters = 0
            if data["id"] in sedcmds["jump"] and data["content"]:
                hideregisters = 1
            elif data["id"] in sedcmds["block"]:
                hideregisters = 1
            elif data["id"] == "v":
                hideregisters = 1

            outlist.append("%s#%s\n%s\n" % (showall, "-" * 50, addr + cmd))

    outlist.append(showpatt + showhold)  # last line status

    # executing sed script
    cmdextra = ""
    if "_stdout-only" in action_modifiers:
        # cmdextra = "| egrep -v '^PATT|^HOLD|^COMM|\$$|\\$'"  # sed
        cmdextra = "-l 9999 | egrep -v '^PATT|^HOLD|^COMM'"  # gsed
    inputfiles = " ".join(textfiles)
    if dump_debug:
        for line in [re.sub("\n$", "", x) for x in outlist]:
            print(line)
        print(
            "\n# Debugged SED script generated by %s-%s (%s)"
            % (myname, __version__, myhome)
        )
    else:
        tmpfile = tempfile.mktemp()
        write_file(tmpfile, outlist)
        E_opt = '-E' if E_flag else ''
        os.system(
            "%s %s -%s %s %s %s" % (sedbin, E_opt, cmdlineopts, tmpfile, inputfiles, cmdextra)
        )
        os.remove(tmpfile)


###############################################################################
#                                                                             #
#                               SED Script Parser                             #
#                           -------------------------                         #
#                      Extract Every Info of Every Command                    #
#                                                                             #
###############################################################################
#
# Here we used to have a custom brute force buggy parser.
# Now we are using sedparse, a direct translation of the GNU sed C code.
#
# To avoid having to adapt the whole sedsed code to the sedparse AST, the
# following `parse()` function will convert the sedparse AST into the same AST
# used by the old parser: a list having a flat dictionary for each command.
#
# TODO properly document sedsed and sedparse AST's


def parse(sedscript):
    """
    Parse the sedscript (a list of strings) and return a sedsed AST (a flat list
    of dictionaries).
    """
    the_program = []
    ret = []
    ret.append({})  # for header

    # Parse the sed script and save the output to `the_program`
    sedparse.compile_string(the_program, "\n".join(sedscript) + "\n")

    ### Translate from GNU sed struct_sed_cmd objects to sedsed ZZ objects

    # Flag to detect if there's at least one 't' or 'T' command in the script.
    # If so, some special treatment is required in the debugger.
    has_t = 0

    # Stores the lastest address. When an empty address command such as //p or
    # s//foo/ is found, this value will be saved into `cmddict['lastaddr']`.
    lastaddr = ""

    def set_address(gsed_data, sedsed_data, prefix="addr1"):
        if not gsed_data:
            return

        if gsed_data.addr_regex:
            # set cmddict['addr1'] = /foo/
            sedsed_data[prefix] = "%s%s%s%s" % (
                gsed_data.addr_regex.escape(),
                gsed_data.addr_regex.slash,
                gsed_data.addr_regex.pattern,
                gsed_data.addr_regex.slash,
            )

            # set cmddict['addr1html']
            sedsed_data[prefix + "html"] = "%s%s%s%s" % (
                paint_html("escape", gsed_data.addr_regex.escape()),
                paint_html("delimiter", gsed_data.addr_regex.slash),
                paint_html("pattern", gsed_data.addr_regex.pattern),
                paint_html("delimiter", gsed_data.addr_regex.slash),
            )

            # set cmddict['addr1flag'] = I
            sedsed_data[prefix + "flag"] = gsed_data.addr_regex.flags

        else:
            # set cmddict['addr1'] = 99 | $
            sedsed_data[prefix] = str(gsed_data)
            sedsed_data[prefix + "html"] = paint_html("pattern", str(gsed_data))

    # For each sed command found by the parser
    for xx in the_program:

        # Set empty dict with all the keys
        cmddict = {}
        for key in cmdfields:
            cmddict[key] = ""

        cmddict["id"] = xx.cmd
        cmddict["linenr"] = xx.line

        if xx.addr_bang:
            cmddict["modifier"] = "!"

        set_address(xx.a1, cmddict, "addr1")
        set_address(xx.a2, cmddict, "addr2")

        # Special case for regex addresses
        # Set cmddict['lastaddr'] for the current command when the address is
        # empty //. Otherwise just update the lastaddr holder.
        # TODO investigate bug in sedsed if both addresses are regexes, the
        #     'reset' address command should involve both addresses again, and
        #     not only `lastaddr`
        if xx.a1 and xx.a1.addr_regex:
            if not xx.a1.addr_regex.pattern:
                cmddict["lastaddr"] = lastaddr
            else:
                lastaddr = cmddict["addr1"] + cmddict["addr1flag"]
        if xx.a2 and xx.a2.addr_regex:
            if not xx.a2.addr_regex.pattern:
                cmddict["lastaddr"] = lastaddr
            else:
                lastaddr = cmddict["addr2"] + cmddict["addr2flag"]

        if xx.cmd == "\n":
            cmddict["id"] = ""

        elif xx.cmd == "#":
            cmddict["comment"] = "#" + xx.x.comment

            # 1st line, try to find #!/...
            if cmddict["linenr"] == 1:
                m = re.match(topopts_regex, cmddict["comment"])
                if m:  # we have options!
                    ret[0]["topopts"] = m.group(1)  # saved on list header
                    del m

        elif xx.cmd in sedcmds["solo"] + sedcmds["block"]:
            pass  # nothing else to collect

        elif xx.cmd in sedcmds["text"]:
            if str(xx.x.cmd_txt):  # command "e" is allowed to be empty
                cmddict["content"] = "\\%s%s" % (
                    linesep,
                    str(xx.x.cmd_txt).replace("\n", linesep),
                )

        elif xx.cmd in sedcmds["jump"] + "v":
            cmddict["content"] = xx.x.label_name

        elif xx.cmd in sedcmds["file"]:
            cmddict["content"] = xx.x.fname

        elif xx.cmd in sedcmds["int"]:
            if xx.x.int_arg > -1:
                cmddict["content"] = str(xx.x.int_arg)

        elif xx.cmd in sedcmds["multi"]:  # s/// & y///
            cmddict["delimiter"] = xx.x.cmd_subst.regx.slash
            cmddict["pattern"] = str(xx.x.cmd_subst.regx.pattern)
            cmddict["replace"] = str(xx.x.cmd_subst.replacement.text).replace(
                "\n", linesep
            )
            cmddict["flag"] = "".join(xx.x.cmd_subst.regx.flags)
            if "w" in cmddict["flag"]:
                cmddict["content"] = xx.x.cmd_subst.outf.name

        ## save sedsed specific data

        # saving last address content
        if xx.cmd == "s":
            if cmddict["pattern"]:
                lastaddr = (
                    xx.x.cmd_subst.regx.escape()
                    + cmddict["delimiter"]
                    + cmddict["pattern"]
                    + cmddict["delimiter"]
                )
            else:
                cmddict["lastaddr"] = lastaddr

        if xx.cmd in ("t", "T"):
            has_t = 1

        ret.append(cmddict)

    # populating list header
    ret[0]["fields"] = cmdfields
    ret[0]["has_t"] = has_t

    return ret


def fix_partial_comments(commands):
    """
    Scan all commands and move comments to the previous command, if necessary.

    If there's only one command in the line, and a comment at the end, being it
    preceded by a ';' or not, this comment will be "tied" to the command.
    Examples:

        /foo/ d    # remove foo
        /bar/ d   ;# remove bar

    In both cases, the comment will be moved to the 'comment' field of
    the respective 'd' command. The --indent output will be:

        /foo/ d                                ;# remove foo
        /bar/ d                                ;# remove bar
    """
    headers = commands[0]
    data = commands[1:]

    accept_comment = (
        sedcmds["solo"]
        + sedcmds["block"]
        + sedcmds["jump"]
        + sedcmds["multi"]
        + sedcmds["int"]
        + "v"
    )

    fake = {"linenr": 0}
    data.insert(0, fake)  # because of i-2
    data.append(fake)  # because of i+1

    # i==0  skip: it's the fake
    # i==1  skip: first command (nothing previous to append)
    # i==2  good: first possible partial comment
    # last  skip: it's the fake
    i = 2
    while i < len(data) - 1:
        # Move solo comment into previous command as partial comment when...
        if (
            data[i]["id"] == "#"
            # ...previous command accepts comments
            and data[i - 1]["id"] in accept_comment
            # ...there's only *one* previous command in the same source line
            and data[i]["linenr"] != data[i - 2]["linenr"]
            and data[i]["linenr"] == data[i - 1]["linenr"]
            and data[i]["linenr"] != data[i + 1]["linenr"]
        ):

            # Move solo comment to previous command
            data[i - 1]["comment"] = data[i]["comment"]
            del data[i]
            # Since we're removing, 'i' won't be incremented
        else:
            i += 1

    return [headers] + data[1:-1]  # remove fakes


def entrypoint():
    parse_command_line()

    # When debugging, the system's sed will be used to run the modified script.
    # So it's mandatory that the original script is runnable in that specific
    # sed version (i.e., no syntax errors and no unknown commands or flags).
    if action == "debug":
        validate_script_syntax(sedscript)

    # Parse the script and process/fix the resulting data.
    # AST is sedsed's internal data structure to represent a sed script.
    try:
        AST = fix_partial_comments(parse(sedscript))
    except sedparse.ParseError as err:
        fatal_error(err.message)

    if action == "indent":
        print("\n".join(dump_script(AST, indent_prefix)))
    elif action == "html":
        print("\n".join(dump_script(AST, indent_prefix)))
    elif action == "debug":
        do_debug(AST)
    elif action == "token":
        print("\n".join(dump_key_value_pair(AST)))
    elif action == "dumpcute":
        print("\n".join(dump_cute(AST)))


if __name__ == "__main__":
    entrypoint()
