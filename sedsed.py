#!/usr/bin/env python
# sedsed - Debugger, indenter and HTMLizer for sed scripts
# Since 27 November 2001, by Aurelio Jargas

__version__ = '1.1-dev'

import sys
import re
import os
import getopt
import tempfile

myname = 'sedsed'
myhome = 'http://aurelio.net/projects/sedsed/'


# -----------------------------------------------------------------------------
#                              User Configuration
# -----------------------------------------------------------------------------


# Default config - Changeable, but you won't need to do it
sedbin = 'sed'                # name (or full path) of the sed program
color = 1                     # colored output or not? (--color, --nocolor)
dump_debug = 0                # dump debug script to screen? (--dump-debug)
indent_prefix = ' '*4         # default indent prefix for blocks (--prefix)
debug_prefix = '\t\t'         # default prefix for debug commands
action = 'indent'             # default action if none specified (-d,-i,-t,-H)
DEBUG = 0                     # set developer's debug level [0-3]
EMUDEBUG = 0                  # emulator has its own debug [0-3]

# HTML colors for --htmlize
# You may edit here to change the default colors
html_colors = {
    'addr1':     '#8080ff',
    'addr1flag': '#ff6060',
    'addr2':     '#8080ff',
    'addr2flag': '#ff6060',
    'lastaddr':  '',
    'modifier':  '#ff6060',
    'id':        '#ffff00',
    'content':   '#ff00ff',
    'delimiter': '#ff6060',
    'pattern':   '#8080ff',
    'replace':   '',
    'flag':      '#00ff00',
    'extrainfo': '',
    'comment':   '#00ffff',
    'escape':    '#ff6060',
    'special':   '#00ff00',
    'pattmeta':  '#ff00ff',
    'plaintext': '',
    'branch':    '',
    'BGCOLOR':   '#000000',
    'TEXT':      '#ffffff',
    'LINK':      '#ff00ff',
    'ALINK':     '#ff00ff',
    'VLINK':     '#ff00ff'
}

# The identifier recognized by sed as STDIN
if os.name == 'nt':
    # Windows do not have /dev/stdin, maybe '-' is supported by sed
    stdin_id = '-'
else:
    # BSD sed fails for '-', use /dev/stdin as the default in Unix
    stdin_id = '/dev/stdin'


# -----------------------------------------------------------------------------
#                              General Functions
# -----------------------------------------------------------------------------


def print_usage(exitcode=1):
    print("""
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

         --emu           emulates GNU sed (INCOMPLETE)
         --emudebug      emulates GNU sed debugging the sed script (INCOMPLETE)

     -i, --indent        script beautifier, prints indented and
                         one-command-per-line output do STDOUT
         --prefix        indent prefix string (default: 4 spaces)

     -t, --tokenize      script tokenizer, prints extensive
                         command by command information
     -H, --htmlize       converts sed script to a colorful HTML page

     -V, --version       prints the program version and exit
     -h, --help          prints this help message and exit


NOTE: The --emu and --emudebug options are still INCOMPLETE and must
      be used with care. Mainly regexes and address $ (last line)
      are not handled right by the emulator.
""")
    print("Website: %s\n" % myhome)
    sys.exit(exitcode)


def fatal_error(msg):
    "All error messages are handled by me"
    print('ERROR: %s' % msg)
    sys.exit(1)


def echo(msg):
    print("\033[33;1m%s\033[m" % msg)


def devdebug(msg, level=1):
    if DEBUG and DEBUG >= level:
        print('+++ DEBUG%d: %s' % (level, msg))


def read_file(file_path):
    "Reads a file into a list, removing line breaks"

    if file_path in (stdin_id, '-'):
        try:
            data = sys.stdin.readlines()
        except:
            fatal_error('I was expecting data on STDIN!')
    else:
        try:
            f = open(file_path)
            data = f.readlines()
            f.close()
        except:
            fatal_error("Cannot read file: %s" % file_path)
    return [re.sub('[\n\r]+$', '', x) for x in data]


def write_file(file_path, lines):
    "Writes a list contents into file, adding correct line breaks"

    try:
        f = open(file_path, 'w')
    except:
        fatal_error("Cannot open file for writing: %s" % file_path)

    # TODO maybe use os.linesep? - all this is really necessary?
    # ensuring line break
    lines = [re.sub('\n$', '', x) + '\n' for x in lines]
    f.writelines(lines)
    f.close()


def system_command(cmd):  # Returns a (#exit_code, program_output[]) tuple
    # TODO don't use popen()
    output = []
    fd = os.popen(cmd)
    for line in fd.readlines():
        output.append(line.rstrip())  # stripping \s*\n
    ret = fd.close()
    if ret:
        ret = ret / 256  # 16bit number
    return ret, output


# -----------------------------------------------------------------------------
#                           Command line & Config
# -----------------------------------------------------------------------------


# Here's all the valid command line options
short_options = 'he:f:ditVHn'
long_options = [
    'debug', 'tokenize', 'htmlize', 'indent',                       # actions
    'version', 'help', 'file=', 'expression=', 'silent', 'quiet',   # sed-like
    'nocolor', 'color', 'hide=', 'prefix=', 'emu', 'emudebug',      # misc
    'dump-debug',                                                   # other
    '_debuglevel=', '_emudebuglevel=', '_stdout-only', 'dumpcute']  # admin

# Check it!
try:
    opt, args = getopt.getopt(sys.argv[1:], short_options, long_options)
except getopt.error as errmsg:
    fatal_error("%s (try --help)" % errmsg)

# Turn color OFF on Windows because ANSI.SYS is not installed by default.
# Windows users who have ANSI.SYS configured, can use the --color option
# or comment the following line.
# ANSI.SYS resources:
#   http://www.evergreen.edu/biophysics/technotes/program/ansi_esc.htm#notes
#   http://www3.sympatico.ca/rhwatson/dos7/v-ansi-escseq.html
if os.name == 'nt':
    color = 0

# Command Line is OK, now let's parse its values
action_modifiers = []             # --hide contents and others
sedscript = []                    # join all scripts found here
script_file = ''                  # old sedscript filename for --htmlize
quiet_flag = 0                    # tell if the #n is needed or not

