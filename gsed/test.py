# Unit tests for sedsed

import unittest
import sys
import os

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


class TestSed(unittest.TestCase):

    def my_setUp(self):
        # start from scratch to avoid module state leak between tests
        import compile
        self.x = compile
        self.x.the_program = []

    def my_tearDown(self):
        # Make sure it's really gone - https://stackoverflow.com/a/11199969
        del self.x
        sys.modules.pop('compile', None)

    def test_1(self):
        data = [
            ("u",         "sed: -e expression #1, char 1: unknown command: `u'"),
            ("dp",        "sed: -e expression #1, char 2: extra characters after command"),
            ("xx",        "sed: -e expression #1, char 2: extra characters after command"),
            ("/a/",       "sed: -e expression #1, char 3: missing command"),
            ("/a",        "sed: -e expression #1, char 2: unterminated address regex"),
            ("y/a/",      "sed: -e expression #1, char 4: unterminated `y' command"),
            ("s/a/b",     "sed: -e expression #1, char 5: unterminated `s' command"),
            ("s/a/b/z",   "sed: -e expression #1, char 7: unknown option to `s'"),
            ("s/a/b/\r",  "sed: -e expression #1, char 7: unknown option to `s'"),
            ("s/a/b/pp",  "sed: -e expression #1, char 8: multiple `p' options to `s' command"),
            ("s/a/b/gg",  "sed: -e expression #1, char 8: multiple `g' options to `s' command"),
            ("s/a/b/2p2", "sed: -e expression #1, char 9: multiple number options to `s' command"),
            ("s/a/b/0",   "sed: -e expression #1, char 7: number option to `s' command may not be zero"),
            ("s/a/b/w",   "sed: -e expression #1, char 7: missing filename in r/R/w/W commands"),
            ("{",         "sed: -e expression #1, char 1: unmatched `{'"),  # GNU sed is "char 0"
            ("}",         "sed: -e expression #1, char 1: unexpected `}'"),
            ("{p;$}",     "sed: -e expression #1, char 5: `}' doesn't want any addresses"),
        ]
        for command, expected in data:
            self.my_setUp()
            with captured_output() as (out, err):
                try:
                    self.x.compile_string(self.x.the_program, command)
                    self.x.check_final_program()
                except SystemExit:
                    pass
                self.assertEqual(err.getvalue().rstrip(), expected)
            self.my_tearDown()

if __name__ == '__main__':
    unittest.main()
