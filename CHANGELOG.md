# sedsed changelog

[Version 1.1]: https://github.com/aureliojargas/sedsed/releases/tag/v1.1
[Version 1.0]: https://github.com/aureliojargas/sedsed/releases/tag/v1.0
[Version 0.8]: https://github.com/aureliojargas/sedsed/releases/tag/v0.8
[Version 0.7]: https://github.com/aureliojargas/sedsed/releases/tag/v0.7
[Version 0.6]: https://github.com/aureliojargas/sedsed/releases/tag/v0.6
[Version 0.5]: https://github.com/aureliojargas/sedsed/releases/tag/v0.5
[Version 0.4]: https://github.com/aureliojargas/sedsed/releases/tag/v0.4
[Version 0.3]: https://github.com/aureliojargas/sedsed/releases/tag/v0.3
[Version 0.2]: https://github.com/aureliojargas/sedsed/releases/tag/v0.2
[Version 0.1]: https://github.com/aureliojargas/sedsed/releases/tag/v0.1


## Unreleased changes

- The old "home made" buggy parser for sed scripts was replaced by
  [sedparse](https://github.com/aureliojargas/sedparse), a Python clone
  of the battle-tested GNU sed parser. The previous parsings bugs are
  now vanished and as a bonus, all the GNU sed extensions are now
  supported.
  [961624b](https://github.com/aureliojargas/sedsed/commit/961624b)
  [82c5d19](https://github.com/aureliojargas/sedsed/commit/82c5d19)

- Sedsed license has changed from MIT to GPLv3. This was necessary
  because `sedparse` is a derivative work from GNU sed GPL'd code.
  [f5775be](https://github.com/aureliojargas/sedsed/commit/f5775be)

- Dropped support for Python 2.6. Now sedsed runs in Python versions 2.7
  and >=3.4.
  [#37](https://github.com/aureliojargas/sedsed/issues/37)
  [4c6ec38](https://github.com/aureliojargas/sedsed/commit/4c6ec38)

- The sed emulator was removed. It was incomplete and buggy. Gone are
  the `--emu` and `--emudebug` command line options.
  [#35](https://github.com/aureliojargas/sedsed/issues/35)

- Sedsed can now be imported as a Python module.
  [#9](https://github.com/aureliojargas/sedsed/issues/9)

- Added many new tests to ensure it works as expected.
  [9624d03](https://github.com/aureliojargas/sedsed/commit/9624d03)
  [3665234](https://github.com/aureliojargas/sedsed/commit/3665234)
  [4b07d73](https://github.com/aureliojargas/sedsed/commit/4b07d73)
  [21f6723](https://github.com/aureliojargas/sedsed/commit/21f6723)
  [cc48068](https://github.com/aureliojargas/sedsed/commit/cc48068)

- Source code is now autoformatted by black.
  [13bd67f](https://github.com/aureliojargas/sedsed/commit/13bd67f)

- GNU sed extension: Now supporting `~` and `+` in addresses.
  [#53](https://github.com/aureliojargas/sedsed/issues/53)

- Bugfix: comment after `{` gets repeated.
  [#50](https://github.com/aureliojargas/sedsed/issues/50)

- Bugfix: `;` char should not be special inside comments.
  [#49](https://github.com/aureliojargas/sedsed/issues/49)

- Bugfix: empty block `{}` gets double `{{`.
  [#51](https://github.com/aureliojargas/sedsed/issues/51)

- Bugfix: Properly parse filenames for `r` and `w`.
  [#29](https://github.com/aureliojargas/sedsed/issues/29)

- Bugfix: `[` inside `y` command breaks the parser.
  [#16](https://github.com/aureliojargas/sedsed/issues/16)

- Bugfix: Error when line ends with `;` and a space.
  [#13](https://github.com/aureliojargas/sedsed/issues/13)

- Bugfix: Error when using `;` as delimiter in `s` command.
  [#12](https://github.com/aureliojargas/sedsed/issues/12)

- Bugfix: Add support for escaped chars in `y` command.
  [#11](https://github.com/aureliojargas/sedsed/issues/11)


## [Version 1.1][] released in 2019-05-25

- Added Python 3 support. Now sedsed runs in Python versions 2.6, 2.7
  and 3.x.

- New extensive test suite, including original tests from BSD and GNU
  sed.

- Source code reformatted (PEP-8) and improved (pylint).

- Add support for GNU sed `s///` flags: `M`, `m`, `e`.
  [45f6dea](https://github.com/aureliojargas/sedsed/commit/45f6dea)

- Add support for multiline script in `-e` option.
  [#10](https://github.com/aureliojargas/sedsed/issues/10)

- Bugfix: Improved STDIN handling for BSD sed and Termux.
  [a49703d](https://github.com/aureliojargas/sedsed/commit/a49703d)

- Bugfix: Now correctly parsing `s///w` flag.
  [#4](https://github.com/aureliojargas/sedsed/issues/4)

- Bugfix: Address ranges with spaces before the comma.
  [#2](https://github.com/aureliojargas/sedsed/issues/2)

- Bugfix: `I` char removed in some cases.
  [#1](https://github.com/aureliojargas/sedsed/issues/1)

- Bugfix: htmlize: address `I` flag not removed anymore.
  [#6](https://github.com/aureliojargas/sedsed/issues/6)

- Bugfix: indent: no more trailing spaces.
  [#5](https://github.com/aureliojargas/sedsed/issues/5)

- Bugfix: emulator: fixed command `D`.
  [#7](https://github.com/aureliojargas/sedsed/issues/7)


## [Version 1.0][] released in 2004-12-09

- Portable: Many changes to make the debug file portable, so now it
  works even in old UNIX versions of sed.
  (thanks Gudermez for requesting)
  (thanks Laurent Voguel for his excellent sedcheck tool)

- Debug diet and faster: The debug command to show the current sed
  command was simplified from `s///;P;s///` to a single `i` command,
  reducing the debug file size and increasing execution speed.
  (thanks Thobias Salazar Trevisan for the idea)

- Now the sed program location on the system is configurable inside the
  script (if needed).

- The default indent prefix for `--indent` has changed from 2 to 4
  spaces.

- Added `--dump-debug` option to inspect the generated debug file
  (implies `--nocolor` and `--debug`).

- Generated debug file more readable, with indented debug commands.

- Bugfix: Now parses `a`, `c`, `i` commands with `;` on the text.
  (thanks Leo Mulders for reporting)


## [Version 0.8][] released in 2003-11-15

- Huge code cleanup and rearrange, now it is readable

- Added `-n` option and its aliases `--quiet` and `--silent`
  (thanks Eric Pement)

- Added `-H` option as an alias to `--htmlize`

- Now accepts sed script on STDIN (like sed): `echo p | sed -f - file`

- Changed internal line separator string to ASCII chars
  (thanks Thobias Salazar)

- Bugfix: Script previous checking was broken (thanks Eric Pement)


## [Version 0.7][] released in 2003-01-21

- Added `--color` option (for Windows users)

- Bugfix: Debug file line break on Windows (thanks Eric Pement)


## [Version 0.6][] released in 2002-11-19

- Now sedsed works on Windows/DOS

- New stand-alone .EXE version for Windows users (by py2exe)

- Option `-v` REALLY changed to `-V` (lamer...)


## [Version 0.5][] released in 2002-05-08

- The sedsed program is now compatible with old Python v1.5

- The sed debug file is now temporary (is removed)

- Option `-v` changed to `-V`

- Added `i` flag for `s///` command

- Now the input text is read from STDIN and/or file(s), as in sed

- Now the sed script is read from `-f <file>` and/or `-e <script>`, as
  in sed


## [Version 0.4][] released in 2002-03-27

- Added `--htmlize` option


## [Version 0.3][] released in 2002-02-22

- Added `--version` option

- Added documentation

- Added i386 binary version


## [Version 0.2][] released in 2001-12-22

- Status of `t` command preserved correctly (thanks Paolo Bonzini)


## [Version 0.1][] released in 2001-12-21

- First release on sed-users list


<!-- vim: set textwidth=72: -->
