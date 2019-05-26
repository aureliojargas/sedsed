#n
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:1 {
#--------------------------------------------------
1 {
# Weekday in hold space, day of the month in pattern space
		i\
COMM:h
#--------------------------------------------------
h
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/ .*$//
#--------------------------------------------------
s/ .*$//
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:x
#--------------------------------------------------
x
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/^.* //
#--------------------------------------------------
s/^.* //
# Reduce day of month to 1-7, subtracting 7 repeatedly. Each iteration
# decrements the tenths digit, lowering the day of the month by either 7
# or 14.  The first and third y commands are guaranteed to operate on the
# units.
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM::week
#--------------------------------------------------
:week
		i\
COMM:/^[123]/ {
#--------------------------------------------------
/^[123]/ {
		i\
COMM:s/^1/a/
#--------------------------------------------------
s/^1/a/
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/^2/b/
#--------------------------------------------------
s/^2/b/
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/^3/c/
#--------------------------------------------------
s/^3/c/
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:y/9876543210/5432176543/
#--------------------------------------------------
y/9876543210/5432176543/
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:y/abc/012/
#--------------------------------------------------
y/abc/012/
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b week
#--------------------------------------------------
b week
		i\
COMM:}
#--------------------------------------------------
}
		i\
COMM:y/89/12/
#--------------------------------------------------
y/89/12/
# Each iteration decrements both day and weekday by 1
# (weekday has wrap-around from 0=Sunday to 6=Saturday)
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM::wday
#--------------------------------------------------
:wday
		i\
COMM:/01/ !{
#--------------------------------------------------
/01/ !{
		i\
COMM:y/234567/123456/
#--------------------------------------------------
y/234567/123456/
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:x
#--------------------------------------------------
x
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:y/0123456/6012345/
#--------------------------------------------------
y/0123456/6012345/
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:x
#--------------------------------------------------
x
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b wday
#--------------------------------------------------
b wday
		i\
COMM:}
#--------------------------------------------------
}
# Prepare a calendar for a 28-day month.  First add the blanks
# depending on the week-day
		i\
COMM:x
#--------------------------------------------------
x
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:/^[1-6]/ s/$/    /
#--------------------------------------------------
/^[1-6]/ s/$/    /
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:/^[2-6]/ s/$/    /
#--------------------------------------------------
/^[2-6]/ s/$/    /
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:/^[3-6]/ s/$/    /
#--------------------------------------------------
/^[3-6]/ s/$/    /
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:/^[4-6]/ s/$/    /
#--------------------------------------------------
/^[4-6]/ s/$/    /
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:/^[5-6]/ s/$/    /
#--------------------------------------------------
/^[5-6]/ s/$/    /
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:/^6/ s/$/    /
#--------------------------------------------------
/^6/ s/$/    /
# Then add the header (replacing the week-day) and the days
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/^./Sun Mon Tue Wed Thu Fri Sat /
#--------------------------------------------------
s/^./Sun Mon Tue Wed Thu Fri Sat /
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/$/  1   2   3   4   5   6   7   8   9  10  11  12  13  14 /
#--------------------------------------------------
s/$/  1   2   3   4   5   6   7   8   9  10  11  12  13  14 /
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/$/ 15  16  17  18  19  20  21  22  23  24  25  26  27  28 /
#--------------------------------------------------
s/$/ 15  16  17  18  19  20  21  22  23  24  25  26  27  28 /
# Store in hold space, waiting for the next cycle
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:h
#--------------------------------------------------
h
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:}
#--------------------------------------------------
}
		i\
COMM:2 {
#--------------------------------------------------
2 {
# Pick the number of days in the month
		i\
COMM:/^[469]/ b d30
#--------------------------------------------------
/^[469]/ b d30
		i\
COMM:/^11/ b d30
#--------------------------------------------------
/^11/ b d30
		i\
COMM:/^[13578]/ b d31
#--------------------------------------------------
/^[13578]/ b d31
# February. Get the year.  Decide whether we must test the century
# or the 2-digit year, and only keep the two relevant digits.
		i\
COMM:s/.* //
#--------------------------------------------------
s/.* //
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:/..00/ s/..$//
#--------------------------------------------------
/..00/ s/..$//
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:/..../ s/^..//
#--------------------------------------------------
/..../ s/^..//
# Test divisibility by 4
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:/[02468][048]/ b d29
#--------------------------------------------------
/[02468][048]/ b d29
		i\
COMM:/[13579][26]/ b d29
#--------------------------------------------------
/[13579][26]/ b d29
		i\
COMM:g
#--------------------------------------------------
g
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b line
#--------------------------------------------------
b line
# Add days if 28 are not enough
		i\
COMM::d29
#--------------------------------------------------
:d29
		i\
COMM:g
#--------------------------------------------------
g
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/$/ 29/
#--------------------------------------------------
s/$/ 29/
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b line
#--------------------------------------------------
b line
		i\
COMM::d30
#--------------------------------------------------
:d30
		i\
COMM:g
#--------------------------------------------------
g
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/$/ 29  30/
#--------------------------------------------------
s/$/ 29  30/
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b line
#--------------------------------------------------
b line
		i\
COMM::d31
#--------------------------------------------------
:d31
		i\
COMM:g
#--------------------------------------------------
g
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/$/ 29  30  31/
#--------------------------------------------------
s/$/ 29  30  31/
# Split the calendar in 28-character lines
# could probably be made more efficient...
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM::line
#--------------------------------------------------
:line
		i\
COMM:h
#--------------------------------------------------
h
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/^\\(............................\\).*/\\1/
#--------------------------------------------------
s/^\(............................\).*/\1/
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:p
#--------------------------------------------------
p
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:/............................/ !q
#--------------------------------------------------
/............................/ !q
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:g
#--------------------------------------------------
g
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:s/^............................//
#--------------------------------------------------
s/^............................//
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x
		i\
COMM:b line
#--------------------------------------------------
b line
		i\
COMM:}
#--------------------------------------------------
}
		s/^/PATT:/
		l
		s/^PATT://
		x
		s/^/HOLD:/
		l
		s/^HOLD://
		x

# Debugged SED script generated by sedsed (https://aurelio.net/projects/sedsed/)
