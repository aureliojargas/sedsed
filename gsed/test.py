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

    def setUp(self):
        # start from scratch to avoid module state leak between tests
        import compile
        self.x = compile
        self.x.the_program = []

    def tearDown(self):
        # Make sure it's really gone - https://stackoverflow.com/a/11199969
        del self.x
        sys.modules.pop('compile', None)

    def test_1(self):
        with captured_output() as (out, err):
            exp = "sed: -e expression #1, char 9: unknown command: `u'"
            try:
                self.x.compile_string(self.x.the_program, "p;p  \n  u")
            except SystemExit:
                pass
            self.assertEqual(err.getvalue().rstrip(), exp)

    def test_2(self):
        with captured_output() as (out, err):
            exp = "sed: -e expression #1, char 2: extra characters after command"
            try:
                self.x.compile_string(self.x.the_program, "dp")
            except SystemExit:
                pass
            self.assertEqual(err.getvalue().rstrip(), exp)

    def test_3(self):
        with captured_output() as (out, err):
            exp = "sed: -e expression #1, char 8: unknown command: `u'"
            try:
                self.x.compile_string(self.x.the_program, "d;;;p;\nu")
            except SystemExit:
                pass
            self.assertEqual(err.getvalue().rstrip(), exp)

    def test_4(self):
        with captured_output() as (out, err):
            exp = "sed: -e expression #2, char 2: extra characters after command"
            try:
                self.x.compile_string(self.x.the_program, "p")
                self.x.compile_string(self.x.the_program, "xx")
            except SystemExit:
                pass
            self.assertEqual(err.getvalue().rstrip(), exp)

    def test_5(self):
        with captured_output() as (out, err):
            exp = "sed: -e expression #1, char 3: missing command"
            try:
                self.x.compile_string(self.x.the_program, "/a/")
            except SystemExit:
                pass
            self.assertEqual(err.getvalue().rstrip(), exp)

    def test_6(self):
        with captured_output() as (out, err):
            exp = "sed: -e expression #1, char 2: unterminated address regex"
            try:
                self.x.compile_string(self.x.the_program, "/a")
            except SystemExit:
                pass
            self.assertEqual(err.getvalue().rstrip(), exp)

    def test_7(self):
        with captured_output() as (out, err):
            exp = "sed: -e expression #1, char 4: unterminated `y' command"
            try:
                self.x.compile_string(self.x.the_program, "y/a/")
            except SystemExit:
                pass
            self.assertEqual(err.getvalue().rstrip(), exp)

    def test_8(self):
        with captured_output() as (out, err):
            exp = "sed: -e expression #1, char 5: unterminated `s' command"
            try:
                self.x.compile_string(self.x.the_program, "s/a/b")
            except SystemExit:
                pass
            self.assertEqual(err.getvalue().rstrip(), exp)

if __name__ == '__main__':
    unittest.main()
