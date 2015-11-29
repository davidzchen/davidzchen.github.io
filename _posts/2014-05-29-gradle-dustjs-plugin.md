---
layout: post
title: "Gradle Dust.js Plugin"
date: 2014-05-29 22:55:00
categories: tech
---

[LinkedIn Dust.js][linkedin-dustjs] is a powerful, high-performance, and
extensible front-end templating engine. Here is an excellent [article comparing
Dust.js with other template engines][dustjs-comparison].

After learning [Gradle][gradle], I have been using it almost exclusively for my
JVM projects. While Dust.js plugins have been written for [Play
Framework][dustjs-play] and [JSP][dustjs-jsp], but it seems that nobody had
written one for Gradle to compile Dust.js templates at build time.

As a result, I wrote my own, which is [available on
GitHub][gradle-dustjs-plugin]. The plugin uses [Mozilla Rhino][rhino] to invoke
the `dustc` compiler. You do not need to have Node.js or NPM installed to use
the plugin.

Using the plugin is easy. First, add a buildscript dependency to pull the
`gradle-dustjs-plugin` artifact:

```groovy
buildscript {
  repositories {
    mavenCentral()
  }
  dependencies {
    classpath 'com.linkedin:gradle-dustjs-plugin:1.0.0'
  }
}
```

Then, apply the plugin:

```groovy
apply plugin: 'dustjs'
```

Finally, configure the plugin to specify your input files:

```groovy
dustjs {
  source = fileTree('src/main/tl') {
    include 'template.tl'
  }
  dest = 'src/main/webapp/assets/js'
}
```

At build time, the `dustjs` task will compile your templates to JavaScript
files. The basename of the template file is used as the current name. For
example, compiling the template `template.tl` is equivalent to running the
following `dustc` command:

```bash
dustc --name=template source/template.tl dest/template.js
```

Please [check it out][gradle-dustjs-plugin] and feel free to open issues and pull requests.

[linkedin-dustjs]: http://linkedin.github.io/dustjs/
[dustjs-comparison]: http://engineering.linkedin.com/frontend/client-side-templating-throwdown-mustache-handlebars-dustjs-and-more
[gradle]: http://www.gradle.org
[dustjs-play]: https://github.com/typesafehub/play-plugins/tree/master/dust
[dustjs-jsp]: http://dust4j.noroutine.me/
[gradle-dustjs-plugin]: https://github.com/davidzchen/gradle-dustjs-plugin
[rhino]: https://developer.mozilla.org/en-US/docs/Mozilla/Projects/Rhino
