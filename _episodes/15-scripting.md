---
title: "Shell Scripting"
teaching: 50
exercises: 10
questions:
- "What is Shell Scripting?"
- "Why Shell Scripting is important in HPC?"
- "How to program jobs with more complex workflows?"
objectives:
- "Basic shell programming for HPC"
keypoints:
- "Shell scripting brings the ability to control the workflow of commands that you use on the terminal"
- "Shell scripting is important when you need more complex runs or for post-processing"
---

## Why learn shell programming

Working knowledge of shell scripting is essential to anyone at Linux system administration, especially the old-school of sysadmins who dig into the internal machinery of startup and configuration scripts. However, HPC users also see the benefits of having a minimal understanding of Shell Scripting.

A Torque submission script has two roles in a single file. From one side all the lines starting with `#PBS` are interpreted by Torque/Moab but the rest of the file is a shell script. In most cases just a sequence of commands loading modules and command lines, but with some basic knowledge, those scripts can perform far more elaborated executions.

A shell script is a quick way of prototyping a complex execution. Even if you are knowledgeable in Python, another programming language suitable for scripts. There are situations where Shell Scripting is simpler.

## Which Shell

We will be using Bash, an acronym for "Bourne-Again shell" and a pun on Stephen Bourne's now classic Bourne shell. Bash has become a de facto standard for shell scripting on most flavors of Linux/UNIX. Most of the principles this book covers apply equally well to scripting with other shells, such as the Korn Shell, from which Bash derives some of its features, and the C Shell and its variants. Some instructions are specific for Bash and will not work on the POSIX-standard so you decide if you want all the niceties of Bash or stick to the most standard syntax for POSIX-compliant shell.

If you are curious about syntax on bash that extends the POSIX standard see <https://www.gnu.org/software/bash/manual/html_node/Major-Differences-From-The-Bourne-Shell.html>


 ## Starting with the Sha-bang

There two components that make a script usable as such, the first line with a shabang and the execution mode enabled to the script file.

Let us consider this example of a minimal script that will tell you your username, the hostname, and the date (`example1`):

~~~
echo Hello your username is $USER
echo You are running on `hostname`
echo The current date is `date`
~~~
{: .source}

This set of commands is actually a script, however, it has two main problems.
First, there is no indication of which scripting language was written. The shell does not know in advance if that was intended to be executed by `sh`, the default shell on the system, that could be or not `bash`. For example on Debian-like systems (Like Ubuntu and Linux Mint) sh is actually `dash` which is different from `bash`. The second problem is that the file is not executable. If you want to execute this you have to execute it like this:

~~~
sh example1
~~~
{: .source}

We can remediate these two problems by adding one line at the very beginning of the script to indicate which scripting languages the file was written and changing the execution permissions to the file. The file will be like (example2.sh)

~~~
#!/bin/sh

echo Hello your username is $USER
echo You are running on `hostname`
echo The current date is `date`
~~~
{: .language-bash}

And the permissions changed to add executable mode to it

~~~
chmod +x example2.sh
~~~
{: .source}

The sha-bang (`#!`) at the head of a script tells your system that this file is a set of commands to be fed to the command interpreter indicated. The `#!` is a two-byte magic number, a special marker that designates a file type, or in this case an executable shell script.  This is the path to the program that interprets the commands in the script, whether it be a shell, a programming language, or a utility. This command interpreter then executes the commands in the script, starting at the top. For example, these are a few other shabangs for some other interpreters:

~~~
#!/bin/sh
#!/bin/bash
#!/usr/bin/perl
#!/usr/bin/tcl
#!/bin/sed -f
#!/bin/awk -f
#!/usr/bin/env python
#!/usr/bin/env python3
~~~
{: .source}

## A few Special Characters

There are a few characters with special meaning in bash, we will mention here just some of the most usual:

### Comments with `#`

Everything after `#` is ignored by bash

### Command separator `;`

Permits putting two or more commands on the same line.
On the command line, you can also use `;` for that effect.

### Escape `\`

Some characters receive new meaning when preceded by the backslash character.
This is a list of some of them

| Command | Description  |
|---------|--------------|
| \n      | newline      |
| \r      | return       |
| \v      | vertical tab |
| \b      | backspace    |
| \0xx    | translate to octal ASCII |

Example (example4.sh)

~~~
#!/bin/bash

# Escaping a newline.
# ------------------

echo ""

