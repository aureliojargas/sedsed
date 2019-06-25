import curses.ascii
#  GNU SED, a batch stream editor.
#    Copyright (C) 1998-2019 Free Software Foundation, Inc.
#
#    This program is free software; you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation; either version 2, or (at your option)
#    any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program; If not, see <https://www.gnu.org/licenses/>. 

#ifndef BASICDEFS_H
BASICDEFS_H	= #include <alloca.h>
#include <wchar.h>
#include <locale.h>
#include <wctype.h>

#include <gettext.h>
def N_(String):	return gettext_noop(String)
def _(String):	return gettext(String)

# type countT is used to keep track of line numbers, etc. 
typedef unsigned countT

#include "xalloc.h"

# some basic definitions to avoid undue promulgating of  ugliness 
def REALLOC(x,n,t):	return ((t *)xnrealloc(()(x),(n),sizeof(t)))
def MEMDUP(x,n,t):	return ((t *)xmemdup((x),(n)*sizeof(t)))
def OB_MALLOC(o,n,t):	return ((t *)()obstack_alloc(o,(n)*sizeof(t)))

obstack_chunk_alloc	= xzalloc
obstack_chunk_free	= free

def STREQ(a, b):	return (strcmp (a, b) == 0)
def STREQ_LEN(a, b, n):	return (strncmp (a, b, n) == 0)
def STRPREFIX(a, b):	return (strncmp (a, b, strlen (b)) == 0)

# MAX_PATH is not defined in some platforms, most notably GNU/Hurd.
#   In that case we define it here to some constant.  Note however that
#   this relies in the fact that sed does reallocation if a buffer
#   needs to be larger than PATH_MAX.  
#ifndef PATH_MAX
PATH_MAX	= 200
#endif

# handle misdesigned <ctype.h> macros (snarfed from lib/regex.c) 
# Jim Meyering writes:
#
#   "... Some ctype macros are valid only for character codes that
#   isascii says are ASCII (SGI's IRIX-4.0.5 is one such system --when
#   using /bin/cc or gcc but without giving an ansi option).  So, all
#   ctype uses should be through macros like ISPRINT...  If
#   STDC_HEADERS is defined, then autoconf has verified that the ctype
#   macros don't need to be guarded with references to isascii. ...
#   Defining isascii to 1 should let any compiler worth its salt
#   eliminate the && through constant folding."
#   Solaris defines some of these symbols so we must undefine them first. 

#undef ISASCII
#if defined STDC_HEADERS or (not defined isascii and not defined HAVE_ISASCII)
def ISASCII(c):	1
#else
def ISASCII(c):	return curses.ascii.isascii(c)
#endif

#if defined isblank or defined HAVE_ISBLANK
def ISBLANK(c):	return (ISASCII (c) and isblank (c))
#else
def ISBLANK(c):	return ((c) == ' ' or (c) == '\t')
#endif

#undef ISPRINT
def ISPRINT(c):	return (ISASCII (c) and isprint (c))
def ISDIGIT(c):	return (ISASCII (c) and isdigit ((unsigned char) (c)))
def ISALNUM(c):	return (ISASCII (c) and isalnum (c))
def ISALPHA(c):	return (ISASCII (c) and isalpha (c))
def ISCNTRL(c):	return (ISASCII (c) and iscntrl (c))
def ISLOWER(c):	return (ISASCII (c) and islower (c))
def ISPUNCT(c):	return (ISASCII (c) and ispunct (c))
def ISSPACE(c):	return (ISASCII (c) and isspace (c))
def ISUPPER(c):	return (ISASCII (c) and isupper (c))
def ISXDIGIT(c):	return (ISASCII (c) and isxdigit (c))

#ifndef initialize_main
#ifdef __EMX__
def initialize_main(argcp, argvp):	\
  { _response (argcp, argvp); _wildcard (argcp, argvp); }
#else				# NOT __EMX__ 
def initialize_main(argcp, argvp):	#endif
#endif

#endif				#!BASICDEFS_H 