for o in opt:
    if o[0] in ('-d', '--debug'):
        action = 'debug'

    elif o[0] in ('-i', '--indent'):
        action = 'indent'
        color = 0

    elif o[0] in ('-t', '--tokenize'):
        action = 'token'
        color = 0

    elif o[0] in ('-H', '--htmlize'):
        action = 'html'
        color = 0

    elif o[0] in ('-n', '--quiet'):
        quiet_flag = 1

    elif o[0] in ('-e', '--expression'):
        sedscript.extend(o[1].split('\n'))

    elif o[0] in ('-f', '--file'):
        sedscript.extend(read_file(o[1]))
        script_file = o[1]

    elif o[0] in ('-h', '--help'):
        print_usage(0)

    elif o[0] in ('-V', '--version'):
        print('%s v%s' % (myname, __version__))
        sys.exit(0)

    elif o[0] == '--emu':
        action = 'emu'

    elif o[0] == '--emudebug':
        action = 'emudebug'

    elif o[0] == '--dump-debug':
        action = 'debug'
        dump_debug = 1
        color = 0

    elif o[0] == '--nocolor':
        color = 0

    elif o[0] == '--color':
        color = 1

    elif o[0] == '--hide':                  # get hide options
        for hide in o[1].split(','):        # save as no<OPT>
            hide_me = hide.strip().lower()
            action_modifiers.append('no' + hide_me)

    elif o[0] == '--prefix':
        if re.sub(r'\s', '', o[1]):         # prefix is valid?
            fatal_error("--prefix: must be spaces and/or TABs")
        indent_prefix = o[1]

    # Undocumented admin options

    elif o[0] == '--_debuglevel':
        DEBUG = int(o[1])

    elif o[0] == '--_emudebuglevel':
        EMUDEBUG = int(o[1])

    elif o[0] == '--_stdout-only':
        action = 'debug'
        action_modifiers.append(o[0][2:])

    elif o[0] == '--dumpcute':
        action = 'dumpcute'
        DEBUG = 0
        color = 1

# Now all Command Line options were successfully parsed


# -----------------------------------------------------------------------------
#                              Sanity Checks
# -----------------------------------------------------------------------------


def validate_script_syntax(script_text):
    """Validate a sed script using system's sed."""

    # Using tmpfile2 because "sed -f script /dev/null" won't work in Windows
    tmpfile1 = tempfile.mktemp()
    tmpfile2 = tempfile.mktemp()
    write_file(tmpfile1, script_text)
    write_file(tmpfile2, '')
    try:
        # sed -f sed_script empty_file
        ret, msg = system_command("%s -f '%s' '%s'" % (
            sedbin, tmpfile1, tmpfile2))
    except:
        # popen(), used in system_command, is broken on Win9x machines
        # https://docs.python.org/2.6/faq/windows.html
        ret = None
    os.remove(tmpfile1)
    os.remove(tmpfile2)

    if ret:
        msg = 'syntax error on your SED script, please fix it before.'
        fatal_error('#%d: %s' % (ret, msg))


# There's a SED script?
if not sedscript:
    if args:          # the script is the only argument (echo | sed 's///')
        sedscript.append(args.pop(0))
    else:             # :(
        fatal_error("there's no SED script to parse! (try --help)")

# Get all text files, if none, use STDIN
textfiles = args or [stdin_id]

# On --debug, check the given script syntax, running SED with it.
# We will not debug a broken script.
if action == 'debug':
    validate_script_syntax(sedscript)


# -----------------------------------------------------------------------------
#                    Internal Config Adjustments and Magic
# -----------------------------------------------------------------------------


# Add the leading #n to the sed script, when using -n
if quiet_flag:
    sedscript.insert(0, '#n')

# Add the terminal escapes for color (or not)
if color:
    color_YLW = '\033[33;1m'  # yellow text
    color_RED = '\033[31;1m'  # red text
    color_REV = '\033[7m'     # reverse video
    color_NO  = '\033[m'      # back to default
else:
    color_YLW = color_RED = color_REV = color_NO = ''


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
#
#                   --- THANK YOU VERY MUCH ---
#
# - Paolo Bonzini (GNU sed 4.x maintainer) for the idea of the
#   't status' trick.
#
# - Thobias Salazar Trevisan for the idea of using the 'i'
#   command for the COMM: lines.
#

# show pattern space, show hold space, show sed command
# null sed command to restore last address, 't' status trick
showpatt = [     's/^/PATT:/', 'l', 's/^PATT://'     ]
showhold = ['x', 's/^/HOLD:/', 'l', 's/^HOLD://', 'x']
showcomm = ['i\\', 'COMM:%s\a%s' % (color_YLW, color_NO)]
nullcomm = ['y/!/!/']
save_t   = ['t zzset\a\n#DEBUG#', 't zzclr\a',
            ':zzset\a\n#DEBUG#', ':zzclr\a']


def format_debugcmds(cmds):
    "One per line, with prefix (spaces)"
    return debug_prefix + ('\n' + debug_prefix).join(cmds) + '\n'

showpatt = format_debugcmds(showpatt)
showhold = format_debugcmds(showhold)
save_t   = format_debugcmds(save_t)
showcomm = debug_prefix + '\n'.join(showcomm) + '\n'
nullcomm = nullcomm[0]


# If user specified --hide, unset DEBUG commands for them
if action_modifiers.count('nopatt'):
    showpatt = ''
if action_modifiers.count('nohold'):
    showhold = ''
if action_modifiers.count('nocomm'):
    showcomm = ''


# Compose HTML page header and footer info for --htmlize.
# The SCRIPTNAME is added then removed from html_colors for
# code convenience only.
#
html_colors['SCRIPTNAME'] = os.path.basename(script_file)
html_data = {
    'header': """\
<html>
<head><meta name="Generator" content="sedsed --htmlize">
<title>Colorized %(SCRIPTNAME)s</title></head>
<body bgcolor="%(BGCOLOR)s" text="%(TEXT)s"
      link="%(LINK)s" alink="%(ALINK)s" vlink="%(VLINK)s">
<pre>\
""" % html_colors,

    'footer': """
<font color="%s"><b>### colorized by <a \
href="%s">sedsed</a>, a SED script \
debugger/indenter/tokenizer/HTMLizer</b></font>\n
</pre></body></html>\
""" % (html_colors['comment'], myhome)
}
del html_colors['SCRIPTNAME']


# -----------------------------------------------------------------------------
#                              SED Machine Data
# -----------------------------------------------------------------------------


# All SED commands grouped by kind
sedcmds = {
    'file':  'rw',
    'addr':  '/$0123456789\\',
    'multi': 'sy',
    'solo':  'nNdDgGhHxpPlq=',
    'text':  'aci',
    'jump':  ':bt',
    'block': '{}',
    'flag':  'gp0123456789w' + 'IiMme'  # default + GNU
}

