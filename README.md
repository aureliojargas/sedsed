# sedsed

Debugger and code formatter for sed scripts, by Aurelio Jargas.

Website: https://aurelio.net/projects/sedsed/


## Download / Install

Sedsed is available as a pip package, just install it:

    pip install --user sedsed

- Compatible with Python 2.7 and Python 3.x
- License: GPLv3
- [Released versions](https://github.com/aureliojargas/sedsed/releases)
- [CHANGELOG.md](https://github.com/aureliojargas/sedsed/blob/main/CHANGELOG.md) for the list of changes in each version

> Alternative: sedsed is a single file application, so you can also just download and run [sedsed.py](https://raw.githubusercontent.com/aureliojargas/sedsed/main/sedsed.py). Note that you'll also need to download its only external requirement, [sedparse.py](https://raw.githubusercontent.com/aureliojargas/sedparse/main/sedparse.py).


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

In those examples the sed script was informed as an argument using the `-e` option. Sedsed also supports the `-f` option to inform a sed script file, and the traditional `-n` option to run in quiet mode.

Enjoy!

## See also: sed --debug (available in GNU sed)

GNU sed finally added the `--debug` option in version 4.6 (19 Dec 2018) 🎉

If you already use GNU sed, you may not even need sedsed.

An example from [the manual](https://www.gnu.org/software/sed/manual/sed.html#index-_002d_002ddebug):

```console
$ echo 1 | sed '\%1%s21232'
3

$ echo 1 | sed --debug '\%1%s21232'
SED PROGRAM:
  /1/ s/1/3/
INPUT:   'STDIN' line 1
PATTERN: 1
COMMAND: /1/ s/1/3/
PATTERN: 3
END-OF-CYCLE:
3
```

Another example, from [the original commit](http://git.savannah.gnu.org/cgit/sed.git/commit/?id=3ac640c) that introduced the new feature:

```console
$ seq 3 | sed --debug -e 's/./--&--/ ; 2d'
SED PROGRAM:
  s/./--&--/
  2 d
INPUT:   'STDIN' line 1
PATTERN: 1
COMMAND: s/./--&--/
MATCHED REGEX REGISTERS
  regex[0] = 0-1 '1'
PATTERN: --1--
COMMAND: 2 d
END-OF-CYCLE:
--1--
INPUT:   'STDIN' line 2
PATTERN: 2
COMMAND: s/./--&--/
MATCHED REGEX REGISTERS
  regex[0] = 0-1 '2'
PATTERN: --2--
COMMAND: 2 d
END-OF-CYCLE:
INPUT:   'STDIN' line 3
PATTERN: 3
COMMAND: s/./--&--/
MATCHED REGEX REGISTERS
  regex[0] = 0-1 '3'
PATTERN: --3--
COMMAND: 2 d
END-OF-CYCLE:
--3--
```

GNU sed with `--debug` is showing more information than sedsed (such as the matched regex registers) and clearly states when a cycle ends and when a new line is read from the input. Very useful! It also opted to only show the contents of pattern or hold spaces when a command that can change them is executed (sedsed by default shows both after every command).

> Note: I created sedsed in 2001, because I needed a debugger to help me out in my sed adventures. Just "imagining" the contents of pattern and hold space after every command was no easy task in complex sed scripts. If GNU sed had `--debug` back then, sedsed would never have been created :)
