/*  Functions from hack's utils library.
    Copyright (C) 1989-2019 Free Software Foundation, Inc.

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 3, or (at your option)
    any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; If not, see <https://www.gnu.org/licenses/>. */

#include <config.h>

#include <stdio.h>
#include <stdarg.h>
#include <errno.h>
#include <string.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>
#include <limits.h>

#include "binary-io.h"
#include "unlocked-io.h"
#include "utils.h"
#include "progname.h"
#include "fwriting.h"
#include "xalloc.h"

#if O_BINARY
extern bool binary_mode;
#endif

/* Store information about files opened with ck_fopen
   so that error messages from ck_fread, ck_fwrite, etc. can print the
   name of the file that had the error */

struct open_file
  {
    FILE *fp;
    char *name;
    struct open_file *link;
    unsigned temp : 1;
  };

static struct open_file *open_files = NULL;
static void do_ck_fclose (FILE *fp);

/* Print an error message and exit */

void
panic (const char *str, ...)
{
  va_list ap;

  fprintf (stderr, "%s: ", program_name);
  va_start (ap, str);
  vfprintf (stderr, str, ap);
  va_end (ap);
  putc ('\n', stderr);

  /* Unlink the temporary files.  */
  while (open_files)
    {
      if (open_files->temp)
        {
          fclose (open_files->fp);
          errno = 0;
          unlink (open_files->name);
          if (errno != 0)
            fprintf (stderr, _("cannot remove %s: %s"), open_files->name,
                     strerror (errno));
        }

#ifdef lint
      struct open_file *next = open_files->link;
      free (open_files->name);
      free (open_files);
      open_files = next;
#else
      open_files = open_files->link;
#endif
    }

  exit (EXIT_PANIC);
}

/* Internal routine to get a filename from open_files */
static const char * _GL_ATTRIBUTE_PURE
utils_fp_name (FILE *fp)
{
  struct open_file *p;

  for (p=open_files; p; p=p->link)
    if (p->fp == fp)
      return p->name;
  if (fp == stdin)
    return "stdin";
  else if (fp == stdout)
    return "stdout";
  else if (fp == stderr)
    return "stderr";

  return "<unknown>";
}

static void
register_open_file (FILE *fp, const char *name)
{
  struct open_file *p;
  for (p=open_files; p; p=p->link)
    {
      if (fp == p->fp)
        {
          free (p->name);
          break;
        }
    }
  if (!p)
    {
      p = XCALLOC (1, struct open_file);
      p->link = open_files;
      open_files = p;
    }
  p->name = xstrdup (name);
  p->fp = fp;
  p->temp = false;
}

/* Panic on failing fopen */
FILE *
ck_fopen (const char *name, const char *mode, int fail)
{
  FILE *fp;

  fp = fopen (name, mode);
  if (!fp)
    {
      if (fail)
        panic (_("couldn't open file %s: %s"), name, strerror (errno));

      return NULL;
    }

  register_open_file (fp, name);
  return fp;
}

/* Panic on failing fdopen */
FILE *
ck_fdopen ( int fd, const char *name, const char *mode, int fail)
{
  FILE *fp;

  fp = fdopen (fd, mode);
  if (!fp)
    {
      if (fail)
        panic (_("couldn't attach to %s: %s"), name, strerror (errno));

      return NULL;
    }

  register_open_file (fp, name);
  return fp;
}

FILE *
ck_mkstemp (char **p_filename, const char *tmpdir,
            const char *base, const char *mode)
{
  char *template = xmalloc (strlen (tmpdir) + strlen (base) + 8);
  sprintf (template, "%s/%sXXXXXX", tmpdir, base);

   /* The ownership might change, so omit some permissions at first
      so unauthorized users cannot nip in before the file is ready.
      mkstemp forces O_BINARY on cygwin, so use mkostemp instead.  */
  mode_t save_umask = umask (0700);
  int fd = mkostemp (template, 0);
  umask (save_umask);
  if (fd == -1)
    panic (_("couldn't open temporary file %s: %s"), template,
           strerror (errno));
#if O_BINARY
  if (binary_mode && (set_binary_mode ( fd, O_BINARY) == -1))
      panic (_("failed to set binary mode on '%s'"), template);
#endif

  *p_filename = template;
  FILE *fp = fdopen (fd, mode);
  register_open_file (fp, template);
  return fp;
}