# Regex patterns to identify special entities
patt = {
    'jump_label': r'[^\s;}#]*',              # _any_ char except those, or None
    'filename':   r'[^\s]+',                 # _any_ not blank char (strange..)
    'flag':       r'[%s]+' % sedcmds['flag'],  # list of all flags
    'topopts':    r'#!\s*/[^\s]+\s+-([nf]+)'   # options on #!/bin/sed header
}

# All fields used by the internal SED command dictionary
cmdfields = [
    'linenr',
    'addr1', 'addr1flag', 'addr2', 'addr2flag', 'lastaddr', 'modifier',
    'id', 'content', 'delimiter', 'pattern', 'replace', 'flag',
    'extrainfo', 'comment'
]
# XXX Don't change the order! There is a piggy cmdfields[6:] ahead


# -----------------------------------------------------------------------------
#                         Auxiliary Functions - Tools
# -----------------------------------------------------------------------------


def escape_text_commands_specials(text):
    text = text.replace('\\', '\\\\')               # escape escape
    return text


def is_open_bracket(text):
    # bracket open:  [   \\[   \\\\[ ...
    # not bracket : \[  \\\[  \\\\\[ ...
    isis = 0
    delim = '['
    text = re.sub(r'\[:[a-z]+:]', '', text)         # del [:charclasses:]
    if text.find(delim) == -1:                      # hey, no brackets!
        return 0

    # Only the last two count
    patterns = text.split(delim)[-2:]
    devdebug('bracketpatts: %s' % patterns, 3)
    possibleescape, bracketpatt = patterns

    # Maybe the bracket is escaped, and is not a metachar?
    m = re.search(r'\\+$', possibleescape)          # escaped bracket
    if m and len(m.group(0)) % 2:                   # odd number of escapes
        devdebug('bracket INVALID! - escaped', 2)
        isis = 0
    elif bracketpatt.find(']') == -1:               # not closed by ]
        devdebug('bracket OPEN! - found! found!', 2)
        isis = 1                                    # it is opened! :)

    return isis


def paint_html(element, txt=''):
    if not txt:
        return txt  # nothing to paint

    # Escape HTML special chars
    txt = txt.replace('&', '&amp;')
    txt = txt.replace('>', '&gt;')
    txt = txt.replace('<', '&lt;')

    # Some color adjustments and emphasis
    if element == 'id' and txt in sedcmds['block']:
        element = 'delimiter'

    elif element == 'id' and txt == ':':
        element = 'content'

    elif element == 'replace':
        # highlight \n, & and \$
        newtxt = paint_html('special', '\\' + linesep)
        txt = txt.replace('\\' + linesep, newtxt)
        txt = re.sub('(\\\\[1-9]|&amp;)', paint_html('special', '\\1'), txt)

    elif element == 'pattern':
        # highlight ( and |
        txt = re.sub(
            '(\\\\)([(|])',
            '\\1' + paint_html('pattmeta', '\\2'),
            txt)

    elif element == 'plaintext':
        # highlight \$
        newtxt = paint_html('special', '\\' + linesep)
        txt = txt.replace('\\' + linesep, newtxt)

    elif element == 'branch':
        # nice link to the label
        txt = '<a href="#%s">%s</a>' % (txt, txt)

    elif element == 'target':
        # link target
        txt = '<a name="%s">%s</a>' % (txt, txt)
        element = 'content'

    # Paint it!
    if html_colors.get(element) and txt:
        font_color = html_colors[element]
        txt = '<font color="%s"><b>%s</b></font>' % (font_color, txt)
    return txt


# -----------------------------------------------------------------------------
#                 SedCommand class - Know All About Commands
# -----------------------------------------------------------------------------


# TIP: SedCommand already receives lstrip()ed data and data != None
class SedCommand(object):
    def __init__(self, abcde):
        self.id = abcde[0]   # s
        self.content = ''    # txt, filename
        self.modifier = ''   # !
        self.full = ''       # !s/abc/def/g

        # for s/// & y///
        self.pattern = ''    # abc
        self.replace = ''    # def
        self.delimiter = ''  # /
        self.flag = ''       # g

        self.isok = 0
        self.comment = ''
        self.rest = self.junk = abcde
        self.extrainfo = ''

        if self.id == '!':
            self.modifier = self.id                  # set modifier
            self.junk = self.junk[1:].lstrip()       # del !@junk
            self.id = self.junk[0]                   # set id again
        self.junk = self.junk[1:]                     # del id@junk

        # self.setId()
        self.do_it_all()

    def do_it_all(self):
        # here, junk arrives without the id, but not lstripped (s///)
        sedcmd = self.id

        # TODO put pending comment on the previous command (h ;#comm)
        if sedcmd == '#':
            devdebug('type: comment', 3)
            self.comment = self.id + self.junk
            self.junk = ''
            self.isok = 1

        elif sedcmd in sedcmds['solo']:
            devdebug('type: solo', 3)
            self.isok = 1

        elif sedcmd in sedcmds['block']:
            devdebug('type: block', 3)
            self.isok = 1

        elif sedcmd in sedcmds['text']:
            devdebug('type: text', 3)

            # if not \ at end, finished
            if self.junk[-1] != '\\':

                # ensure \LineSep at beginning
                self.content = re.sub(r'^\\%s' % linesep, '', self.junk)
                self.content = '\\%s%s' % (linesep, self.content)
                self.isok = 1

        elif sedcmd in sedcmds['jump']:
            devdebug('type: jump', 3)

            self.junk = self.junk.lstrip()
            m = re.match(patt['jump_label'], self.junk)
            if m:
                self.content = m.group()
                self.junk = self.junk[m.end():]
                self.isok = 1

        elif sedcmd in sedcmds['file']:
            # TODO deal with valid cmds like 'r bla;bla' and 'r bla ;#comm'
            # TODO spaces and ; are valid as filename chars
            devdebug('type: file', 3)

            self.junk = self.junk.lstrip()
            m = re.match(patt['filename'], self.junk)
            if m:
                self.content = m.group()
                self.junk = self.junk[m.end():]
                self.isok = 1

        elif sedcmd in sedcmds['multi']:  # s/// & y///
            devdebug('type: multi', 3)

            self.delimiter = self.junk[0]
            ps = SedAddress(self.junk, 'pattern')
            hs = ''
            if ps.isok:
                self.pattern = ps.pattern
                self.junk = ps.rest
                # 'replace' opt to avoid openbracket check,
                # because 's/bla/[/' is ok
                hs = SedAddress(self.delimiter + self.junk, 'replace')
                if hs.isok:
                    self.replace = hs.pattern
                    self.junk = hs.rest.lstrip()

                    # great, s/patt/rplc/ successfully taken

            # there are flags?
            if hs and hs.isok and self.junk:
                devdebug('possible s/// flag: %s' % self.junk, 3)

                m = re.match(r'(%s\s*)+' % patt['flag'], self.junk)
                if m:
                    self.flag = m.group()
                    self.junk = self.junk[m.end():].lstrip()  # del flag
                    self.flag = re.sub(r'\s', '', self.flag)  # del blanks@flag
                    devdebug('FOUND s/// flag: %s' % (self.flag.strip()))

                    # now we've got flags also

                # write file flag
                if 'w' in self.flag:
                    m = re.match(patt['filename'], self.junk)
                    if m:
                        self.content = m.group()
                        devdebug('FOUND s///w filename: %s' % self.content)
                        self.junk = self.junk[m.end():].lstrip()

                        # and now, s///w filename
                        # is saved also

            if hs and hs.isok:
                self.isok = 1

        else:
            fatal_error("invalid SED command '%s' at line %d" % (
                sedcmd, linenr))

        if self.isok:
            self.full = compose_sed_command(vars(self))
            self.full = self.full.replace('\n', linesep)
            self.rest = self.junk.lstrip()
            devdebug('FOUND command: %s' % self.full)
            devdebug('rest left: %s' % self.rest, 2)

            possiblecomment = self.rest
            if possiblecomment and possiblecomment[0] == '#':
                self.comment = possiblecomment
                devdebug('FOUND comment: %s' % self.comment)
        devdebug('SedCommand: %s' % vars(self), 3)


