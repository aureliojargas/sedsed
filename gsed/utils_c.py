import sys
from mydefs import *
from utils_h import *

# Store information about files opened with ck_fopen
#   so that error messages from ck_fread, ck_fwrite, etc. can print the
#   name of the file that had the error

# struct open_file {
#     struct open_file *link
#     unsigned temp:1

# static struct open_file *open_files = NULL
# static do_ck_fclose(fp)

# Print an error message and exit
def panic(msg):
    print("%s: %s" % (program_name, msg), file=sys.stderr)
    sys.exit(EXIT_PANIC)
# def panic(const str, ...):
#     va_list ap

#     fprintf(stderr, "%s: " % (program_name))
#     va_start(ap, str)
#     vfprintf(stderr, str, ap)
#     va_end(ap)
#     putc('\n', stderr)

#     # Unlink the temporary files.
#     while open_files:
#         if open_files.temp:
#             fclose(open_files.fp)
#             errno = 0
#             os.unlink(open_files.name)
#             if errno != 0:
#                 fprintf(stderr, _("cannot remove %s: %s") % (open_files.name, os.strerror(errno)))
# #ifdef lint
#         struct open_file *next = open_files.link
#         free(open_files.name)
#         free(open_files)
#         open_files = next
# #else
#         open_files = open_files.link
# #endif

#     os.exit(EXIT_PANIC)


# # Internal routine to get a filename from open_files
# static const _GL_ATTRIBUTE_PURE utils_fp_name(fp)
#     struct open_file *p

#     for (p = open_files; p; p = p.link)
#         if p.fp == fp:
#             return p.name
#     if fp == stdin:
#         return "stdin"
#     elif fp == stdout:
#         return "stdout"
#     elif fp == stderr:
#         return "stderr"

#     return "<unknown>"

# def register_open_file(fp, const name):
#     struct open_file *p
#     for (p = open_files; p; p = p.link) {
#         if fp == p.fp:
#             free(p.name)
#             break
#     if not p:
#         p = XCALLOC(1, struct open_file)
#         p.link = open_files
#         open_files = p
#     p.name = xstrdup(name)
#     p.fp = fp
#     p.temp = False

# # Panic on failing fopen
# def ck_fopen(const name, const mode, fail):

#     fp = open(name, mode)
#     if not fp:
#         if fail:
#             panic(_("couldn't open file %s: %s") % (name, os.strerror(errno)))

#         return NULL

#     register_open_file(fp, name)
#     return fp

# # Panic on failing fdopen
# def ck_fdopen(fd, const name, const mode, fail):

#     fp = os.fdopen(fd, mode)
#     if not fp:
#         if fail:
#             panic(_("couldn't attach to %s: %s") % (name, os.strerror(errno)))

#         return NULL

#     register_open_file(fp, name)
#     return fp

# ck_mkstemp(p_filename, const tmpdir,
#                  const base, const mode)
#     template = xmalloc(len(tmpdir) + len(base) + 8)
#     sprintf(template, "%s/%sXXXXXX" % (tmpdir, base))

#     # The ownership might change, so omit some permissions at first
# #       so unauthorized users cannot nip in before the file is ready.
# #       mkstemp forces O_BINARY on cygwin, so use mkostemp instead.
#     mode_t save_umask = os.umask(0700)
#     fd = mkostemp(template; 0)
#     os.umask(save_umask)
#     if fd == -1:
#         panic(_("couldn't open temporary file %s: %s") % (template,
#               os.strerror(errno)))
# #if O_BINARY
#     if binary_mode and (set_binary_mode(fd, O_BINARY) == -1):
#         panic(_("failed to set binary mode on '%s'") % (template))
# #endif

#     *p_filename = template
#     fp = os.fdopen(fd; mode)
#     register_open_file(fp, template)
#     return fp

# # Panic on failing fwrite
# def ck_fwrite(const ptr, size_t size, size_t nmemb, stream):
#     clearerr(stream)
#     if size and fwrite(ptr, size, nmemb, stream) != nmemb:
#         panic(ngettext("couldn't write %llu item to %s: %s" % ("couldn't write %llu items to %s: %s" % (nmemb)),
#               (unsigned long) nmemb, utils_fp_name(stream),
#               os.strerror(errno))

# # Panic on failing fread
# size_t ck_fread(ptr, size_t size, size_t nmemb, stream)
#     clearerr(stream)
#     if size and (nmemb = fread(ptr, size, nmemb, stream): <= 0
#          and ferror(stream))
#         panic(_("read error on %s: %s") % (utils_fp_name(stream),
#               os.strerror(errno)))

#     return nmemb

# size_t
# ck_getdelim(text, size_t * buflen, buffer_delimiter,

#     error = ferror(stream)
#     if not error:
#         result = getdelim(text, buflen, buffer_delimiter, stream)
#         error = ferror(stream)

#     if error:
#         panic(_("read error on %s: %s") % (utils_fp_name(stream),
#               os.strerror(errno)))

#     return result

# # Panic on failing fflush
# def ck_fflush(stream):
#     if not fwriting(stream):
#         return

#     clearerr(stream)
#     if fflush(stream) == EOF and errno != errno.EBADF:
#         panic("couldn't flush %s: %s" % (utils_fp_name(stream),
#               os.strerror(errno)))

# # Panic on failing fclose
# def ck_fclose(stream):
#     struct open_file r
#     struct open_file *prev
#     struct open_file *cur

#     # a NULL stream means to close all files
#     r.link = open_files
#     prev = r
#     while (cur = prev.link):
#         if not stream or stream == cur.fp:
#             do_ck_fclose(cur.fp)
#             prev.link = cur.link
#             free(cur.name)
#             free(cur)
#         } else:
#             prev = cur

