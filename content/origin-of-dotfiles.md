---
title: "Rob Pike on the origin of dotfiles"
date: 2019-06-20T08:10:43+02:00
draft: false
summary: "A lesson in shortcuts"
description: "Verbatim copy of Rob Pike's historical anecdote on the origin hidden files (dotfiles) in Unix"
---
## Note
_The original [Google+ post](https://plus.google.com/101960720994009339267/posts/R58WgWwN9jp) (dead link) by [Rob Pike](http://genius.cat-v.org/rob-pike/) is from August 3, 2012. This version was archived from the [original](https://web.archive.org/web/20190320095434/https://plus.google.com/+RobPikeTheHuman/posts/R58WgWwN9jp) on March 20 2019, and is reposted here for posterity._

## A lesson in shortcuts.

Long ago, as the design of the Unix file system was being worked out, the
entries "`.`" and "`..`" appeared, to make navigation easier. I'm not sure but I
believe "`..`" went in during the Version 2 rewrite, when the file system became
hierarchical (it had a very different structure early on). When one typed ls,
however, these files appeared, so either Ken or Dennis added a simple test to
the program. It was in assembler then, but the code in question was equivalent
to something like this:

```c
if (name[0] == '.') continue;
````

This statement was a little shorter than what it should have been, which is:

```c
if (strcmp(name, ".") == 0 || strcmp(name,"..") == 0) continue;
```

But hey, it was easy.

Two things resulted. First, a bad precedent was set. A lot of other lazy
programmers introduced bugs by making the same simplification. Actual files
beginning with periods are often skipped when they should be counted.

Second, and much worse, the idea of a "hidden" or "dot" file was created. As a
consequence, more lazy programmers started dropping files into everyone's home
directory. I don't have all that much stuff installed on the machine I'm using
to type this, but my home directory has about a hundred dot files and I don't
even know what most of them are or whether they're still needed. Every file name
evaluation that goes through my home directory is slowed down by this
accumulated sludge.

I'm pretty sure the concept of a hidden file was an unintended consequence. It
was certainly a mistake.

How many bugs and wasted CPU cycles and instances of human frustration (not to
mention bad design) have resulted from that one small shortcut about 40 years
ago?

Keep that in mind next time you want to cut a corner in your code.

(For those who object that dot files serve a purpose, I don't dispute that but
counter that it's the files that serve the purpose, not the convention for their
names. They could just as easily be in `$HOME/cfg` or `$HOME/lib`, which is what
we did in [Plan 9](https://9p.io/plan9/), which had no dot files. Lessons can be
learned.)
