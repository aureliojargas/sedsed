# Unit tests for sedsed

import unittest
import sys
import os

# Make ../sedsed.py importable
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
import sedsed  # pylint: disable=wrong-import-position

# Mock to avoid the print() call from the original
sedsed.fatal_error = sys.exit


class TestSedsed(unittest.TestCase):  # pylint: disable=unused-variable
    def test_read_file_not_found(self):
        with self.assertRaises(SystemExit):
            sedsed.read_file("404.txt")

    def test_read_file_ok(self):
        output = sedsed.read_file(__file__)
        self.assertEqual(output[0], "# Unit tests for sedsed")

    def test_write_file_use_dir(self):
        with self.assertRaises(SystemExit):
            some_dir = os.path.dirname(__file__)
            sedsed.write_file(some_dir, ["line1"])

    def test_write_file_ok(self):
        temp_file = __file__ + ".tmp"
        sedsed.write_file(temp_file, ["line1"])
        self.assertTrue(os.path.isfile(temp_file))
        os.remove(temp_file)

    def test_lastaddr_should_be_empty(self):
        """
        The "y" command should not save or set lastaddr.
        """
        data = [("y/a/x/", "s///"), ("s/a/x/", "y///")]
        for script in data:
            result = sedsed.parse(script)
            self.assertEqual(result[-1]["lastaddr"], "", msg=script)

    def test_lastaddr_should_be_set(self):
        """
        Any /.../ or s/...// should trigger the saving of lastaddr.
        Any empty address // or s//foo should have its lastaddr set.
        """
        data = [
            ("s/foo1/x/", "s///"),
            ("/foo2/x", "s///"),
            ("s/foo3/x/", "//p"),
            ("/foo4/x", "//p"),
        ]
        for index, script in enumerate(data, start=1):
            result = sedsed.parse(script)
            self.assertEqual(result[-1]["lastaddr"], "/foo%s/" % index, msg=script)


if __name__ == "__main__":
    unittest.main()
