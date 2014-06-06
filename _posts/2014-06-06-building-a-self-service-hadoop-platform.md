---
layout: post
title: "Building a Self-Service Hadoop Platform at LinkedIn with Azkaban"
date: 2014-06-06 04:46:34
categories: tech
---

At this year's [Hadoop Summit][hadoop-summit] in San Jose, CA, I gave a talk on Building a Self-Service Hadoop Platform at LinkedIn with Azkaban. [Azkaban][azkaban] is LinkedIn's open-source workflow manager first developed back in 2009 with a focus on ease of use. Over the years, Azkaban has grown from being just a workflow scheduler for Hadoop to being an integrated environment for Hadoop tools and the primary front-end to Hadoop at LinkedIn.

The abstract and slides are below. A video of my talk will be available in the coming weeks.

# Abstract

Hadoop comprises the core of LinkedIn’s data analytics infrastructure and runs a vast array of our data products, including People You May Know, Endorsements, and Recommendations. To schedule and run the Hadoop workflows that drive our data products, we rely on Azkaban, an open-source workflow manager developed and used at LinkedIn since 2009. Azkaban is designed to be scalable, reliable, and extensible, and features a beautiful and intuitive UI. Over the years, we have seen tremendous growth, both in the scale of our data and our Hadoop user base, which includes over a thousand developers, data scientists, and analysts. We evolved Azkaban to not only meet the demands of this scale, but also support query platforms including Pig and Hive and continue to be an easy to use, self-service platform. In this talk, we discuss how Azkaban’s monitoring and visualization features allow our users to quickly and easily develop, profile, and tune their Hadoop workflows.

# Slides

<iframe src="http://www.slideshare.net/slideshow/embed_code/35503018" width="638" height="356" frameborder="0" marginwidth="0" marginheight="0" scrolling="no" style="border:1px solid #CCC; border-width:1px 1px 0; margin-bottom:5px; max-width: 100%;" allowfullscreen> </iframe> <div style="margin-bottom:5px"> <strong> <a href="https://www.slideshare.net/DavidChen42/hadoop-summit-2014-building-a-selfservice-hadoop-platform-at-linkedin-with-azkaban" title="Hadoop Summit 2014: Building a Self-Service Hadoop Platform at LinkedIn with Azkaban" target="_blank">Hadoop Summit 2014: Building a Self-Service Hadoop Platform at LinkedIn with Azkaban</a> </strong> from <strong><a href="http://www.slideshare.net/DavidChen42" target="_blank">David Chen</a></strong> </div>

[hadoop-summit]: http://hadoopsummit.org
[azkaban]: https://azkaban.github.io