#     open_files = r.link

#     # Also care about stdout, because if it is redirected the
# #       last output operations might fail and it is important
# #       to signal this as an error (perhaps to make).
#     if not stream:
#         do_ck_fclose(stdout)

# # Close a single file.
# def do_ck_fclose(fp):
#     ck_fflush(fp)
#     clearerr(fp)

#     if fclose(fp) == EOF:
#         panic("couldn't close %s: %s" % (utils_fp_name(fp), os.strerror(errno)))

# # Follow symlink and panic if something fails.  Return the ultimate
# #   symlink target, stored in a temporary buffer that the caller should
# #   not free.
# const follow_symlink(const fname)
# #ifdef ENABLE_FOLLOW_SYMLINKS
#     static buf1, buf2
#     static buf_size

#     struct stat statbuf
#     const buf = fname, c

#     if buf_size == 0:
#         buf1 = xzalloc(PATH_MAX + 1)
#         buf2 = xzalloc(PATH_MAX + 1)
#         buf_size = PATH_MAX + 1

#     while (rc = os.lstat(buf, &statbuf): == 0
#          and (statbuf.st_mode & S_IFLNK) == S_IFLNK) {
#         if buf == buf2:
#             buf1 = buf2
#             buf = buf1

#         while (rc = readlink(buf, buf2, buf_size)) == buf_size:
#             buf_size *= 2
#             buf1 = xrealloc(buf1, buf_size)
#             buf2 = xrealloc(buf2, buf_size)
#         if rc < 0:
#             panic(_("couldn't follow symlink %s: %s") % (buf,
#                   os.strerror(errno)))
#         else:
#             buf2[rc] = '\0'

#         if buf2[0] != '/' and (c = strrchr(buf, '/')) != NULL:
#             # Need to handle relative paths with care.  Reallocate buf1 and
#               buf2 to be big enough.
#             len = c - buf + 1
#             if len + rc + 1 > buf_size:
#                 buf_size = len + rc + 1
#                 buf1 = xrealloc(buf1, buf_size)
#                 buf2 = xrealloc(buf2, buf_size)

#             # Always store the new path in buf1.
#             if buf != buf1:
#                 memcpy(buf1, buf, len)

#             # Tack the relative symlink at the end of buf1.
#             memcpy(buf1 + len, buf2, rc + 1)
#             buf = buf1
#         else:
#             # Use buf2 as the buffer, it saves a strcpy if it is not pointing to
# #              another link.  It works for absolute symlinks, and as long as
# #              symlinks do not leave the current directory.
#             buf = buf2

#     if rc < 0:
#         panic(_("cannot stat %s: %s") % (buf, os.strerror(errno)))

#     return buf
# #else
#     return fname
# #endif                          # ENABLE_FOLLOW_SYMLINKS

# # Panic on failing rename
# ck_rename(const from, const to, const unlink_if_fail)
#     rd = rename(from; to)
#     if rd != -1:
#         return

#     if unlink_if_fail:
#         save_errno = errno
#         errno = 0
#         os.unlink(unlink_if_fail)

#         # Failure to remove the temporary file is more severe,
#           so trigger it first.
#         if errno != 0:
#             panic(_("cannot remove %s: %s") % (unlink_if_fail,
#                   os.strerror(errno)))

#         errno = save_errno

#     panic(_("cannot rename %s: %s") % (from, os.strerror(errno)))




# Implement a variable sized buffer of `stuff'.  We don't know what it is,
# nor do we care, as long as it doesn't mind being aligned by malloc.

# struct buffer {
#     size_t allocated
#     size_t length

MIN_ALLOCATE    = 50

def init_buffer():
    return []
# struct buffer *init_buffer(void)
#     struct buffer *b = XCALLOC(1, struct buffer)
#     b.b = XCALLOC(MIN_ALLOCATE, char)
#     b.allocated = MIN_ALLOCATE
#     b.length = 0
#     return b

# def get_buffer(struct buffer const *b):
#     return b.b

# size_t size_buffer(struct buffer const *b)
#     return b.length

# def resize_buffer(struct buffer *b, size_t newlen):
#     try = NULL
#     size_t alen = b.allocated

#     if newlen <= alen:
#         return
#     alen *= 2
#     if newlen < alen:
#         try = realloc(b.b, alen)        # Note: *not* the REALLOC() macro!
#     if not try:
#         alen = newlen
#         try = REALLOC(b.b, alen, char)
#     b.allocated = alen
#     b.b = try

# def add_buffer(struct buffer *b, const p, size_t n):
#     if b.allocated - b.length < n:
#         resize_buffer(b, b.length + n)
#     result = memcpy(b.b + b.length, p, n)
#     b.length += n
#     return result

def add1_buffer(buffer, ch):
    if ch != EOF:
        buffer.append(ch)  # in-place
    # the return is never used
#
# def add1_buffer(struct buffer *b, c):
#     # This special case should be kept cheap
# #     *  don't make it just a mere convenience
# #     *  wrapper for add_buffer() -- even "builtin"
# #     *  versions of memcpy(a, b, 1) can become
# #     *  expensive when called too often.
# #
#     if c != EOF:
#         if b.allocated - b.length < 1:
#             resize_buffer(b, b.length + 1)
#         result = b.b + b.length += 1
#         *result = c
#         return result

#     return NULL

def free_buffer(b):
    del b
# def free_buffer(struct buffer *b):
#     if b:
#         free(b.b)
#     free(b)