# -----------------------------------------------------------------------------
#                 SedAddress class - Know All About Addresses
# -----------------------------------------------------------------------------


# TIP an address is NOT multiline
class SedAddress(object):
    def __init__(self, abcde, context='address'):
        self.delimiter = ''
        self.pattern = ''
        self.flag = ''
        self.full = ''
        self.html = ''

        self.isline = 0
        self.isok = 0
        self.escape = ''
        self.rest = self.junk = abcde
        self.context = context  # address, pattern, replace

        self.set_type()                           # numeric or pattern?
        self.do_it_all()
        devdebug('SedAddress: %s' % vars(self), 3)

    def do_it_all(self):
        if self.isline:
            self.set_line_address()
        else:
            self.set_pattern_address()

        if self.isok:
            self.full = '%s%s%s%s' % (
                self.escape,
                self.delimiter,
                self.pattern,
                self.delimiter)
            if action == 'html':
                self.html = '%s%s%s%s' % (
                    paint_html('escape',    self.escape),
                    paint_html('delimiter', self.delimiter),
                    paint_html('pattern',   self.pattern),
                    paint_html('delimiter', self.delimiter))
            devdebug('FOUND addr: %s' % self.full)

            cutlen = len(self.full) + len(self.flag)
            self.rest = self.rest[cutlen:]      # del junk's addr
            self.flag = self.flag.strip()       # del flag's blank
            devdebug('rest left: %s' % self.rest, 2)
        else:
            devdebug('OH NO! partial addr: %s' % self.rest)

    def set_type(self):
        first = self.junk[0]
        if re.match('[0-9$]', first):      # numeric addr, easy!
            self.isline = 1
        else:                              # oh no, pattern
            if first == '\\':              # strange delimiter (!/)
                self.escape = '\\'
                self.junk = self.junk[1:]  # del escape
            self.delimiter = self.junk[0]  # set delimiter
            self.junk = self.junk[1:]      # del delimiter@junk

    def set_line_address(self):
        m = re.match(r'[0-9]+|\$', self.junk)
        self.pattern = m.group(0)
        self.isok = 1

    def set_pattern_address(self):
        ###
        # similar to command finder:
        # - split at pattern delimiter
        # - if address not terminated, join with next split chunk (loop)
        # - address found, return it
        #
        # We can deal with really catchy valid addresses like:
        #   /\/[/]\\/   and   \;\;[;;]\\;
        incompleteaddr = ''

        devdebug('addr delimiter: ' + self.delimiter, 2)
        patterns = self.junk.split(self.delimiter)
        devdebug('addr patterns: %s' % patterns, 2)

        while patterns:
            possiblepatt = patterns.pop(0)

            # if address not terminated, join next
            if incompleteaddr:
                possiblepatt = self.delimiter.join(
                    [incompleteaddr, possiblepatt])
                incompleteaddr = ''
            devdebug('possiblepatt: ' + possiblepatt, 2)

            # maybe split at a (valid) escaped delimiter?
            if re.search(r'\\+$', possiblepatt):
                m = re.search(r'\\+$', possiblepatt)
                if len(m.group(0)) % 2:
                    devdebug('address INCOMPLETE! - ends with \\ alone')
                    incompleteaddr = possiblepatt
                    continue

            if self.context != 'replace':
                # maybe split at a delimiter inside
                # char class []?
                # BUG: []/[] is not caught - WONTFIX
                if is_open_bracket(possiblepatt):
                    devdebug('address INCOMPLETE! - open bracket')
                    incompleteaddr = possiblepatt
                    continue

            break                          # it's an address!

        # must have something left
        if patterns:

            # the rest is a flag?
            if patterns[0] and self.context == 'address':
                devdebug('possible addr flag: %s' % patterns[0], 3)

                m = re.match(r'\s*I\s*', patterns[0])
                if m:
                    # yes, a flag, set addr flag
                    self.flag = m.group()
                    devdebug('FOUND addr flag: %s' % (self.flag.strip()))

            self.pattern = possiblepatt
            self.isok = 1


# -----------------------------------------------------------------------------
#                 Hardcore Address/Command Composer Functions
# -----------------------------------------------------------------------------


def compose_sed_address(data):
    """Format the full sed address as plain text or HTML."""
    if not data['addr1']:
        return ''  # no address

    if action == 'html':
        address1 = '%s%s' % (
            data['addr1html'],
            paint_html('addr1flag', data.get('addr1flag')))
        address2 = '%s%s' % (
            data.get('addr2html'),
            paint_html('addr2flag', data.get('addr2flag')))
    else:
        address1 = '%s%s' % (data.get('addr1'), data.get('addr1flag'))
        address2 = '%s%s' % (data.get('addr2'), data.get('addr2flag'))

    if data['addr2']:
        address = '%s,%s' % (address1, address2)
    else:
        address = address1

    return address + ' '  # address, space, (command)