echo "This will print
as two lines."
# This will print
# as two lines.

echo ""

echo "This will print \
as one line."
# This will print as one line.

echo ""

echo -e "This\twill\tprint\twith\ttabs"
# This will print with tabs.

echo; echo

echo "============="


echo "\v\v\v\v"      # Prints \v\v\v\v literally.
# Use the -e option with 'echo' to print escaped characters.
echo "============="
echo "VERTICAL TABS"
echo -e "\v\v\v\v"   # Prints 4 vertical tabs.
echo "=============="

echo "QUOTATION MARK"
echo -e "\042"       # Prints " (quote, octal ASCII character 42).
echo "=============="

echo; echo "NEWLINE"
echo This is going to jump $'\n' to a new line           # Newline.

exit 0
~~~
{: .language-bash}

### Partial quoting `"` and full quoting `'`

Both are ways to preserve a string from interpretation. The full quoting being a stronger form of quoting.  An argument enclosed in double-quotes presents itself as a single word, even if it contains whitespace separators.
Single quotes `'` operate similarly to double quotes, but do not permit referencing variables, since the special meaning of $ is turned off.
Consider this example (example3.sh)

~~~
#!/bin/bash

echo "This variable is interpreted $USER"
echo 'This variable is not interpreted $USER'
~~~
{: .language-bash}

### Wild cards `*` and `?`

Those two characters are interpreted in filename expansions. The character `*` replaces one or more characters in names and `?` only a single character.

### Variable substitution

A `$` prefixing a variable name indicates the value the variable holds.
Sometimes is better to add `{}` to remove ambiguity or when concatenating variables.

### Integer expansion

Expand and evaluate integer expression between (( )).

Example:

~~~
$ a=3; b=5; c=$(( a + b)); echo $c
~~~
{: .language-bash}

### Redirection `> &> >& >> <`

`command >filename` redirects the output of `command` to file `filename`. Overwrite filename if it already exists.

`command &>filename` redirects both the `stdout` and the `stderr` of command to a filename.

`command >&2` redirects stdout of command to stderr.

`command >>filename` appends the output of `command` to file `filename`. If a filename does not already exist, it is created.

`command <filename` takes the entry from filename as stdin for `command` instead of reading from the keyboard

### Logical Operators `&& and ||`

Those operators are used to chain operations.
In the case of `&&` where the second is not used if the first one returns 0.
In the case of `||` the second one is executed if the first one returns a value different from 0.

This is just a brief recollection of the most common special characters that will help us write simple bash scripts. With these and a few conditionals and loops, we are ready to write useful scripts.

## Tests and Conditionals

Executing commands based on the result of a test is fundamental to most programming languages. In bash the structure looks like this:

~~~
if test-expression
then
   statement
fi
~~~
{: .language-bash}

Or adding a clause that includes statements when the test fails:

~~~
if expression
then
   statement
else
   statement
fi
~~~
{: .language-bash}

One simple example shows its usage:

~~~
#!/bin/bash

T1=$1
T2=$2

if [ $T1 -lt $T2 ]
then
    echo The first number $T1 is less than the second one $T2
else
    echo The second number $T2 is less than or equal to the first one $T1
fi
~~~
{: .language-bash}

Conditionals can be written in one line like:

~~~
a=6; b=30; if [ $a -lt $b ]; then echo $a; else echo $b; fi
~~~
{: .language-bash}

This is particularly useful when executing conditionals directly on the terminal.

## Loops

In bash, there are 3 ways of creating loops in bash. `for`, `while`, and `until`.

A few examples show how those loops

~~~
#!/bin/bash
# Listing the planets.

for planet in Mercury Venus Earth Mars Jupiter Saturn Uranus Neptune Pluto
do
  echo $planet  # Each planet on a separate line.
done

echo; echo

for planet in "Mercury Venus Earth Mars Jupiter Saturn Uranus Neptune Pluto"
    # All planets on the same line.
    # Entire 'list' enclosed in quotes creates a single variable.
    # Why? Whitespace incorporated into the variable.
do
  echo $planet
done

echo; echo "Whoops! Pluto is no longer a planet!"

exit 0
~~~
{: .language-bash}

This behavior is very similar to the way **for loops** work on Python where loops iterate or a list or more generally over an iterable variable and it is different on how the same loops work on languages like C or C++. Looping from an initial value and increasing or decreasing its value can be achieved with the other two forms, `while` and `until`.