/* Panic on failing fwrite */
void
ck_fwrite (const void *ptr, size_t size, size_t nmemb, FILE *stream)
{
  clearerr (stream);
  if (size && fwrite (ptr, size, nmemb, stream) != nmemb)
    panic (ngettext ("couldn't write %llu item to %s: %s",
                   "couldn't write %llu items to %s: %s", nmemb),
          (unsigned long long) nmemb, utils_fp_name (stream),
          strerror (errno));
}

/* Panic on failing fread */
size_t
ck_fread (void *ptr, size_t size, size_t nmemb, FILE *stream)
{
  clearerr (stream);
  if (size && (nmemb=fread (ptr, size, nmemb, stream)) <= 0 && ferror (stream))
    panic (_("read error on %s: %s"), utils_fp_name (stream), strerror (errno));

  return nmemb;
}

size_t
ck_getdelim (char **text, size_t *buflen, char buffer_delimiter, FILE *stream)
{
  ssize_t result;
  bool error;

  error = ferror (stream);
  if (!error)
    {
      result = getdelim (text, buflen, buffer_delimiter, stream);
      error = ferror (stream);
    }

  if (error)
    panic (_("read error on %s: %s"), utils_fp_name (stream), strerror (errno));

  return result;
}

/* Panic on failing fflush */
void
ck_fflush (FILE *stream)
{
  if (!fwriting (stream))
    return;

  clearerr (stream);
  if (fflush (stream) == EOF && errno != EBADF)
    panic ("couldn't flush %s: %s", utils_fp_name (stream), strerror (errno));
}

/* Panic on failing fclose */
void
ck_fclose (FILE *stream)
{
  struct open_file r;
  struct open_file *prev;
  struct open_file *cur;

  /* a NULL stream means to close all files */
  r.link = open_files;
  prev = &r;
  while ( (cur = prev->link) )
    {
      if (!stream || stream == cur->fp)
        {
          do_ck_fclose (cur->fp);
          prev->link = cur->link;
          free (cur->name);
          free (cur);
        }
      else
        prev = cur;
    }

  open_files = r.link;

  /* Also care about stdout, because if it is redirected the
     last output operations might fail and it is important
     to signal this as an error (perhaps to make). */
  if (!stream)
    do_ck_fclose (stdout);
}

/* Close a single file. */
void
do_ck_fclose (FILE *fp)
{
  ck_fflush (fp);
  clearerr (fp);

  if (fclose (fp) == EOF)
    panic ("couldn't close %s: %s", utils_fp_name (fp), strerror (errno));
}

/* Follow symlink and panic if something fails.  Return the ultimate
   symlink target, stored in a temporary buffer that the caller should
   not free.  */
