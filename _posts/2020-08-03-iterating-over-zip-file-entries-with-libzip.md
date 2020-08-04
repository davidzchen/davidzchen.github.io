---
layout: post
title: "Iterating Over Zip File Entries with libzip"
date: 2020-08-03 14:00:00
categories:
  - tech
---

[libzip][libzip] is one of the most full-featured and widely-used open source
libraries for working with Zip arhives and has been [adopted][libzip-users] by
numerous open source projects as well as commercial projects
The library is implemented in C, which also makes it ideal for implementing
language-specific wrappers.

[libzip]: https://libzip.org
[libzip-users]: https://libzip.org/users/

While its [documentation][libzip-docs] is very comprehensive, I find the
descriptions of different API's and related functions to be unclear, and there
are no examples given of different use cases and how they could be implemented
using the library.

[libzip-docs]: https://libzip.org/documentation/

One such example is iterating over all files within the archive, how this could
be done is very non-obvious, but I found a [useful post][dir-post] in the
[libzip Mailing List Archive][libzip-discuss] on this specific use case.

[dir-post]: https://libzip.org/libzip-discuss/msg00385.html
[libzip-discuss]: https://libzip.org/libzip-discuss/

As a sidenote, the fact that the mailing list archive is entitled "List
Archive," combined with the fact that there is no search functionality on the
website, made it annoyingly difficult to find information on this topic via
Google search.

In short, this can be achieved using the `zip_get_num_entries` and
`zip_get_name` functions. `zip_get_num_entries` returns the number of file
entries inside the archive, and then it is possible to fetch the file names of
each entry by its index inside the archive:

```c
// archive is a zip_t* returned by either zip_open or zip_open_from_source
zip_64_t num_entries = zip_get_num_entries(archive, 0);
for (zip_uint64_t i = 0; i < num_entries; ++i) {
  const char* name = zip_get_name(archive, i, ZIP_FL_ENC_GUESS);
  if (name == nullptr) {
    // Handle error
  }
  // Do work with name
}
```

Note that Zip files do not not have the concept of "directories" the way that
file systems do. Each entry in a Zip archive has a name, and the name would
implicitly reflect the "directory structure" in the archive, and this directory
structure would be created when the archive is extracted onto the local file
system.

One interesting point to note is that libzip provides a `zip_dir_add` function,
which adds an entry to the archive for a directory. 