~~~
#!/bin/bash
COUNTER=0
while [  $COUNTER -lt 10 ]; do
    echo The counter is $COUNTER
    let COUNTER=COUNTER+1
done
~~~
{: .language-bash}

## Exercise

We have now enough elements to start adding a bit more complex scripting to submission scripts. Consider this code (mpi_pi.c)

~~~
#include <stdio.h>
#include <stdlib.h>
#include "mpi.h"
#include <math.h>

int main(argc,argv)
int argc;
char *argv[];
{
    int done = 0, n, myid, numprocs, i;
    double PI25DT = 3.141592653589793238462643;
    double mypi, pi, h, sum, x;

    MPI_Init(&argc,&argv);
    MPI_Comm_size(MPI_COMM_WORLD,&numprocs);
    MPI_Comm_rank(MPI_COMM_WORLD,&myid);

    n = atoi(argv[1]);
    if (n == 0) return 1;

    MPI_Bcast(&n, 1, MPI_INT, 0, MPI_COMM_WORLD);

    h   = 1.0 / (double) n;
    sum = 0.0;
    for (i = myid + 1; i <= n; i += numprocs) {
        x = h * ((double)i - 0.5);
        sum += 4.0 / (1.0 + x*x);
    }
    mypi = h * sum;

    MPI_Reduce(&mypi, &pi, 1, MPI_DOUBLE, MPI_SUM, 0,
           MPI_COMM_WORLD);

    if (myid == 0)
        printf("pi is approximately %.16f, Error is %.16f\n",
           pi, fabs(pi - PI25DT));

    MPI_Finalize();
    return 0;
}
~~~
{: .source}

This code is written in C, uses MPI to get an approximation to PI.
Assuming that you do not know C if you are ask about how the PI converges with the number of elements in the series, the best that you can do is to execute the code over and over with more and more elements.

The challenge is to create a submission script that can compute PI considering from 1 up to 100 terms in the series and store the results in a file.

Write a submission script that effectively achieve that.

In case you have forgotten how to compile this code, here is the command:

~~~
$ mpicc mpi_pi.c -o mpi_pi
~~~
{: .source}

And each execution should be like this:

~~~
mpirun -np 4 ./mpi_pi 100
~~~
{: .source}

# Extracting data with `grep` and `awk`

Once you start creating scripts, the next step is to learn how to deal with a growing amount of information. Two commands are commonly used to extract information from large texts, `grep` and `awk`

Download the data for the lesson. On folder `workshops_hands-on/Introduction_HPC/15._Shell_Scripting` you will find a file called `output.log`. That is an actual output file from a Molecular Dynamics code.

Let us start by getting an idea about the size number of lines of that file:

~~~
$ ls -al output.log
~~~
{: .language-bash}
~~~
-rw-r--r--  1 guilleaf  staff  4264619 Jul  4 22:19 output.log
~~~
{: .output}

The file is 4.1MB. That is a big file for a human to read. Let's see how many lines we can count on it

~~~
$ wc -l output.log
~~~
{: .language-bash}
~~~
92624 output.log
~~~
{: .output}

To get an idea, a normal book page has 30 lines. The text in that output file is equivalent to a book of around 3000 pages. Again, do not pretend to read such output like a book.

To get an idea about the contents of the file we can use less to navigate on the file from the first line.

~~~
$ less output.log
~~~
{: .language-bash}

We are interested in information about the "Time step", in "less" we can find a text content using the "/" command. Inside less enter "/" and the text "Time step" without the quotes. To search for the next occurrence enter `n`

Leave `less` with the command `q`.

The command "grep" can help us to extract the lines from "output.log" that contains the words "Time step" in exactly that case.

~~~
$ grep "Time step" output.log
~~~
{: .language-bash}

