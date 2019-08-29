# GNU sed accepts end-of-line comments with no ; before.

/bla/ {                                ;# at this address
    # at this address
    h                                  ;# do this
    g                                  ;# than that
    #
}                                      ;#loop end

s///                                   ;# script end
