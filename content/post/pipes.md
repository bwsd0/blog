---
title: "Pipes"
date: 2019-06-16T21:28:21+02:00
draft: false
---
The source of this extract is from the late Dennis M. Richies homepage,
published under the tile [The Evolution of the Unix Time-sharing
System](https://www.bell-labs.com/usr/dmr/www/hist.html#pipes).

> **NOTE**: This paper was first presented at the Language Design and Programming
Methodology conference at Sydney, Australia, September 1979. The conference
proceedings were published as "Lecture Notes in Computer Science #79: Language
Design and Programming Methodology", _Springer-Verlag_, 1980. This rendition is
based on a reprinted version appearing in "AT&T Bell Laboratories Technical
Journal 63 No. 6 Part 2", October 1984, pp. 1577-93.

One of the most widely admired contributions of Unix to the culture of operating
systems and command languages is the pipe, as used in a pipeline of commands. Of
course, the fundamental idea was by no means new; the pipeline is merely a
specific form of coroutine. Even the implementation was not unprecedented,
although we didn't know it at the time; the `communication files` of the
Dartmouth Time-Sharing System [10] did very nearly what Unix pipes do, though
they seem not to have been exploited so fully.

Pipes appeared in Unix in 1972, well after the PDP-11 version of the system was
in operation, at the suggestion (or perhaps insistence) of M. D. McIlroy, a
long-time advocate of the non-hierarchical control flow that characterizes
coroutines. Some years before pipes were implemented, he suggested that commands
should be thought of as binary operators, whose left and right operand specified
the input and output files. Thus a `copy` utility would be commanded by

```sh
inputfile copy outputfile
```

To make a pipeline, command operators could be stacked up. Thus, to sort input,
paginate it neatly, and print the result off-line, one would write

```sh
input sort paginate offprint
```

In today's system, this would correspond to

```sh
sort input | pr | opr
```

The idea, explained one afternoon on a blackboard, intrigued us but failed to
ignite any immediate action. There were several objections to the idea as put:
the infix notation seemed too radical (we were too accustomed to typing `cp x y`
to copy x to y); and we were unable to see how to distinguish command parameters
from the input or output files. Also, the one-input one-output model of command
execution seemed too confining. What a failure of imagination!

Some time later, thanks to McIlroy's persistence, pipes were finally installed
in the operating system (a relatively simple job), and a new notation was
introduced. It used the same characters as for I/O redirection. For example, the
pipeline above might have been written

```sh
sort input >pr>opr>
```

The idea is that following a `>` may be either a file, to specify redirection of
output to that file, or a command into which the output of the preceding command
is directed as input. The trailing `>` was needed in the example to specify that
the (nonexistent) output of `opr` should be directed to the console; otherwise
the command `opr` would not have been executed at all; instead a file `opr`
would have been created.

The new facility was enthusiastically received, and the term `filter` was soon
coined. Many commands were changed to make them usable in pipelines. For
example, no one had imagined that anyone would want the sort or pr utility to
sort or print its standard input if given no explicit arguments.

Soon some problems with the notation became evident. Most annoying was a silly
lexical problem: the string after `>` was delimited by blanks, so, to give a
parameter to pr in the example, one had to quote:

```
sort input >"pr -2">opr>
```

Second, in attempt to give generality, the pipe notation accepted `<` as an
input redirection in a way corresponding to `>`; this meant that the notation
was not unique. One could also write, for example,

```
opr <pr<"sort input"<
```

or even

```
pr <"sort input"< >opr>
```

The pipe notation using `<` and `>` survived only a couple of months; it was
replaced by the present one that uses a unique operator to separate components
of a pipeline. Although the old notation had a certain charm and inner
consistency, the new one is certainly superior. Of course, it too has
limitations. It is unabashedly linear, though there are situations in which
multiple redirected inputs and outputs are called for. For example, what is the
best way to compare the outputs of two programs? What is the appropriate
notation for invoking a program with two parallel output streams?

I mentioned above in the section on IO redirection that Multics provided a
mechanism by which IO streams could be directed through processing modules on
the way to (or from) the device or file serving as source or sink. Thus it might
seem that stream-splicing in Multics was the direct precursor of Unix pipes, as
Multics IO redirection certainly was for its Unix version. In fact I do not
think this is true, or is true only in a weak sense. Not only were coroutines
well-known already, but their embodiment as Multics spliceable IO modules
required that the modules be specially coded in such a way that they could be
used for no other purpose. The genius of the Unix pipeline is precisely that it
is constructed from the very same commands used constantly in simplex fashion.
The mental leap needed to see this possibility and to invent the notation is
large indeed.
