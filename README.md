# sedsed

Debugger and code formatter for sed scripts, by Aurelio Jargas.

Website: https://aurelio.net/projects/sedsed/

## Download

Sedsed is a single file Python application. Just download [sedsed.py](https://raw.githubusercontent.com/aureliojargas/sedsed/master/sedsed.py) and run it.

- Compatible with Python 2.7 and Python 3.x
- License: MIT
- [Official released versions](https://github.com/aureliojargas/sedsed/releases)
- [CHANGELOG.md](https://github.com/aureliojargas/sedsed/blob/master/CHANGELOG.md) for the list of changes in each version

## Code formatting for sed scripts

Sedsed can turn cryptic oneliners into readable indented code:

```console
$ sedsed --indent ':a;s/<[^>]*>//g;/</{N;ba;}'
:a
s/<[^>]*>//g
/</ {
    N
    b a
}
```

Convert your script to HTML to get code formatting, beautiful syntax highlighting and clickable links for GOTO commands (`b` and `t`).

```console
$ sedsed --htmlize -f myscript.sed > myscript.html
```

See many examples of HTML-converted scripts in http://sed.sourceforge.net/local/scripts/

## Debugging sed scripts

Sedsed allows you to debug your sed scripts. It inserts extra sed commands into the script and uses the system's sed to execute the modified script.

The added commands won't affect the script's original logic, but will show debug information while sed is running the script: the current command is printed, as well as the contents of both `PATTERN SPACE` and `HOLD SPACE` buffers, before and after every command.

With that information at hand, you can see how sed operates under the curtains.

For example, compare the normal sed run and the sedsed debug run for a script to reverse the line order (similar to Unix `tac`):

```
$ echo -e 'A\nB\nC' | sed '1!G;h;$!d'
C
B
A
```

```
$ echo -e 'A\nB\nC' | sedsed --debug '1!G;h;$!d'
PATT:A$
HOLD:$
COMM:1 !G
PATT:A$
HOLD:$
COMM:h
PATT:A$
HOLD:A$
COMM:$ !d
PATT:B$
HOLD:A$
COMM:1 !G
PATT:B\nA$
HOLD:A$
COMM:h
PATT:B\nA$
HOLD:B\nA$
COMM:$ !d
PATT:C$
HOLD:B\nA$
COMM:1 !G
PATT:C\nB\nA$
HOLD:B\nA$
COMM:h
PATT:C\nB\nA$
HOLD:C\nB\nA$
COMM:$ !d
PATT:C\nB\nA$
HOLD:C\nB\nA$
C
B
A
```

The input is three lines A, B and C, and the output is those three lines reversed: C, B, A. You can see how the sed buffers (`PATT` and `HOLD`) changed after every command (`COMM`).

Another example, a script to remove all HTML tags. It even removes tags that span in multiple lines.

```
$ cat menu.html
<a
   class="menu"
   href="index.html">Home</a>
```

```
$ cat menu.html | sed -e ':a;s/<[^>]*>//g;/</{N;ba;}'
Home
```

```
$ cat menu.html | sedsed --debug --hide=hold -e ':a;s/<[^>]*>//g;/</{N;ba;}'
PATT:<a$
COMM::a
COMM:s/<[^>]*>//g
PATT:<a$
COMM:/</ {
COMM:N
PATT:<a\n   class="menu"$
COMM:b a
COMM:s/<[^>]*>//g
PATT:<a\n   class="menu"$
COMM:/</ {
COMM:N
PATT:<a\n   class="menu"\n   href="index.html">Home</a>$
COMM:b a
COMM:s/<[^>]*>//g
PATT:Home$
COMM:/</ {
PATT:Home$
Home
```

You can see in the `PATT` lines how the multiline `<a>` tag is accumulated before the `s` command can remove the whole tag at once, leaving only its contents: `Home`.

Note that the `--hide=hold` option was used to avoid showing the contents of the `HOLD SPACE` buffer. It would be empty all the way, since this script does not use that extra buffer. You can also hide the `PATT` and `COMM` lines, if necessary.

For tricky scripts, sometimes it helps to only see the contents of the `PATTERN SPACE` buffer changing, so you can get a sense of how it is manipulated during execution. Using `--hide=hold,comm` you can achieve that. The next example uses that to show how ABC turned into CBA in this nice script to reverse strings (similar to Unix `rev`):

```
$ echo ABC | sedsed --debug --hide=hold,comm \
    -e '/\n/!G;s/\(.\)\(.*\n\)/&\2\1/;//D;s/.//' | uniq
PATT:ABC$
PATT:ABC\n$
PATT:ABC\nBC\nA$
PATT:BC\nA$
PATT:BC\nC\nBA$
PATT:C\nBA$
PATT:C\n\nCBA$
PATT:\nCBA$
PATT:CBA$
CBA
```

In those examples the sed script was informed as an argument using the `-e` option. Sedsed also supports the `-f` option to inform a sed script file, and the traditional `-n` option (that is just forwarded to sed).

## QA

**Code linter:** sedsed code is checked by pylint. Configuration is in [.pylintrc](.pylintrc).

**Tests:** sedsed has a homemade custom testing solution, comprised of multiple shell scripts and test files. You can read more about it at [test/README.md](test/README.md). To run all the tests, just do:

    $ ./test/run

**Automation:** For every new pushed commit, Travis CI runs the code linter and all the tests. The tests are checked in multiple Python versions, from 2.7 to 3.7. See [.travis.yml](.travis.yml).

## New version release checklist

Preparing:

- Make sure the tests are 100% ok.
- Check the list of commits since the last version.
- Check the full diff against the last version.
- Update and commit the Changelog.

Releasing:

- Commit the increased version number in `__version__`.
- Tag this commit with the new version.
- Commit the change to the version number back to the dev state.
- Push everything (commits and tags) to GitHub.
- Update the website, download section.
