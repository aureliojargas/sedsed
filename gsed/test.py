# Unit tests for the ported GNU sed parser.
# Only the fatal errors are checked.
# Not all possible error messages are tested, those that were left out
# are not available in the port.

import unittest
import sys

# Capture stdout and stderr for the asserts
# https://stackoverflow.com/a/17981937
from contextlib import contextmanager
from io import StringIO
@contextmanager
def captured_output():
    new_out, new_err = StringIO(), StringIO()
    old_out, old_err = sys.stdout, sys.stderr
    try:
        sys.stdout, sys.stderr = new_out, new_err
        yield sys.stdout, sys.stderr
    finally:
        sys.stdout, sys.stderr = old_out, old_err

DATA = [
    #                    ANCIENT_VERSION  expected newer version of sed
    ("!!p",       1, 2, "BAD_BANG", "multiple `!'s"),
    ("1,p",       1, 3, "BAD_COMMA", "unexpected `,'"),
    ("s★a★b★",    1, 2, "BAD_DELIM", "delimiter character is not a single-byte character"),
    ("+1p",       1, 2, "BAD_STEP", "invalid usage of +N or ~N as first address"),
    ("~1p",       1, 2, "BAD_STEP", "invalid usage of +N or ~N as first address"),
    (":",         1, 1, "COLON_LACKS_LABEL", "\":\" lacks a label"),
    #                    DISALLOWED_CMD  e/r/w commands disabled in sandbox mode
    ("}",         1, 1, "EXCESS_CLOSE_BRACE", "unexpected `}'"),
    ("s/a/b/gg",  1, 8, "EXCESS_G_OPT", "multiple `g' options to `s' command"),
    ("dp",        1, 2, "EXCESS_JUNK", "extra characters after command"),
    ("xx",        1, 2, "EXCESS_JUNK", "extra characters after command"),
    ("s/a/b/2p2", 1, 9, "EXCESS_N_OPT", "multiple number options to `s' command"),
    ("{",         1, 1, "EXCESS_OPEN_BRACE", "unmatched `{'"),  # GNU sed is "char 0"
    ("s/a/b/pp",  1, 8, "EXCESS_P_OPT", "multiple `p' options to `s' command"),
    ("a",         1, 1, "EXPECTED_SLASH", "expected \\ after `a', `c' or `i'"),
    #                    INCOMPLETE_CMD  incomplete command
    ("0p",        1, 2, "INVALID_LINE_0", "invalid usage of line address 0"),
    ("s/a/b/w",   1, 7, "MISSING_FILENAME", "missing filename in r/R/w/W commands"),
    ("r",         1, 1, "MISSING_FILENAME", "missing filename in r/R/w/W commands"),
    ("{p;$}",     1, 5, "NO_CLOSE_BRACE_ADDR", "`}' doesn't want any addresses"),
    #                    NO_COLON_ADDR  : doesn't want any addresses
    ("/a/",       1, 3, "NO_COMMAND", "missing command"),
    #                    NO_SHARP_ADDR  comments don't accept any addresses
    #                    ONE_ADDR  command only uses one address
    #                    RECURSIVE_ESCAPE_C  recursive escaping after \\c not allowed
    ("u",         1, 1, "UNKNOWN_CMD", "unknown command: `u'"),
    ("s/a/b/z",   1, 7, "UNKNOWN_S_OPT", "unknown option to `s'"),
    ("s/a/b/\r",  1, 7, "UNKNOWN_S_OPT", "unknown option to `s'"),
    ("/a",        1, 2, "UNTERM_ADDR_RE", "unterminated address regex"),
    ("s/a/b",     1, 5, "UNTERM_S_CMD", "unterminated `s' command"),
    ("y/a/",      1, 4, "UNTERM_Y_CMD", "unterminated `y' command"),
    #                    Y_CMD_LEN  strings for `y' command are different lengths
    ("s/a/b/0",   1, 7, "ZERO_N_OPT", "number option to `s' command may not be zero"),
]

class TestSed(unittest.TestCase):

    def my_setUp(self):
        # start from scratch to avoid module state leak between tests
        import gnused
        self.x = gnused  # pylint: disable=attribute-defined-outside-init
        self.x.the_program = []

    def my_tearDown(self):
        # Make sure it's really gone - https://stackoverflow.com/a/11199969
        del self.x
        sys.modules.pop('gnused', None)

    def test_1(self):
        for command, exp_nr, char_nr, _, message in DATA:
            expected = "sed: -e expression #%d, char %d: %s" % (exp_nr, char_nr, message)
            self.my_setUp()
            with captured_output() as (_, err):
                try:
                    self.x.compile_string(self.x.the_program, command)
                    self.x.check_final_program()
                except SystemExit:
                    pass
                self.assertEqual(err.getvalue().rstrip(), expected)
            self.my_tearDown()

if __name__ == '__main__':
    unittest.main()
