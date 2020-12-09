# sedsed Regression Tests


## Requirements

Currently working for GNU sed only.

  - You must have a `gsed` command in your system.
    Create a symlink pointing to the GNU sed executable.


## Instructions

You can run any individual module by itself:

```console
$ ./test/html/run
Generating anagrams.gnu.sed.html
Generating bf2c.sed.html
Generating cal.sed.html
Generating config.sed.html
Generating dc.sed.html
Generating expand.sed.html
Generating fmt.sed.html
Generating html_uc.gnu.sed.html
Generating impossible.gnu.sed.html
Generating incr_num.sed.html
Generating revlines.sed.html
Generating sedcheck.sed.html
Generating sodelnum.gnu.sed.html
Generating sokoban.sed.html
Generating sort.gnu.sed.html
Generating tex2xml.gnu.sed.html
Generating tolower.sed.html
Generating ttest1.sed.html
Generating ttest2.sed.html
$
```

Or run all at once with the main `test/run` script:

```console
$ ./test/run
---- Running html/run...
Generating anagrams.gnu.sed.html
Generating bf2c.sed.html
Generating cal.sed.html
Generating config.sed.html
Generating dc.sed.html
Generating expand.sed.html
Generating fmt.sed.html
Generating html_uc.gnu.sed.html
Generating impossible.gnu.sed.html
Generating incr_num.sed.html
Generating revlines.sed.html
Generating sedcheck.sed.html
Generating sodelnum.gnu.sed.html
Generating sokoban.sed.html
Generating sort.gnu.sed.html
Generating tex2xml.gnu.sed.html
Generating tolower.sed.html
Generating ttest1.sed.html
Generating ttest2.sed.html
---- Running indent/run...
Generating anagrams.gnu.sed
Generating bf2c.sed
Generating cal.sed
Generating config.sed
Generating dc.sed
Generating expand.sed
Generating fmt.sed
Generating html_uc.gnu.sed
Generating impossible.gnu.sed
Generating incr_num.sed
Generating revlines.sed
Generating sedcheck.sed
Generating sodelnum.gnu.sed
Generating sokoban.sed
Generating sort.gnu.sed
Generating tex2xml.gnu.sed
Generating tolower.sed
Generating ttest1.sed
Generating ttest2.sed
---- Running parsing/run...
Testing =
Testing a
Testing address.gnu
Testing address
Testing b
Testing c
Testing comment.gnu
Testing comment
Testing d
Testing d^
Testing fullcmd.gnu
Testing fullcmd
Testing g
Testing g^
Testing gotchas
Testing h
Testing h^
Testing i
Testing l
Testing n
Testing n^
Testing p
Testing p^
Testing q
Testing r
Testing s-delimiter
Testing s-flags.gnu
Testing s-flags
Testing s
Testing t
Testing w
Testing x
Testing y
---- Running scripts/run...
Testing anagrams.gnu.sed
Testing bf2c.sed
Testing cal.sed
Testing config.sed
Testing dc.sed
Testing expand.sed
Testing fmt.sed
Testing html_uc.gnu.sed
Testing impossible.gnu.sed
Testing incr_num.sed
Testing revlines.sed
Testing sedcheck.sed
Testing sodelnum.gnu.sed
Testing sokoban.sed
Testing sort.gnu.sed
Testing tex2xml.gnu.sed
Testing tolower.sed
Testing ttest1.sed
Testing ttest2.sed
$
```
