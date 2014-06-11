---
layout: post
title: "Gradle Debugging Tips"
date:   2014-06-11 20:13:24
categories: gradle
---

# Profiling Gradle builds

To profile a Gradle build:

<pre>
gradle --profile <targets>
</pre>

This generates an HTML report that is available in `build/reports/profile`.

# Stuff

<pre>
gradle dependencies
gradle tasks --all
</pre>

# Printing Test Results

One feature of Maven that I have come to like is displaying a brief summary of the number of tests run, passed, failed, or skipped for each test suite. The following will do the same in Gradle:

{% highlight groovy %}
test {
  testLogging {
    afterSuite { desc, result ->
      if (desc.getParent()) {
        println desc.getName()
      } else {
        println "Overall"
      }
      println "  ${result.resultType} (" +
            "${result.testCount} tests, " +
            "${result.successfulTestCount} passed, " +
            "${result.failedTestCount} failed, " +
            "${result.skippedTestCount} skipped)"
    }
  }
}
{% endhighlight %}

