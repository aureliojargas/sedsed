GNU sed testsuite, adapted for sedsed
=====================================

These files were taken from the GNU sed 4.2 sources, `testsuite` folder.

Originally they're tested using Makefiles, but I've taken a simpler approach:

	sed -f FILE.sed FILE.inp > FILE.good

The correctness of the end result is not important. What matters is that GNU sed and sedsed `--debug` produce the exact same output. The rationale is that **sedsed extra debug commands must not change the script logic nor the results**.

Some adjustments were necessary on a few test files. You can grep them with:

```console
$ git log --oneline --grep=test/gnused
77577af test/gnused: Add testing to all files from this folder
3fdc2ae test/gnused: Add #n top file flag to scripts that need -n
503fbab test/gnused: Update test OK result to the long lines format
4ebbe28 test/gnused: Add newline at EOF for some tests
86b9741 test/gnused: Move repeated files to folder 'off'
5e1a694 test/gnused: Update the .good files to my own GNU sed
231a98b test/gnused: Adapt the BSD sed tests for sedsed
cbb5201 test/gnused: Move unused files to off folder
6a695b2 Add new test module: test/gnused
```

Some tests raise sedsed bugs and were skipped until sedsed is fixed. They're listed inside the `run` script.

Just execute the `run` script to perform the tests.
This is the expected output:

```console
$ test/gnused/run
                Testing bsd.sh
                Testing 0range.sed
                Testing 8bit.sed
                Testing 8to7.sed
                Testing allsub.sed
                Testing appquit.sed
                Testing binary.sed
                Testing bkslashes.sed
                Testing classes.sed
                Testing cv-vars.sed
                Testing dc.sed
                Testing distrib.sed
                Testing dollar.sed
                Testing empty.sed
                Testing enable.sed
                Testing factor.sed
                Testing fasts.sed
                Testing flipcase.sed
                Testing head.sed
                Testing insens.sed
                Testing khadafy.sed
                Testing linecnt.sed
                Testing madding.sed
                Testing middle.sed
                Testing newjis.sed
                Testing numsub.sed
                Testing numsub2.sed
                Testing numsub3.sed
                Testing numsub4.sed
                Testing numsub5.sed
                Testing readin.sed
                Testing recall2.sed
                Testing sep.sed
                Testing space.sed
                Testing uniq.sed
                Testing utf8-1.sed
                Testing xabcx.sed
                Testing xbxcx.sed
                Testing xbxcx3.sed
                Testing xemacs.sed
                Testing y-newline.sed
$
```