~~~
 EBS =         -4651.878461 Time step =     1 SCF step =    1
 EBS =         -3402.809950 Time step =     1 SCF step =    2
 EBS =         -4033.543868 Time step =     1 SCF step =    3
 EBS =         -4157.520527 Time step =     1 SCF step =    4
 EBS =         -3953.007514 Time step =     1 SCF step =    5
 EBS =         -3858.170888 Time step =     1 SCF step =    6
 EBS =         -3823.829702 Time step =     1 SCF step =    7
 EBS =         -3855.938308 Time step =     1 SCF step =    8
 EBS =         -3878.765498 Time step =     1 SCF step =    9
 EBS =         -3831.114003 Time step =     1 SCF step =   10
 EBS =         -3836.165174 Time step =     1 SCF step =   11
 EBS =         -3836.606761 Time step =     1 SCF step =   12
 EBS =         -3840.290377 Time step =     1 SCF step =   13
 EBS =         -3840.380671 Time step =     1 SCF step =   14
 EBS =         -3838.858239 Time step =     1 SCF step =   15
 EBS =         -3838.697136 Time step =     1 SCF step =   16
 EBS =         -3839.093080 Time step =     1 SCF step =   17
 EBS =         -3839.391689 Time step =     1 SCF step =   18
 EBS =         -3839.434217 Time step =     1 SCF step =   19
 EBS =         -3839.663931 Time step =     1 SCF step =   20
 EBS =         -3839.919566 Time step =     1 SCF step =   21
 EBS =         -3840.187570 Time step =     1 SCF step =   22
 EBS =         -3840.160399 Time step =     1 SCF step =   23
 EBS =         -3840.057741 Time step =     1 SCF step =   24
 EBS =         -3840.073968 Time step =     1 SCF step =   25
 EBS =         -3840.056858 Time step =     1 SCF step =   26 SCF success!
   Time step =      1 SCF step =  26 etot/atom =    -275.487042
 EBS =         -3840.090954 Time step =     2 SCF step =    1
 EBS =         -3840.100909 Time step =     2 SCF step =    2 SCF success!
   Time step =      2 SCF step =   2 etot/atom =    -275.487077
 EBS =         -3840.200857 Time step =     3 SCF step =    1
 EBS =         -3840.188603 Time step =     3 SCF step =    2
 EBS =         -3840.114068 Time step =     3 SCF step =    3
 EBS =         -3840.231523 Time step =     3 SCF step =    4 SCF success!
   Time step =      3 SCF step =   4 etot/atom =    -275.487182
 EBS =         -3840.394095 Time step =     4 SCF step =    1
 EBS =         -3840.358688 Time step =     4 SCF step =    2
 EBS =         -3840.158114 Time step =     4 SCF step =    3
 EBS =         -3840.304757 Time step =     4 SCF step =    4 SCF success!
   Time step =      4 SCF step =   4 etot/atom =    -275.487356
 EBS =         -3840.519359 Time step =     5 SCF step =    1
 EBS =         -3840.466959 Time step =     5 SCF step =    2
 EBS =         -3840.172580 Time step =     5 SCF step =    3
 EBS =         -3840.379226 Time step =     5 SCF step =    4 SCF success!
 ...
~~~
{: .output}

Notice that grep is capturing all places where the words "Time step" are found.
Lets imagine that we are interested only in capturing the lines that start with "Time step". The following command instructs grep to do that:


~~~
$ grep "^[ ]*Time step" output.log
~~~
{: .language-bash}

~~~
Time step =      1 SCF step =  26 etot/atom =    -275.487042
Time step =      2 SCF step =   2 etot/atom =    -275.487077
Time step =      3 SCF step =   4 etot/atom =    -275.487182
Time step =      4 SCF step =   4 etot/atom =    -275.487356
Time step =      5 SCF step =   4 etot/atom =    -275.487590
Time step =      6 SCF step =   4 etot/atom =    -275.487877
Time step =      7 SCF step =   4 etot/atom =    -275.488204
Time step =      8 SCF step =   4 etot/atom =    -275.488563
Time step =      9 SCF step =   4 etot/atom =    -275.488951
Time step =     10 SCF step =   4 etot/atom =    -275.489364
Time step =     11 SCF step =   4 etot/atom =    -275.489792
...
~~~
{: .output}

The "^" means to capture only the expression that starts with "Time step", excluding lines where those words appear in the middle. "[ ]\*" means to consider any number of spaces between the beginning of the line and the words we are looking for.

The lines that we are capturing are part of an important block of data that contains information about energetics for that particular time step. With `-A` and `-B` arguments, we can get some lines "Before" and "After" the line captured by our expression, see:

~~~
$ grep "^[ ]*Time step" -A 13 -B 1 output.log
~~~
{: .language-bash}
~~~
---------- T H E  T O T A L  E N E R G Y -----------
 Time step =      1 SCF step =  26 etot/atom =    -275.487042

           ebs =    -3840.056858
     uii - uee =   -31418.040456
     etotxc_1c =     1807.827145
        uxcdcc =      116.338043
          ETOT =   -33333.932126
     Etot/atom =     -275.487042
 Atomic Energy =   -32720.456910
     CohesiveE =     -613.475216

 Cohesive Energy per atom  =       -5.070043