def compose_sed_command(data):
    if data['delimiter']:         # s///
        if action != 'html':
            cmd = '%s%s%s%s%s%s%s%s' % (
                data['modifier'],  data['id'],
                data['delimiter'], data['pattern'],
                data['delimiter'], data['replace'],
                data['delimiter'], data['flag'])
            if data['content']:   # s///w filename
                cmd = cmd + ' ' + data['content']
        else:
            cmd = """%s%s%s%s%s%s%s%s""" % (
                paint_html('modifier',  data['modifier']),
                paint_html('id',        data['id']),
                paint_html('delimiter', data['delimiter']),
                paint_html('pattern',   data['pattern']),
                paint_html('delimiter', data['delimiter']),
                paint_html('replace',   data['replace']),
                paint_html('delimiter', data['delimiter']),
                paint_html('flag',      data['flag']))
            if data['content']:   # s///w filename
                painted = paint_html('content', data['content'])
                cmd = '%s %s' % (cmd, painted)
    else:
        idsep = ''
        # spacer on r,w,b,t commands only
        spaceme = sedcmds['file'] + sedcmds['jump']
        spaceme = spaceme.replace(':', '')  # : label (no space!)
        if data['id'] in spaceme:
            idsep = ' '
        cmd = '%s%s%s%s' % (
              data['modifier'],
              data['id'],
              idsep,
              data['content'])
        if action == 'html':
            if data['id'] in sedcmds['text']:
                content_type = 'plaintext'
            elif data['id'] in 'bt':
                content_type = 'branch'
            elif data['id'] == ':':
                content_type = 'target'
            else:
                content_type = 'content'

            cmd = '%s%s%s%s' % (
                paint_html('modifier', data['modifier']),
                paint_html('id', data['id']),
                idsep,
                paint_html(content_type, data['content']))
    cmd = cmd.replace(linesep, '\n')
    return cmd


# -----------------------------------------------------------------------------
#                    The dump* Functions - They 4mat 4you!
# -----------------------------------------------------------------------------


def dump_key_value_pair(datalist):
    "Shows field:value command data line by line (lots of lines!)"
    for data in datalist[1:]:                         # skip headers at 0
        if not data['id']:
            continue                                  # blank line
        for key in datalist[0]['fields']:
            if key == 'replace':
                data[key] = data[key].replace(linesep, newlineshow)
            print("%10s:%s" % (key, data[key]))
        print('')


# Format: line:ad1:ad1f:ad2:ad2f:mod:cmd:content:delim:patt:rplc:flag:comment
def dump_oneliner(datalist, fancy=0):
    "Shows a command per line, elements separated by : (looooong lines)"
    r = n = ''
    if fancy:
        r = '\033[7m'
        n = '\033[m'
    for data in datalist[1:]:                         # skip headers at 0
        outline = data['linenr']
        if data['id']:
            for key in datalist[0]['fields'][1:]:     # skip linenr
                outline = '%s:%s%s%s' % (outline, r, data[key], n)
        print(outline)


def dump_cute(datalist):
    "Shows a strange representation of SED commands. Use --dumpcute."
    r = color_REV
    n = color_NO
    for data in datalist[1:]:                         # skip headers at 0
        if not data['id']:
            print('%40s' % '[blank]')
        elif data['id'] == '#':
            print(data['comment'])
        else:
            idsep = ''
            if data['id'] in 'bt':
                idsep = ' '
            cmd = '%s%s%s%s' % (
                  data['modifier'],
                  data['id'],
                  idsep,
                  data['content'])
            if data['delimiter']:
                cmd = '%s%s%s%s%s%s%s' % (
                    cmd,
                    data['delimiter'], data['pattern'],
                    data['delimiter'], data['replace'],
                    data['delimiter'], data['flag'])
            cmd = cmd.replace(linesep, n + newlineshow + r)
            print('%s' % '-'*40)
            print('adr: %s%s%s%s  :::  %s%s%s%s' % (
                r, data['addr1'], data['addr1flag'], n,
                r, data['addr2'], data['addr2flag'], n))
            print('cmd: %s%s%s   [%s]' % (r, cmd, n, data['comment']))


# dump_script: This is a handy function, used by --indent AND --htmlize
# It formats the SED script in a human-friendly way, with one command
# per line and adding spaces on the right places. If --htmlize, it
# also adds the HTML code to the script.
#
def dump_script(datalist, indent_prefix):
    "Shows the indented script in plain text or HTML!"
    indfmt = {
        'string': indent_prefix,
        'initlevel': 0}
    outlist = []
    indent = indfmt['initlevel']

    if action == 'html':
        outlist.append(html_data['header'])

    for data in datalist[1:]:                         # skip headers at 0
        if not data['id']:
            outlist.append('')
            continue                                  # blank line
        if data['id'] == '#':
            indentstr = indfmt['string']*indent
            if action != 'html':
                outlist.append('%s%s' % (
                               indentstr,
                               data['comment']))
            else:
                outlist.append('%s%s' % (
                               indentstr,
                               paint_html('comment',
                                          data['comment'])))
        else:
            if data['id'] == '}':
                indent = indent - 1

            # only indent++ after open {
            indentstr = indfmt['string'] * indent
            if data['id'] == '{':
                indent = indent + 1

            cmd = compose_sed_command(data)
            addr = compose_sed_address(data)

            # saving full line
            cmd = '%s%s%s' % (indentstr, addr, cmd)
            if data['comment']:
                # Inline comments are aligned at column 40
                # The leading ; before # is required by non-GNU seds
                outlist.append('%-39s;%s' % (cmd, data['comment']))
            else:
                outlist.append(cmd)

    if action == 'html':
        outlist.append(html_data['footer'])

    print('\n'.join(outlist))                          # print the result


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
    cmdlineopts = 'f'
    t_count = 0
    hideregisters = 0

    if 'topopts' in datalist[0]:
        cmdlineopts = datalist[0]['topopts']

    # If we have one or more t commands on the script, we need to save
    # the t command status between debug commands. As they perform
    # s/// commands, the t status of the "last substitution" is lost.
    # So, we save the status doing a nice loop trick before *every*
    # command (necessary overhead). This loops uses the :zzsetNNN and
    # zzclrNNN labels, where NNN is the label count.
    # TIP: t status resets: line read, t call
    if datalist[0]['has_t']:
        t_count = 1

    for i in range(len(datalist)):
        if i == 0:
            continue                                # skip headers at 0
        data = datalist[i]
        if not data['id']:
            continue                                # ignore blank line
        if data['id'] == '#':
            outlist.append('%s\n' % (data['comment']))
        else:
            cmd = compose_sed_command(data)
            addr = compose_sed_address(data)

            cmdshow = cmd.replace('\n', newlineshow + color_YLW)
            cmdshow = escape_text_commands_specials(addr + cmdshow)
            showsedcmd = showcomm.replace('\a', cmdshow)

            registers = showpatt + showhold
            if hideregisters:
                registers = ''

            showall = '%s%s' % (registers, showsedcmd)

            # Add the 't status' trick to commands.
            # Exception: read-next-line commands (n,d,q)
            # Exception: no PATT/HOLD registers to show (no s///)
            if t_count and showall:
                if data['id'] not in 'ndq' and registers:
                    tmp = save_t.replace('\a', '%03d' % t_count)
                    showall = tmp.replace('#DEBUG#', showall)
                    t_count = t_count + 1

            # null cmd to restore last addr: /addr/y/!/!/
            if data['lastaddr']:
                showall = showall + debug_prefix + \
                    data['lastaddr'] + nullcomm + '\n'

            # after jump or block commands don't show
            # registers, because they're not affected.
            # exception: after b or t without target
            # (read next line)
            hideregisters = 0
            if data['id'] in sedcmds['jump'] and data['content']:
                hideregisters = 1
            elif data['id'] in sedcmds['block']:
                hideregisters = 1

            outlist.append("%s#%s\n%s\n" % (showall, '-'*50, addr + cmd))

    outlist.append(showpatt + showhold)           # last line status

    # executing sed script
    cmdextra = ''
    if action_modifiers.count('_stdout-only'):
        # cmdextra = "| egrep -v '^PATT|^HOLD|^COMM|\$$|\\$'"  # sed
        cmdextra = "-l 9999 | egrep -v '^PATT|^HOLD|^COMM'"   # gsed
    inputfiles = ' '.join(textfiles)
    if dump_debug:
        for line in [re.sub('\n$', '', x) for x in outlist]:
            print(line)
        print("\n# Debugged SED script generated by %s-%s (%s)" % (
            myname, __version__, myhome))
    else:
        tmpfile = tempfile.mktemp()
        write_file(tmpfile, outlist)
        os.system("%s -%s %s %s %s" % (
            sedbin, cmdlineopts, tmpfile, inputfiles, cmdextra))
        os.remove(tmpfile)


