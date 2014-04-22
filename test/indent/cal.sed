#n
1 {
    # Weekday in hold space, day of the month in pattern space
    h
    s/ .*$//
    x
    s/^.* //

    # Reduce day of month to 1-7, subtracting 7 repeatedly. Each iteration
    # decrements the tenths digit, lowering the day of the month by either 7
    # or 14.  The first and third y commands are guaranteed to operate on the
    # units.
    :week
    /^[123]/ {
        s/^1/a/
        s/^2/b/
        s/^3/c/
        y/9876543210/5432176543/
        y/abc/012/
        b week
    }
    y/89/12/

    # Each iteration decrements both day and weekday by 1
    # (weekday has wrap-around from 0=Sunday to 6=Saturday)
    :wday
    /01/ !{
        y/234567/123456/
        x
        y/0123456/6012345/
        x
        b wday
    }

    # Prepare a calendar for a 28-day month.  First add the blanks
    # depending on the week-day
    x
    /^[1-6]/ s/$/    /
    /^[2-6]/ s/$/    /
    /^[3-6]/ s/$/    /
    /^[4-6]/ s/$/    /
    /^[5-6]/ s/$/    /
    /^6/ s/$/    /

    # Then add the header (replacing the week-day) and the days
    s/^./Sun Mon Tue Wed Thu Fri Sat /
    s/$/  1   2   3   4   5   6   7   8   9  10  11  12  13  14 /
    s/$/ 15  16  17  18  19  20  21  22  23  24  25  26  27  28 /

    # Store in hold space, waiting for the next cycle
    h
}

2 {
    # Pick the number of days in the month
    /^[469]/ b d30
    /^11/ b d30
    /^[13578]/ b d31

    # February. Get the year.  Decide whether we must test the century
    # or the 2-digit year, and only keep the two relevant digits.
    s/.* //
    /..00/ s/..$//
    /..../ s/^..//

    # Test divisibility by 4
    /[02468][048]/ b d29
    /[13579][26]/ b d29

    g
    b line

    # Add days if 28 are not enough
    :d29
    g
    s/$/ 29/
    b line

    :d30
    g
    s/$/ 29  30/
    b line

    :d31
    g
    s/$/ 29  30  31/

    # Split the calendar in 28-character lines
    # could probably be made more efficient...
    :line
    h
    s/^\(............................\).*/\1/
    p
    /............................/ !q
    g
    s/^............................//
    b line
}