-----------------------------------------------------

--
...
~~~
{: .output}

From those blocks, we extract `ETOT`

~~~
grep "^[ ]*Time step" -A 13 -B 1 output.log | grep ETOT
~~~
{: .language-bash}

From those values we can use AWK to get the average of all those values

~~~
$ grep "^[ ]*Time step" -A 13 -B 1 output.log | grep ETOT | awk '{ sum += $3; n++ } END { if (n > 0) print sum / n; }'
~~~
{: .language-bash}
~~~
-33336.8
~~~
{: .output}

### Extracting text from output files (awk and grep)

On folder `2018-Data-HandsOn/3.Data/1.Text`
there is a compressed file called `goldnano3cu.tgz`.
Uncompress the tar file with

~~~
tar -zxvf goldnano3cu.tgz
~~~
{: .source}

The folders and files are from actual simulations of gold nanoclusters. You can see a sample from the first 10 simulations. The actual simulation was done with actually several hundred files like those.

First, have a look to one of those files. For example `goldnano3cu/0/output.log`. Use `less` or your favorite text editor to get an idea about how the file actually looks. With less, you can search for words typing `/` and the pattern. Search for etot on that file.

The first challenge is to know the value of the total energy per atom. You can see that such information is contained on lines such as

~~~
Time step =    232 SCF step =   3 etot/atom =    -277.072096
~~~
{: .source}

So you can use grep to extract those lines from the output

~~~
$ grep "etot/atom" goldnano3cu/0/output.log
~~~
{: .language-bash}
~~~
...
   Time step =    251 SCF step =   3 etot/atom =    -277.070767
   Time step =    252 SCF step =   3 etot/atom =    -277.070811
   Time step =    253 SCF step =   3 etot/atom =    -277.070817
   Time step =    254 SCF step =   4 etot/atom =    -277.070855
   Time step =    255 SCF step =   3 etot/atom =    -277.070890
   Time step =    256 SCF step =   3 etot/atom =    -277.070922
   Time step =    257 SCF step =   3 etot/atom =    -277.070953
   Time step =    258 SCF step =   3 etot/atom =    -277.070978
~~~
{: .output}

grep is a tool to extract lines from text output using patterns to identify the lines that we need to be shown.

You can see the file again and noticing that after that line there are more information that could be interesting to see.
Execute for example:

~~~
grep -A 9 "etot/atom" goldnano3cu/0/output.log
~~~
{: .source}

Now, we are capturing the lines with \verb|'etot/atom'| and the next 9 lines AFTER. You can also use \texttt{-B} to get lines before the pattern.

~~~
grep -B 1 -A 9 "etot/atom" goldnano3cu/0/output.log
~~~
{: .source}

The pattern so far is just a fixed string. grep was created to use far more complex patterns called regular expressions.

Consider for example that we are searching for lines with the word "Time"

~~~
grep "Time" goldnano3cu/0/output.log
~~~
{: .source}

But, now we realize that we do not want those lines that start with EBS, so we can indicate grep that the pattern matches only the word "Time" at the beginning of the line with some arbitrary number of spaces.

~~~
grep "^ *Time" goldnano3cu/0/output.log
~~~
{: .source}

The following list shows the basic elements for regular expressions.

~~~
. (dot) - a single character.
?       - the preceding character matches 0 or 1 times only.
*       - the preceding character matches 0 or more times.
+       - the preceding character matches 1 or more times.
{n}     - the preceding character matches exactly n times.
{n,m}   - the preceding character matches at least n times        
          and not more than m times.
[agd]   - the character is one of those included
          within the square brackets.
[^agd]  - the character is not one of those included
          within the square brackets.
[c-f]   - the dash within the square brackets operates as a range. In this case it means either the
          letters c, d, e or f.
()      - allows us to group several characters to behave
          as one.
|       - the logical OR operation.
^       - matches the beginning of the line.
$       - matches the end of the line.
~~~
{: .source}

Regular expressions is whole subject by itself and widely used not only by grep, but also many other languages such as awk, perl and python. We will continue the exploration using AWK.