###############################################################################
#                                                                             #
#                               SED Script Parser                             #
#                           -------------------------                         #
#                      Extract Every Info of Every Command                    #
#                                                                             #
###############################################################################
#
# Global view of the parser:
#
# - Load the original sed script to a list, then let the file free
# - Scan the list (line by line)
# - As user can do more than one sed command on the same line, we split
#   "possible valid commands" by ; (brute force method)
# - Validate each split command
# - If not valid, join next, and try to validate again (loop here)
# - If hit EOL and still not valid, join next line, validate (loop here)
# - Hit EOF, we've got all info at hand
# - Generate a result list with all sed command found and its data, each
#   command having its own dictionary: {addr1: '', addr2: '', cmd: ''}
# - ZZ is the list
###


incompletecmd = ''
incompleteaddr = ''
incompletecmdline = ''
addr1 = addr2 = ''
lastaddr = ''
lastsubref = ''
has_t = 0
cmdsep = ';'
linesep = '@#linesep#@'
newlineshow = '%s\\N%s' % (color_RED, color_NO)
blanklines = []
ZZ = []
ZZ.append({})  # for header

linenr = 0
cmddict = {}
for line in sedscript:
    linenr = linenr + 1

    # 1st line, try to find #!/...
    if linenr == 1:
        m = re.match(patt['topopts'], line)
        if m:                                 # we have options!
            ZZ[0]['topopts'] = m.group(1)     # saved on list header
            del m

    if incompletecmdline:
        line = linesep.join([incompletecmdline, line])

    # s/\n$//
    if line and line[-1] == '\n':
        line = line[:-1]

    # blank line
    if not line.strip():
        blanklines.append(linenr)
        ZZ.append({'linenr': linenr, 'id': ''})
        continue

    if DEBUG:
        print('')
        devdebug('line:%d: %s' % (linenr, line))

    # bruteforce: split lines in ; char
    # exceptions: comments and a,c,i text
    if line.lstrip()[0] == '#':
        linesplit = [line.lstrip()]                 # comments
    elif line.lstrip()[0] in sedcmds['text']:
        linesplit = [line]                          # a, c, i
    else:
        linesplit = line.split(cmdsep)              # split lines at ;

    while linesplit:
        possiblecmd = linesplit.pop(0)
        if not incompletecmdline:
            if incompletecmd:
                possiblecmd = cmdsep.join([incompletecmd, possiblecmd])
            if incompleteaddr:
                possiblecmd = cmdsep.join([incompleteaddr, possiblecmd])
        else:
            incompletecmdline = ''

        # ; at EOL or useless seq of ;;;;
        if not possiblecmd:
            continue

        devdebug('possiblecmd: ' + possiblecmd, 2)
        possiblecmd = possiblecmd.lstrip()       # del space at begin
        cmdid = possiblecmd[0]                   # get 1st char(sed cmd)

        if cmdid == '\\' and len(possiblecmd) == 1:  # to get \;addr;
            incompleteaddr = cmdid
            continue

        # ------------- Get addresses routine ---------------
        #
        # To handle ranges, match addresses one by one:
        # - Matched addr at ^   ? Get it and set addr1.
        # - Next char is a comma? It's a range. Get & set addr2.
        # - Addresses are cut from command, continue.
        #
        # We're not using split cause it fails at /bla[,]bla/ address
        #
        while True:
            if not possiblecmd[0] in sedcmds['addr']:  # No address
                break

            addr = SedAddress(possiblecmd, 'address')  # get data

            if addr.isok:
                if 'addr1' not in cmddict:
                    cmddict['linenr'] = linenr
                    cmddict['addr1'] = addr.full
                    cmddict['addr1flag'] = addr.flag
                    cmddict['addr1html'] = addr.html
                    if addr.pattern:
                        lastaddr = addr.full
                    else:
                        cmddict['lastaddr'] = lastaddr
                else:
                    cmddict['addr2'] = addr.full
                    cmddict['addr2flag'] = addr.flag
                    cmddict['addr2html'] = addr.html
                    if addr.pattern:
                        lastaddr = addr.full
                    else:
                        cmddict['lastaddr'] = lastaddr
                rest = addr.rest
            else:
                incompleteaddr = addr.rest
                break  # join more cmds

            # it's a range
            if 'addr2' not in cmddict and rest.lstrip()[0] == ',':
                # del comma and blanks
                possiblecmd = re.sub(r'^\s*,\s*', '', rest)
                continue  # process again
            else:
                incompleteaddr = ''
                possiblecmd = rest.lstrip()
                break  # we're done

        if incompleteaddr:
            continue  # need more commands

        # fill unset address fields
        for key in cmdfields[:6]:
            if key not in cmddict:
                cmddict[key] = ''

        # -------------------------------------------------
        # from here, address is no more
        # -------------------------------------------------

        if not incompletecmd:
            if not possiblecmd:
                fatal_error('missing command at line %d!' % linenr)
            cmd = SedCommand(possiblecmd)
            if not cmddict['linenr']:
                cmddict['linenr'] = linenr
        else:
            cutme = len(cmd.modifier + cmd.id)
            cmd.rest = possiblecmd
            cmd.junk = possiblecmd[cutme:]
            cmd.do_it_all()

        if cmd.isok:
            # fill command entry data
            for key in cmdfields[6:]:
                cmddict[key] = getattr(cmd, key)

            # saving last address content
            if cmd.pattern:
                lastaddr = cmd.delimiter + cmd.pattern + cmd.delimiter
            elif cmd.delimiter:
                cmddict['lastaddr'] = lastaddr

            if cmd.id == 's':
                lastsubref = len(ZZ)  # save s/// position

            if cmd.id == 't':
                # related s/// reference
                cmddict['extrainfo'] = lastsubref
                has_t = 1

            # save full command entry
            ZZ.append(cmddict)
            devdebug('FULL entry: %s' % cmddict, 3)

            # reset data and incomplete holders
            cmddict = {}
            incompletecmd = incompletecmdline = ''

            if cmd.id == '{':
                linesplit.insert(0, cmd.rest)
            if cmd.rest == '}':
                linesplit.insert(0, cmd.rest)
                # ^---  3{p;d} (gnu)
            del cmd
        else:
            # not ok, will join next
            incompletecmd = cmd.rest
            devdebug('INCOMPLETE cmd: %s' % incompletecmd)

    if incompletecmd:
        incompletecmdline = incompletecmd

