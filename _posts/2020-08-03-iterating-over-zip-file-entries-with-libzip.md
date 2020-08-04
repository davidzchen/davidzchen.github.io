---
layout: post
title: "Iterating Over Zip File Entries with libzip"
date: 2020-08-03 14:00:00
categories:
  - tech
---

[libzip][libzip] is one of the most full-featured and widely-used open source
libraries for working with Zip arhives and has been [adopted][libzip-users] by
numerous open source projects as well as commercial products.  The library is
implemented in C, which also makes it ideal for implementing language-specific
bindings.

[libzip]: https://libzip.org
[libzip-users]: https://libzip.org/users/

While its [documentation][libzip-docs] is very comprehensive, I find the
descriptions of its various API's to often be unclear, and there are no examples
provided for how various common use cases could be implemented using the
library.

[libzip-docs]: https://libzip.org/documentation/

One such example is iterating over file entries within a Zip archive. How this
could be done is rather non-obvious from reading the documentation, but I was
able to find a [useful post][dir-post] in the [libzip Mailing List
Archive][libzip-discuss] on this specific use case.

[dir-post]: https://libzip.org/libzip-discuss/msg00385.html
[libzip-discuss]: https://libzip.org/libzip-discuss/

As a sidenote, the fact that the mailing list archive page is entitled "List
Archive"--combined with the fact that there is no search functionality on the
website--makes it annoyingly difficult to find information on this topic due to
a lot of unrelated mailing list threads showing up in the search results.

In short, this can be achieved using the
[`zip_get_num_entries`][zip-get-num-entries] and [`zip_get_name`][zip-get-name]
functions. `zip_get_num_entries` returns the number of file entries inside the
archive, and then it is possible to fetch the file names of each entry by its
index:

[zip-get-num-entries]: https://libzip.org/documentation/zip_get_num_entries.html
[zip-get-name]: https://libzip.org/documentation/zip_get_name.html

```c
// archive is a zip_t* returned by either zip_open or zip_open_from_source.
zip_64_t num_entries = zip_get_num_entries(archive, /*flags=*/0);
for (zip_uint64_t i = 0; i < num_entries; ++i) {
  const char* name = zip_get_name(archive, i, /*flags=*/0);
  if (name == nullptr) {
    // Handle error.
  }
  // Do work with name.
}
```

Note that the Zip format does not have the concept of "directories" the way that
file systems generally do. Each entry in a Zip archive has a name, and the entry
names would implicitly reflect the "directory structure" in the archive. This
directory structure can then be reconstructed by the program when extracting
the files onto the local file system. Generally, Zip file libraries treat
"directories" within Zip archives as entries with names ending with `'/'`, for
example as described in the javadoc for
[`java.util.zip.ZipEntry.isDirectory()`][java-isdirectory].

[java-isdirectory]: https://docs.oracle.com/javase/7/docs/api/java/util/zip/ZipEntry.html#isDirectory()

I plan to write a few follow-up posts on this topic, including some more details
about how directories are handled for Zip files (such as the libzip
[`zip_dir_add`][zip-dir-add] function and how Zip archive programs use these
entries), the libzip [`zip_source`][zip-source] data structure and its related
API's, and possibly a few others.

[zip-dir-add]: https://libzip.org/documentation/zip_dir_add.html
[zip-source]: https://libzip.org/documentation/zip_source.html