AWK is a programming language designed for text processing and typically used as a data extraction and reporting tool.
In the 1990s, Perl became very popular, competing with AWK in the niche of Unix text-processing languages. Nowadays is Python the most popular language for many purposes including text processing, however for some basic operations is far easier to use a awk line or small script rather than a python one.

Lets go back to our grep command for extracting the \verb|'etot/atom'|, lets use for example a line like this:

~~~
grep "^ *Time" goldnano3cu/0/output.log
~~~
{: .source}

Lets suppose that we would like to get just the number of the iteration and the energy, for example to plot the two columns later on. You can use grep and awk connected with a pipe to produce the result. For example

~~~
grep "^ *Time" goldnano3cu/0/output.log | awk '{print $4, $11}'
~~~
{: .source}

What we are doing here is letting grep to extract the lines that we want and using awk to just print the 4th and 11th column from those lines. Notice the \verb|","| after \verb|$4| otherwise the two numbers will be stick together.

This is a very popular combination, using grep for line extraction and awk to print the output needed.

AWK is able to reproduce the grep execution by itself, for example:

~~~
awk '(/etot\/atom/) {print $0}' goldnano3cu/0/output.log
~~~
{: .source}

And the extraction of the iteration number and energy can be done with:

~~~
awk '(/etot\/atom/) {print $4, $11}' goldnano3cu/0/output.log
~~~
{: .source}

One of the advantages of AWK is that variables are converted on the fly based on use. That allow us to change the value of the energy if we need for example converted to different units. For example:

~~~
awk '(/etot\/atom/) {n=$11; print n*0.0367493, "Ha"}' goldnano3cu/0/output.log
~~~
{: .source}

This line also shows how you can create variables and use it them to manipulate the output.

At this point is good to see AWK as an old fashioned C-like scripting language. Take for example this script:

~~~
#!/bin/awk -f
BEGIN {
# Print the squares from 1 to 10 the first way
    i=1;
    printf("Squares:\n")
    while (i <= 10) {
	printf("The square of %3d is %3d\n", i, i*i);
	i = i+1;
    }
# do it again, using more concise code
    printf("Cubes:\n")
    for (i=1; i <= 10; i++) {
	printf("The cube of %3d is %4d\n", i, i**3);
    }
# now end
    exit;
}
~~~
{: .source}

Lets go back to the output of the simulation. Imagine now that you would like to know the minimum, maximum and average energy per atom. The next script in AWK will do that:

~~~
#!/usr/bin/awk -f
BEGIN {
    emin=10000;
    emax=-10000;
    eavg=0.0
    nele=0
}
(/etot\/atom/){
    etot_atom = $11
    if ( etot_atom < emin ) {
	emin = etot_atom;
    }
    if ( etot_atom > emax ) {
	emax = etot_atom;
    }
    eavg+=etot_atom;
    nele+=1
}
END {
    printf("Minimum: %f Maximum: %f Average: %f\n", emin, emax, eavg/nele);
}
~~~
{: .source}

You can use it like this:

~~~
awk -f awk_min_max_avg.awk goldnano3cu/0/output.log
~~~
{: .source}

In fact you can go further and process all the outputs from the 10 simulations like this:

~~~
awk -f awk_min_max_avg.awk goldnano3cu/*/output.log
~~~
{: .source}

AWK is actually reading more than 7 million lines of output, extracting the relevant lines and computing the maximum, minimum and average from them.

### Working with compressed Files

Compressing text files is one way of reducing the extreme storage cost of using text files for numerical data. We will see how to store files in binary formats later.

Here we demonstrate how to work with compressed text files without explicitly uncompress them.

On `2018-Data-HandsOn/3.Data/1.Text` you will find a file `distributions.dat.gz`.
That file is just one text file that has been compressed with `gzip`

We can use `gunzip -c` to see the file on the screen an eventually using the same techniques above to manipulate and extract data.

~~~
gunzip -c distributions.dat.gz
~~~

> ## Exercises
>
> On the file `distributions.dat.gz` we propose the following exercises, try to not decompress the file explicitly.
>
> 1. Count the number of lines
>
> 2. Count the number of columns. There are several ways with `head`, `tail` or with `awk` using `awk '{print NF; exit}'`
>
> 3. Compute the total sum of the first two columns
>
> 3. Compute the average value of the 3 column in the file
>
> 4. Print two columns, the first column being the sum of the first two original columns and the second one the sum of the third and fourth original columns.
>
{: .challenge}

{% include links.md %}