const char *
follow_symlink (const char *fname)
{
#ifdef ENABLE_FOLLOW_SYMLINKS
  static char *buf1, *buf2;
  static int buf_size;

  struct stat statbuf;
  const char *buf = fname, *c;
  int rc;

  if (buf_size == 0)
    {
      buf1 = xzalloc (PATH_MAX + 1);
      buf2 = xzalloc (PATH_MAX + 1);
      buf_size = PATH_MAX + 1;
    }

  while ((rc = lstat (buf, &statbuf)) == 0
         && (statbuf.st_mode & S_IFLNK) == S_IFLNK)
    {
      if (buf == buf2)
        {
          strcpy (buf1, buf2);
          buf = buf1;
        }

      while ((rc = readlink (buf, buf2, buf_size)) == buf_size)
        {
          buf_size *= 2;
          buf1 = xrealloc (buf1, buf_size);
          buf2 = xrealloc (buf2, buf_size);
        }
      if (rc < 0)
        panic (_("couldn't follow symlink %s: %s"), buf, strerror (errno));
      else
        buf2 [rc] = '\0';

      if (buf2[0] != '/' && (c = strrchr (buf, '/')) != NULL)
        {
          /* Need to handle relative paths with care.  Reallocate buf1 and
             buf2 to be big enough.  */
          int len = c - buf + 1;
          if (len + rc + 1 > buf_size)
            {
              buf_size = len + rc + 1;
              buf1 = xrealloc (buf1, buf_size);
              buf2 = xrealloc (buf2, buf_size);
            }

          /* Always store the new path in buf1.  */
          if (buf != buf1)
            memcpy (buf1, buf, len);

          /* Tack the relative symlink at the end of buf1.  */
          memcpy (buf1 + len, buf2, rc + 1);
          buf = buf1;
        }
      else
        {
          /* Use buf2 as the buffer, it saves a strcpy if it is not pointing to
             another link.  It works for absolute symlinks, and as long as
             symlinks do not leave the current directory.  */
           buf = buf2;
        }
    }

  if (rc < 0)
    panic (_("cannot stat %s: %s"), buf, strerror (errno));

  return buf;
#else
  return fname;
#endif /* ENABLE_FOLLOW_SYMLINKS */
}

/* Panic on failing rename */
void
ck_rename (const char *from, const char *to, const char *unlink_if_fail)
{
  int rd = rename (from, to);
  if (rd != -1)
    return;

  if (unlink_if_fail)
    {
      int save_errno = errno;
      errno = 0;
      unlink (unlink_if_fail);

      /* Failure to remove the temporary file is more severe,
         so trigger it first.  */
      if (errno != 0)
        panic (_("cannot remove %s: %s"), unlink_if_fail, strerror (errno));

      errno = save_errno;
    }

  panic (_("cannot rename %s: %s"), from, strerror (errno));
}




/* Implement a variable sized buffer of `stuff'.  We don't know what it is,
nor do we care, as long as it doesn't mind being aligned by malloc. */

struct buffer
  {
    size_t allocated;
    size_t length;
    char *b;
  };

#define MIN_ALLOCATE 50

struct buffer *
init_buffer (void)
{
  struct buffer *b = XCALLOC (1, struct buffer);
  b->b = XCALLOC (MIN_ALLOCATE, char);
  b->allocated = MIN_ALLOCATE;
  b->length = 0;
  return b;
}

char *
get_buffer (struct buffer const *b)
{
  return b->b;
}

size_t
size_buffer (struct buffer const *b)
{
  return b->length;
}

static void
resize_buffer (struct buffer *b, size_t newlen)
{
  char *try = NULL;
  size_t alen = b->allocated;

  if (newlen <= alen)
    return;
  alen *= 2;
  if (newlen < alen)
    try = realloc (b->b, alen);	/* Note: *not* the REALLOC() macro! */
  if (!try)
    {
      alen = newlen;
      try = REALLOC (b->b, alen, char);
    }
  b->allocated = alen;
  b->b = try;
}

char *
add_buffer (struct buffer *b, const char *p, size_t n)
{
  char *result;
  if (b->allocated - b->length < n)
    resize_buffer (b, b->length+n);
  result = memcpy (b->b + b->length, p, n);
  b->length += n;
  return result;
}

char *
add1_buffer (struct buffer *b, int c)
{
  /* This special case should be kept cheap;
   *  don't make it just a mere convenience
   *  wrapper for add_buffer() -- even "builtin"
   *  versions of memcpy(a, b, 1) can become
   *  expensive when called too often.
   */
  if (c != EOF)
    {
      char *result;
      if (b->allocated - b->length < 1)
        resize_buffer (b, b->length+1);
      result = b->b + b->length++;
      *result = c;
      return result;
    }

  return NULL;
}

void
free_buffer (struct buffer *b)
{
  if (b)
    free (b->b);
  free (b);
}
