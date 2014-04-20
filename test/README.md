# sedsed tester

Currently working for GNU sed only.

  - You must have a `gsed` command in your system.
    Create a symlink pointing to the GNU sed executable.

  - You must change the `sedbin` variable to `gsed` in sedsed.py.

This is the expected output from the tester:

```
$ ./run 
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