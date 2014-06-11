---
layout: post
title: "A Curious Case of GCC Include Paths"
date: 2014-05-31 19:04:00
categories: cpp
---

One time, I was building a large C++ codebase and encountered a number of compiler errors that appeared to be caused by constants defined in the system `<time.h>` not getting picked up. Curiously, it appeared that the `time.h` in the current source directory was being included instead, even though the include statement read:

{% highlight cpp %}
#include <time.h>
{% endhighlight %}

From my understanding, the difference between rules for `#include <header.h>` and `#include "header.h"` was that the former searched a set of system header directories first while the latter first searched the current directory. Something was causing GCC to search the current directory for system headers.

To verify that this behavior was not caused by the project's build system, I created a simple Hello World source file `hello.cc` that included `<time.h>`:

{% highlight cpp %}
#include <stdio.h>
#include <time.h>

int main(int argc, char **argv) {
  printf("Hello world.");
  return 0;
}
{% endhighlight %}

I created a `time.h` in the same directory that would raise a compiler error if included:

{% highlight cpp %}
#error "Should not be included"
{% endhighlight %}

Sure enough, when I compiled `test.cc`, it raised the error:

<pre>
$ gcc -o hello hello.cc
In file included from hello.cc:2:0:
./time.h:1:2: error: #error "Should not be included"
</pre>

However, when I ran the same command as root, the compilation succeeded. This meant that there was something in the environment for my user that differed from that of root that is causing GCC to search in the current directory for system headers. This was when I remembered that I was setting `CPLUS_INCLUDE_PATH` in my shell startup script, which I set so that GCC would search other directories, such as `/opt/local/include`, since I use MacPorts.

I finally found that the reason that the current directory is being searched is that I set my `CPLUS_INCLUDE_PATH` as follows:

{% highlight bash %}
export CPLUS_INCLUDE_PATH=$CPLUS_INCLUDE_PATH:/opt/local/include:...
{% endhighlight %}

Appending paths to path variables this way seemed innocuous since most of us follow this convention when adding to our `$PATH`s, but in this case, it turned out to not be so harmless.

Because `$CPLUS_INCLUDE_PATH` is not by default, the first entry is an empty string. One would expect that an empty string would simply be skipped, as is the case for `$PATH`. However, I started to wonder whether an empty string in the `CPLUS_INCLUDE_PATH` actually signified to GCC that the current directory should be searched. A simple test proved that it did:

<pre>
$ export CPLUS_INCLUDE_PATH=/opt/include
$ gcc -o hello hello.cc
$ export CPLUS_INCLUDE_PATH=:/opt/include
$ gcc -o hello hello.cc
In file included from hello.cc:2:0:
./time.h:1:2: error: #error "Should not be included."
</pre>

I eventually found that this was actually [an obscure feature of GCC][gcc-doc]. I am curious to know why this feature was implemented in the first place. The only use case that comes to mind is to get `#include <header.h>` to behave exactly like `#include "header.h"`, which seems more like a hack than a valid use case.

[gcc-doc]: http://gcc.gnu.org/onlinedocs/cpp/Environment-Variables.html
