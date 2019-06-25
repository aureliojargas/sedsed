# enum exit_codes {
EXIT_SUCCESS = 0,           # is already defined as 0
EXIT_BAD_USAGE = 1,         # bad program syntax, invalid command-line options
EXIT_BAD_INPUT = 2,         # failed to open some of the input files
EXIT_PANIC = 4              # PANIC during program execution


# _Noreturn panic(const str, ...) _GL_ATTRIBUTE_FORMAT_PRINTF(1,
#                                                                       2)

# size_t ck_fread(ptr, size_t size, size_t nmemb, stream)
# const follow_symlink(const path)
# size_t ck_getdelim(text, size_t * buflen, buffer_delimiter,


# struct buffer *init_buffer(void)
# size_t size_buffer(struct buffer const *b) _GL_ATTRIBUTE_PURE
