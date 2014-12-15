sedsed
======

Debugger, indenter and HTMLizer for sed scripts.

##Quick sample

```bash

$ ls
emails
$ cat emails
user@abc.com
otheruser@xyz.net
$ cat emails | sed 's/@.*//'
user
otheruser 
$ cat emails | sedsed -d --plain --hide=hold 's/@.*//'
PATT:user@abc.com
COMM:s/@.*//
PATT:user
user
PATT:otheruser@xyz.net
COMM:s/@.*//
PATT:otheruser
otheruser
$
```

### Explaining

Options:

- `-d` turns debug ON.
- `--plain` shows lines without disambiguation special characters (like $ for endline) more readable.
- `--hide=hold` hides the HOLD SPACE buffer contents, because it is always empty on this example.

Output:

- `PATT`: lines on sedsed's output shows the PATTERN SPACE buffer contents.
- `COMM`: lines show the command being executed.
- `user` and `otheruser` lines are the sed's normal output.
- `$` sign represent the end of the buffer.

## Website

http://aurelio.net/projects/sedsed

