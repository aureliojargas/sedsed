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

    def mock_sys_exit(self, msg):
        pass

    def setUp(self):
        self.sys_exit = sys.exit
        sys.exit = self.mock_sys_exit

        # start from scratch to avoid midule data leak
        import compile
        self.x = compile
        self.x.the_program = []

    def tearDown(self):
        sys.exit = self.sys_exit

        # Make sure it's really gone - https://stackoverflow.com/a/11199969
        del self.x
        sys.modules.pop('compile', None)

    def test_1(self):
        with captured_output() as (out, err):
            exp = "sed: -e expression #1, char 9: unknown command: `u'"
            self.x.compile_string(self.x.the_program, "p;p  \n  u")
            self.assertEqual(err.getvalue().rstrip(), exp)

    def test_2(self):
        with captured_output() as (out, err):
            exp = "sed: -e expression #1, char 2: extra characters after command"
            self.x.compile_string(self.x.the_program, "dp")
            self.assertEqual(err.getvalue().rstrip(), exp)

    def test_3(self):
        with captured_output() as (out, err):
            exp = "sed: -e expression #1, char 8: unknown command: `u'"
            self.x.compile_string(self.x.the_program, "d;;;p;\nu")
            self.assertEqual(err.getvalue().rstrip(), exp)

    def test_4(self):
        with captured_output() as (out, err):
            exp = "sed: -e expression #2, char 2: extra characters after command"
            self.x.compile_string(self.x.the_program, "p")
            self.x.compile_string(self.x.the_program, "xx")
            self.assertEqual(err.getvalue().rstrip(), exp)

if __name__ == '__main__':
    unittest.main()