# populating list header
ZZ[0]['blanklines'] = blanklines
ZZ[0]['fields'] = cmdfields
ZZ[0]['has_t'] = has_t

# Now the ZZ list is full.
# It has every info that sedsed can extract from a SED script.
# From now on, all functions and classes will manage this list.
# If you are curious about it, just uncomment the line below and
# prepare yourself for an ASCII nightmare ;)
#
# print color_YLW + repr(ZZ) + color_NO ; sys.exit(0)


###############################################################################
#                                                                             #
#                               The SED Emulator!                             #
#                           -------------------------                         #
#                       Not 100% done, but already usable                     #
#                                                                             #
###############################################################################
#
# The emulator still doesn't support complex regexes and '$' as line address.
# Use the --emu command line option to run the emulator.
# If you don't have SED on your system, you can use --emu to have a SED-like
# program!
#
# Example:
#    $ echo 'foo bar' | sedsed --emu 's/.*/SED/'
#    SED
#

class SedEmulator(object):
    # TODO check for syntax errors
    # TODO convert regexes
    # TODO organize debug msgs
    # TODO make all this script a valid/callable python module
    def __init__(self, datalist, textfile, debug=0):
        self.inlist = ['']
        self.outlist = []
        self.cmdlist = []
        self.labels = {}
        self.blocks = {}
        self.addr1 = self.addr2 = ''
        self.linenr = 0
        self.cmdnr = 0
        self.holdspace = ''
        self.line = ''
        self.cmd = ''

        self.f_debug = debug
        self.f_stdin = 0
        self.rewind_script()

        # maketrans() is required to emulate the 'y' command
        try:
            self.maketrans = str.maketrans  # py3
        except:
            from string import maketrans    # py2
            self.maketrans = maketrans

        # getting input data location (stdin or file)
        if textfile in (stdin_id, '-'):
            self.f_stdin = 1
        else:
            self.inlist.extend(read_file(textfile))

        # wipe null commands, save labels and block info
        blockopen = []
        for data in datalist[1:]:  # skip headers at 0
            if not data['id'] or data['id'] == '#':
                continue
            self.cmdlist.append(data)
            cmdpos = len(self.cmdlist) - 1
            if data['id'] == ':':
                self.labels[data['content']] = cmdpos
            elif data['id'] == '{':
                blockopen.append(cmdpos)
            elif data['id'] == '}':
                self.blocks[blockopen.pop()] = cmdpos
        del blockopen

        self.run()

    def rewind_script(self):
        self.EOS = 0     # end of script
        self.EOF = 0     # end of file
        self.cmdnr = -1
        self.f_delme = 0
        self.f_inrange = 0
        self.f_joinme = 0

    def read_next_line(self):
        self.linenr = self.linenr + 1
        # TODO $ matches every line.
        # TODO GNUsed retains stdout until next only if there is a $ addr

        # read STDIN interactively
        if self.f_stdin:
            inputline = sys.stdin.readline()
            if not inputline:
                self.EOF = 1
                return
            self.inlist.append(inputline[:-1])  # del \n$

        # no more lines?
        if self.linenr > len(self.inlist) - 1:
            self.EOF = 1
            return

        next_line = self.inlist[self.linenr]
        if self.f_joinme:
            self.line = self.line + '\n' + next_line
        else:
            self.line = next_line
        devdebug('line read:%d:%s' % (self.linenr, repr(self.line)), 1)

    def _get_address(self, fulladdr):
        addr = fulladdr  # number
        if addr[0] == '/':
            addr = addr[1:-1]  # del //
        elif addr[0] == '\\':
            addr = addr[2:-1]  # del \xx
        return addr

    def _match_address(self, addr):
        ok = 0
        if addr[0] in '0123456789':              # 003 is valid
            if self.linenr == int(addr):
                ok = 1
        elif addr == '$':                        # last line
            if self.linenr == len(self.inlist) - 1:
                ok = 1
        elif re.search(addr, self.line):         # pattern
            ok = 1
        if ok:
            devdebug('MATCHed addr:%s' % repr(addr), 2)
        return ok

    def test_address(self):
        ok = 0
        cmd = self.cmd

        if not cmd['addr1']:
            ok = 1              # no address
            devdebug('NO address!', 3)
        else:
            self.addr1 = self._get_address(cmd['addr1'])
            devdebug('addr1: ' + self.addr1, 2)

        if cmd['addr2']:                         # range
            self.addr2 = self._get_address(cmd['addr2'])
            devdebug('addr2: ' + self.addr2, 2)
            if self.f_inrange:
                self.f_inrange = 0

        if not ok:
            if self._match_address(self.addr1):
                ok = 1

            if self.addr2:                       # range
                if ok:
                    self.f_inrange = 1           # start range
                elif self._match_address(self.addr2):
                    ok = 1
                    self.f_inrange = 0           # end range
                elif self.f_inrange:
                    ok = 1                       # in range
                devdebug('in range: %d' % self.f_inrange, 3)

        devdebug('is hotline: %d' % ok, 3)
        devdebug('cmd: %s' % cmd['id'], 1)
        return ok

    def _make_raw_string(self, text):
        raw = text.replace('\t', '\\t')
        raw = raw.replace('\n', '\\n')
        return raw + '$'

    def apply_cmd(self):
        cmd = self.cmd
        PS = self.line
        HS = self.holdspace
        devdebug('cmdnr: %d' % self.cmdnr, 3)

        # TODO ! r w //
        if cmd['id'] == ':':
            pass

        elif cmd['id'] == '=':
            print(self.linenr)

        elif cmd['id'] == 'p':
            print(PS)

        elif cmd['id'] == 'P':
            print(re.sub('\n.*', '', PS))

        elif cmd['id'] == 'q':
            self.EOF = 1

        elif cmd['id'] == 'h':
            HS = PS

        elif cmd['id'] == 'H':
            HS = HS + '\n' + PS

        elif cmd['id'] == 'g':
            PS = HS

        elif cmd['id'] == 'G':
            PS = PS + '\n' + HS

        elif cmd['id'] == 'x':
            PS, HS = HS, PS

        elif cmd['id'] == 'y':
            trtab = self.maketrans(cmd['pattern'], cmd['replace'])
            PS = PS.translate(trtab)

        elif cmd['id'] == 'l':
            print(self._make_raw_string(PS))

        elif cmd['id'] == 'd':
            self.f_delme = 1
            self.EOS = 1  # d) forces next cycle

        elif cmd['id'] == 'D':                 # D) del till \n, next cycle
            cutted = re.sub('^.*?\n', '', PS)  # del till the 1st \n
            if cutted == PS:
                cutted = ''                    # if no \n, del all
            PS = cutted
            self.rewind_script()                # D forces rewind
            if not PS:                         # no PS, start next cycle
                self.f_delme = 1
                self.EOS = 1

        elif cmd['id'] == 'n':             # n) print patt, read line
            print(PS)
            self.read_next_line()
            PS = self.line

        elif cmd['id'] == 'N':             # N) join next, read line
            self.f_joinme = 1
            self.read_next_line()
            PS = self.line

        elif cmd['id'] in 'aic':           # aic) spill text
            txt = re.sub(r'\\%s' % linesep, '\n', cmd['content'])
            txt = re.sub('^\n', '', txt)     # delete first escape
            self.f_delme = 1
            if cmd['id'] == 'a':
                print(PS)                    # line before
            print(txt)                       # put text
            if cmd['id'] == 'i':
                print(PS)                    # line after

        elif cmd['id'] in 'bt':            # jump to...
            if not cmd['content']:
                self.EOS = 1                              # ...end
            else:
                self.cmdnr = self.labels[cmd['content']]  # ...label

        # TODO s///3 ; s//\1/ ; s//&/
        elif cmd['id'] == 's':
            times = 1
            patt = cmd['pattern']
            repl = cmd['replace']

            # TODO v----- test only, make function
            patt = re.sub(r'\\\(', '(', patt)
            patt = re.sub(r'\\\)', ')', patt)
            repl = re.sub(r'^\\\n', '\n', repl)  # NL escaped on repl

            if 'g' in cmd['flag']:  # global
                times = 0

            if 'i' in cmd['flag']:  # ignore case
                patt = '(?i)' + patt

            new = re.sub(patt, repl, PS, times)

            if 'p' in cmd['flag'] and new != PS:
                print(new)

            if 'w' in cmd['flag']:
                text = [new]  # w) open file truncating anyway

                # write patt only if s/// was ok
                if new == PS:
                    text = ''
                write_file(cmd['content'], text)

            PS = new

        if self.f_debug:
            showreg = 1
            fullcmd = "%s%s" % (
                compose_sed_address(cmd),
                compose_sed_command(cmd).replace('\n', newlineshow + color_YLW))
            print('COMM:' + color_YLW + fullcmd + color_NO)
            if cmd['id'] in ':bt' and cmd['content']:
                showreg = 0
            if cmd['id'] in '{}':
                showreg = 0
            if showreg:
                print('PATT:' + self._make_raw_string(PS))
                print('HOLD:' + self._make_raw_string(HS))

        self.line = PS
        self.holdspace = HS  # save registers

    def run(self):
        while not self.EOF:
            self.rewind_script()
            self.read_next_line()
            if self.EOF:
                break

            if self.linenr == 1 and self.f_debug:   # debug info
                print('PATT:' + self._make_raw_string(self.line))
                print('HOLD:' + self._make_raw_string(self.holdspace))

            while not self.EOS:
                if self.cmdnr == -1:  # 1st position
                    self.cmdnr = 0
                self.cmd = self.cmdlist[self.cmdnr]
                if self.test_address():
                    self.apply_cmd()
                    if self.EOS or self.EOF:
                        break
                elif self.cmd['id'] == '{':
                    self.cmdnr = self.blocks[self.cmdnr]

                self.cmdnr = self.cmdnr + 1  # next command
                if self.cmdnr > len(self.cmdlist) - 1:
                    break

            # default print pattern behavior
            if not self.f_delme:
                print(self.line)


# -----------------------------------------------------------------------------
#          Script Already Parsed, Now It's Time To Make Decisions
# -----------------------------------------------------------------------------
#
# This is the crucial point where the program will perform the action
# that you choose on the command line.
#
# The ZZ list is full of data, and all the following functions know
# how to handle it. Maybe we will indent, maybe debug? We'll see.
#

if action == 'indent':
    dump_script(ZZ, indent_prefix)

elif action == 'html':
    dump_script(ZZ, indent_prefix)

elif action == 'debug':
    do_debug(ZZ)

elif action == 'token':
    dump_key_value_pair(ZZ)

elif action == 'dumpcute':
    dump_cute(ZZ)

elif action in ['emu', 'emudebug']:
    DEBUG = EMUDEBUG
    if action == 'emudebug':
        dodebug = 1
    else:
        dodebug = 0
    for input_file in textfiles:
        SedEmulator(ZZ, input_file, dodebug)


# -----------------------------------------------------------------------------
#                               - THE END -
# -----------------------------------------------------------------------------
