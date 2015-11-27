---
layout: post
title: "Designing this Blog"
date:   2014-05-26 20:13:24
categories: notes
---

I wanted the design of the blog to be minimalist and focused on the two primary
types of content: text and code. I built the blog's template with
[Bootstrap][bootstrap], using [@mdo][mdo]'s [Bootstrap blog
template][bootstrap-blog] as a starting point, and removed all the accents and
chrome, save for the page footer.

This blog makes use of two different typefaces. All text content on this blog
uses Donald Knuth's iconic [Computer Modern Serif][computer-modern] font,
applied using [@christianp][christianp]'s [CM web fonts][computer-modern-web].
All `inline code` is typeset in Computer Modern Typewriter.

Code listings, on the other hand, use [Liberation Mono][liberation-mono] and is
typeset against a subtly different background to contrast with the text
discussion. I fell in love with the [Base16 Ocean][base16-ocean] color scheme
by [Chris Kempson][chris-kempson] and have been using Base16 Ocean Dark as the
color scheme for my terminal and Vim. For the code listings on this blog, I
chose to use Base16 Ocean Light to complement the minimal look of the blog.

```go
func fibonacci(n int) int {
	if n < 2 {
		return n
	}
	return fibonacci(n - 1) + fibonacci(n - 2)
}
```

Finally, the blog is generated using [Jekyll][jekyll] and is hosted on
[GitHub Pages][github-pages].

[base16-ocean]: http://chriskempson.github.io/base16/#ocean
[bootstrap]: http://getbootstrap.org
[bootstrap-blog]: http://getbootstrap.com/examples/blog/
[chris-kempson]: http://chriskempson.com/
[christianp]: http://twitter.com/christianp
[computer-modern]: http://en.wikipedia.org/wiki/Computer_Modern
[computer-modern-web]: http://checkmyworking.com/cm-web-fonts/
[github-pages]: https://pages.github.com/
[jekyll]: http://jekyllrb.com
[liberation-mono]: https://fedorahosted.org/liberation-fonts/
[mdo]: http://twitter.com/mdo
