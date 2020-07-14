---
title: "Command Line Interface"
teaching: 30
exercises: 30
questions:
- "How do I use the Linux terminal?"
objectives:
- "Commands to connect to the HPC"
- "Navigating the filesystem"
- "Creating, moving, and removing files/directories"
keypoints:
- "One command at a time; press `enter` in between"
---

## Command Line Interface

At a high level, a HPC cluster is a big computer to be used by several users at the same time. The users expect to run a variety of scientific codes, store the data needed as input or generated as output. In HPC, computers usually communicate with each other for tasks that are too big for a single computer while allowing us to make decisions and see errors.

Our interactions with computers happen in many different ways, including through a keyboard and mouse, touch screen interfaces, or using speech recognition systems. However in HPC we need an efficient and still very light way of communicating with the computer that acts as the brain of the cluster, the **head node**. For this, we make use of the **shell** instead of a **graphical user interface** (GUI).

The GUI is the most widely used way to interact with personal computers. We give instructions (to run a program, to copy a file, to create a new folder/directory) with the convenience of a few mouse clicks. This way of interacting with a computer is intuitive and very easy to learn but scales very poorly for large streams of instructions even if they are similar or identical.

For example, you need to copy the third line of each of a thousand text files stored in thousand different folders and paste it into a single file line by line. Using the traditional GUI approach of clicks will take several hours to do this.

This is where we take advantage of the shell - a **command-line interface** to make such repetitive tasks automatic and fast. It can take a single instruction and repeat it as is or with some modification as many times as we want. The task in the example above can be accomplished in a single line of a few instructions.

The heart of a command-line interface is a **read-evaluate-print loop** (REPL) so called because when you type a command and press <kbd>Return</kbd> (also known as <kbd>Enter</kbd>) the shell
reads your command, evaluates (or "executes") it, prints the output of your command, loops back and waits for you to enter another command.

### The Shell


The Shell is a program which runs other programs rather than doing calculations itself.
Those programs can be as complicated as climate modeling software and as simple as a
program that creates a new directory. The simple programs which are used to perform
stand alone tasks are usually referred to as commands.
The most popular Unix shell is Bash, (the Bourne Again SHell --- so-called because
it's derived from a shell written by Stephen Bourne).
Bash is the default shell on most modern implementations of Unix
and in most packages that provide Unix-like tools for Windows.


When the shell is first opened, you are presented with a **prompt**,
indicating that the shell is waiting for input.

~~~
$
~~~
{: .language-bash}

The shell typically uses `$ ` as the prompt, but may use a different symbol like `$>`.

Most importantly: when typing commands, either from these lessons or from other sources, *do not type the prompt*, only the commands that follow it.

## Getting/opening a shell
<div id="shell">
<div>
  <ul class="nav nav-tabs nav-justified" role="tablist">
    <li role="presentation" class="active"><a data-os="windows" href="#shell-windows" aria-controls="Windows" role="tab" data-toggle="tab">Windows</a></li>
    <li role="presentation"><a data-os="macos" href="#shell-macos" aria-controls="MacOS" role="tab" data-toggle="tab">MacOS</a></li>
    <li role="presentation"><a data-os="linux" href="#shell-linux" aria-controls="Linux" role="tab" data-toggle="tab">Linux</a></li>
  </ul>

  <div class="tab-content">
    <article role="tabpanel" class="tab-pane active" id="shell-windows">
    <blockquote><p style = "font-family:georgia,garamond,serif;">
    <h5>There is no bash terminal default on Windows. Below are the steps to acquire one.</h5>

    <h4>Enable WSL</h4>
    <ol>
    <li>Press the Windows key and type "Windows Powershell".</li>
    <li>Right-click and "Run as administrator".</li>
    <li>Paste the following into the shell and press <code>enter</code>.</li>
    <code>
    dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
    </code>
    <li>Close the Powershell and restart the computer.</li>
    </ol>
    <h4>Download the Ubuntu Subspace</h4>
    <ol>
    <li>Press the Windows key.</li>
    <li>Type "Microsoft Store" and press enter.</li>
    <li>Search for "Ubuntu" (the search bar is in the top right of the store) and click the top-most result.</li>
    <li>Install Ubuntu.</li>
    </ol>
    This installation gives your Windows a little bit of Linux inside of it. Launching the Ubuntu app will give you a terminal and environment quite similar to those of a Linux machine like our HPCs. Your normal "C drive", "D drive", and so on are found under <code>/mnt</code> in the subspace. More on accessing those later.
    </p>
    </blockquote>
    </article>
    <article role="tabpanel" class="tab-pane active" id="shell-macos">
    <blockquote><p style = "font-family:georgia,garamond,serif;">

    <h5>To open a terminal:</h5>
    <ol>
    <li>Click the Launchpad icon in the Dock.</li>
    <li>Type Terminal in the search field.</li>
    <li>Click Terminal.</li>
    </ol>
    The default terminal for MacOS starting with Catalina is zsh. To start a bash shell, type <code>bash</code> into the terminal and press <code>enter</code>.
    </p>
    </blockquote>

    </article>
    <article role="tabpanel" class="tab-pane active" id="shell-linux">
    <blockquote><p style = "font-family:georgia,garamond,serif;">

    <h5>If you have Linux but don't already know how to open a terminal, Google your distribution and "terminal" to find some instructions.</h5>

    </p>
    </blockquote>
    </article>
  </div>
</div>
</div>
<!--
<details>
<summary>Terminal on Windows 10</summary>
<blockquote><p style = "font-family:georgia,garamond,serif;">
<h5>There is no bash terminal default on Windows. Below are the steps to acquire one.</h5>

<h4>Enable WSL</h4>
<ol>
<li>Press the Windows key and type "Windows Powershell".</li>
<li>Right-click and "Run as administrator".</li>
<li>Paste the following into the shell and press <code>enter</code>.</li>
<code>
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
</code>
<li>Close the Powershell and restart the computer.</li>
</ol>
<h4>Download the Ubuntu Subspace</h4>
<ol>
<li>Press the Windows key.</li>
<li>Type "Microsoft Store" and press enter.</li>
<li>Search for "Ubuntu" (the search bar is in the top right of the store) and click the top-most result.</li>
<li>Install Ubuntu.</li>
</ol>
This installation gives your Windows a little bit of Linux inside of it. Launching the Ubuntu app will give you a terminal and environment quite similar to those of a Linux machine like Thorny Flat. Your normal "C drive", "D drive", and so on are found under <code>/mnt</code> in the subspace. More on accessing those later.
</p>
</blockquote>
</details>

<details>
<summary>Terminal on MacOS</summary>
<blockquote><p style = "font-family:georgia,garamond,serif;">

<h5>To open a terminal:</h5>
<ol>
<li>Click the Launchpad icon in the Dock.</li>
<li>Type Terminal in the search field..</li>
<li>Click Terminal.</li>
</ol>
The default terminal for MacOS starting with Catalina is zsh. To start a bash shell, type <code>bash</code> into the terminal and press <code>enter</code>.
</p>
</blockquote>
</details>

<details>
<summary>Terminal on Linux</summary>
<blockquote><p style = "font-family:georgia,garamond,serif;">

<h5>If you have Linux but don't already know how to open a terminal, Google your distribution adn "terminal" to find some instructions.</h5>

</p>
</blockquote>
</details>
-->

## Connecting to the cluster

Now it is time to get into the cluster.

Open a terminal shell and type:

~~~
$ ssh <username>@<hostname>
~~~
{: .language-bash}

or

~~~
$ ssh -X <username>@<hostname>
~~~
{: .language-bash}

Where ``<username>`` is your *WVU Login account* username and ``<hostname>`` is the name of the cluster you wish to connect to.
The -X option is used to forward X windows applications running on the server to be forwarded to your local machine.
Remember that the ``$`` symbols above are there to indicate a command on the terminal, you should not enter those initial characters.

We currently have two clusters **Thorny Flat** and **Spruce Knob**

### Spruce Knob

To connect to Spruce Knob use the following command:

~~~
  $ ssh <username>@spruce.hpc.wvu.edu
~~~
{: .language-bash}

**Note:** Two-factor authentication is required to connect to Spruce Knob when not on WVU's Main Campus Network.  More about WVU's Two-Factor Authentication system can be found [here](https://wvu.teamdynamix.com/TDClient/KB/Default?CategoryID=3626)


### Thorny Flat

To connect to Thorny Flat, you will first have to connect to WVU's SSH gateway server.  This gateway server will allow you to connect the Thorny Flat, which is hosted at the Pittsburgh Supercomputing Center.

~~~
$ ssh <username>@ssh.wvu.edu
~~~
{: .language-bash}

More information on WVU's Gateway Service can be found [here](https://wvu.teamdynamix.com/TDClient/Requests/ServiceDet?ID=27427).  When your account is created to for Thorny Flat, you will automatically be approved for access to WVU's SSH Gateway Service.

**Note:** Two-factor authentication is required to connect to WVU's Gateway Service.  More about WVU's Two-Factor Authentication system can be found [here](https://wvu.teamdynamix.com/TDClient/KB/Default?CategoryID=3626)

then:

~~~
$ ssh tf.hpc.wvu.edu
~~~
{: .language-bash}

### Logging In

When your SSH access is granted, you will be prompted with a login message
with helpful commands and updates about the cluster.

At this point, you will get a terminal prompt such as:

~~~
<username>@srih0001:~$
~~~
{: .language-bash}

All the commands executed from now on are happening on a remote machine, the Spruce Knob *head node*, this is the place were most of your direct interaction with the cluster happens.

### Logging Out

Logging out of a cluster can be done with the exit command:

~~~
$ exit
~~~
{: .language-bash}

The exit command will attempt to terminate any process running on the head.
In some cases, you will get an error that jobs are either currently running or currently stopped.  You can view stopped jobs using the `jobs` command:

~~~
$ jobs -l
[1]+ 3325 Stopped            vim script56.py
~~~
{: .language-bash}

The output of jobs -l will give you the job PID number (in this case 3325) and
the command (vim script56.py).  To kill jobs preventing successful log out,
use the kill command:

~~~
$ kill -s 9 3325
~~~
{: .language-bash}

Once all jobs are terminated, the exit command will close the connection to the host.

## Exercise 1

Get into Spruce with your training account and execute the commands `ls`, `date` and `cal`

Exit from Spruce with `exit`


So let's try our first command, which will list the contents of the current directory:

~~~
[training001@srih0001 ~]$ ls -al
~~~
{: .language-bash}
~~~
total 64
drwx------   4 training001 training   512 Jun 27 13:24 .
drwxr-xr-x 151 root        root     32768 Jun 27 13:18 ..
-rw-r--r--   1 training001 training    18 Feb 15  2017 .bash_logout
-rw-r--r--   1 training001 training   176 Feb 15  2017 .bash_profile
-rw-r--r--   1 training001 training   124 Feb 15  2017 .bashrc
-rw-r--r--   1 training001 training   171 Jan 22  2018 .kshrc
drwxr-xr-x   4 training001 training   512 Apr 15  2014 .mozilla
drwx------   2 training001 training   512 Jun 27 13:24 .ssh
~~~
{: .output}

> ## Command not found
> If the shell can't find a program whose name is the command you typed, it
> will print an error message such as:
>
> ~~~
> $ ks
> ~~~
> {: .language-bash}
> ~~~
> ks: command not found
> ~~~
> {: .output}
>
> Usually this means that you have mis-typed the command.
{: .callout}

### Why use the Command Line Interface?

Before the **Command Line Interface** (CLI), computer interaction happened with perforated cards or even switching cables on a big console. Despite all the years of new technology and innovation, the CLI remains one of the most powerful and flexible tools for interacting with computers.

Because it is radically different from a GUI, the CLI can take some effort and time to learn. A GUI presents you with choices for you to click on. With a CLI, the choices are combinations of commands and parameters, more akin to words in a language than buttons on a screen. Because the options not presented to you, some vocabulary is necessary in this new "language". But a small number of commands gets you a long way, and we'll cover those essential few today.

### Flexibility and automation

The grammar of a shell allows you to combine existing tools into powerful
pipelines and handle large volumes of data automatically. Sequences of
commands can be written into a *script*, improving the reproducibility of
workflows and allowing you to repeat them easily.

In addition, the command line is often the easiest way to interact with remote machines and supercomputers.
Familiarity with the shell is near essential to run a variety of specialized tools and resources
including high-performance computing systems.
As clusters and cloud computing systems become more popular for scientific data crunching,
being able to interact with the shell is becoming a necessary skill.
We can build on the command-line skills covered here
to tackle a wide range of scientific questions and computational challenges.

## Exercise 2

Commands in Unix/Linux are very stable with some existing for decades now--don't expect a new update to ruin years of command line training. This exercise begins to give you a feeling of the different parts of a command.

Execute the command `cal`, we executed that in our previous exercise. Execute it again like this `cal -y`. You should get an output like this:

~~~
[training001@srih0001 ~]$ cal -y
~~~
{: .language-bash}
~~~
                               2019                               

       January               February                 March       
Su Mo Tu We Th Fr Sa   Su Mo Tu We Th Fr Sa   Su Mo Tu We Th Fr Sa
       1  2  3  4  5                   1  2                   1  2
 6  7  8  9 10 11 12    3  4  5  6  7  8  9    3  4  5  6  7  8  9
13 14 15 16 17 18 19   10 11 12 13 14 15 16   10 11 12 13 14 15 16
20 21 22 23 24 25 26   17 18 19 20 21 22 23   17 18 19 20 21 22 23
27 28 29 30 31         24 25 26 27 28         24 25 26 27 28 29 30
                                              31
        April                   May                   June        
Su Mo Tu We Th Fr Sa   Su Mo Tu We Th Fr Sa   Su Mo Tu We Th Fr Sa
    1  2  3  4  5  6             1  2  3  4                      1
 7  8  9 10 11 12 13    5  6  7  8  9 10 11    2  3  4  5  6  7  8
14 15 16 17 18 19 20   12 13 14 15 16 17 18    9 10 11 12 13 14 15
21 22 23 24 25 26 27   19 20 21 22 23 24 25   16 17 18 19 20 21 22
28 29 30               26 27 28 29 30 31      23 24 25 26 27 28 29
                                              30
        July                  August                September     
Su Mo Tu We Th Fr Sa   Su Mo Tu We Th Fr Sa   Su Mo Tu We Th Fr Sa
    1  2  3  4  5  6                1  2  3    1  2  3  4  5  6  7
 7  8  9 10 11 12 13    4  5  6  7  8  9 10    8  9 10 11 12 13 14
14 15 16 17 18 19 20   11 12 13 14 15 16 17   15 16 17 18 19 20 21
21 22 23 24 25 26 27   18 19 20 21 22 23 24   22 23 24 25 26 27 28
28 29 30 31            25 26 27 28 29 30 31   29 30

       October               November               December      
Su Mo Tu We Th Fr Sa   Su Mo Tu We Th Fr Sa   Su Mo Tu We Th Fr Sa
       1  2  3  4  5                   1  2    1  2  3  4  5  6  7
 6  7  8  9 10 11 12    3  4  5  6  7  8  9    8  9 10 11 12 13 14
13 14 15 16 17 18 19   10 11 12 13 14 15 16   15 16 17 18 19 20 21
20 21 22 23 24 25 26   17 18 19 20 21 22 23   22 23 24 25 26 27 28
27 28 29 30 31         24 25 26 27 28 29 30   29 30 31
~~~
{: .output}

Another very simple command that is very useful in HPC is `date`.
Without any arguments, it prints the current date to the screen.

~~~
$ date
~~~
{: .language-bash}
~~~
Mon Nov  5 12:05:58 EST 2018
~~~
{: .output}

<!--**This seems like it might be more confusing than it is worth for beginners**
The command line is powerful enough to allow you to even do programming.
Execute the command below and see the answer.

~~~
[training001@srih0001 ~]$ n=1; while test $n -lt 10000; do echo $n; n=`expr 2 \* $n`; done
~~~
{: .language-bash}
~~~
1
2
4
8
16
32
64
128
256
512
1024
2048
4096
8192
~~~
{: .output}

If you are not getting this output check the command line very carefully. Even small changes could be interpreted by the shell as entirely different commands so you need to be extra careful and gather insight when commands are not doing what you want.
-->

The `echo` and `cat` commands
-----------------------------

The `echo` command is very basic; it returns what you give it back to the terminal, kinda like an echo. Execute the command below.

~~~
$ echo "I am learning UNIX Commands"
~~~
{: .language-bash}
~~~
I am learning UNIX Commands
~~~
{: .output}

This may not seem that useful right now. However, `echo` will also print the
contents of variable to the terminal. There are some default variables set for
each user on the HPCs: `$HOME` is the pathway to the user's "home" directory,
and `$SCRATCH` is Similarly the pathway to the user's "scratch" directory. More
info on what those directories are for later, but for now, we can print them to
the terminal using the `echo` command.

~~~
$ echo $HOME
~~~
{: .language-bash}
~~~
/users/<username>
~~~
{: .output}
~~~
$ echo $SCRATCH
~~~
{: .language-bash}
~~~
/scratch/<username>
~~~
{: .output}


In addition, the shell is able to do basic arithmetical operations, execute
this command:

~~~
$ echo $((23+45*2))
~~~
{: .language-bash}
~~~
113
~~~
{: .output}

Notice that as customary in mathematics products take precedence over
addition. That is called the PEMDAS order of operations, ie
\"Parentheses, Exponents, Multiplication and Division, and Addition and
Subtraction\". Check your understanding of the PEMDAS rule with this
command:

~~~
$ echo $(((1+2**3*(4+5)-7)/2+9))
~~~
{: .language-bash}
~~~
42
~~~
{: .output}

Notice that the exponential operation is expressed with the `**`
operator. The usage of `echo` is important, otherwise, if you execute
the command without `echo` the shell will do the operation and will try
to execute a command called `42` that does not exist on the system. Try
by yourself:

~~~
$ $(((1+2**3*(4+5)-7)/2+9))
~~~
{: .language-bash}
~~~
-bash: 42: command not found
~~~
{: .output}

As you have seen before, when you execute a command on the terminal in
most cases you see the output printed on the screen. The next thing to
learn is how to redirect the output of a command into a file. This will
be very important later to submit jobs and control where and how the
output is produced. Execute the following command:

~~~
$ echo "I am learning UNIX Commands" > report.log
~~~
{: .language-bash}

With the character `>` redirects the output from `echo` into a file
called *report.log*. No output is printed on the screen. If the file
does not exist it will be created. If the file exists previously, the
file is erased and only the new contents are stored. In fact, `>` can be used
to redirect the output of any command to a file!

To check that the file actually contains the line produced by `echo`,
execute:

~~~
$ cat report.log
~~~
{: .language-bash}
~~~
I am learning UNIX Commands
~~~
{: .output}

The cat (concatenate) command displays the contents of one or several
files. In the case of multiple files the files are printed in the order
they are described in the command line, concatenating the output as per the
name of the command.

<!-- **Seems unnecessary**
You can even use a nice trick to write a small text on a file. Execute
the following command, followed by the text that you want to write, at
the end execute `Ctrl-D` (`^D`), the *Control Key* followed by the `D`
key. I am annotating below the location where `^D` should be executed:

~~~
$ cat > report.log
I am learning UNIX Commands^D
$ cat report.log
I am learning UNIX Commands
~~~
{: .language-bash}
-->

In fact, there are hundreds of commands, most of them with a variety of
options that change the behavior of the original command. You can feel
bewildered at first by a large number of existing commands, but in fact
most of the time you will be using a very small number of them.
Learning those will speed up your learning curve.



Folder commands
---------------

As we mentioned before, UNIX organizes data in storage devices as a
tree. The commands `pwd`, `cd` and `mkdir` will allow you to know where
you are, move your location on the tree, and create new folders. Later we
will see how to move folders from one location on the tree to another.

The first command is `pwd`. Just execute the command on the terminal:

~~~
$ pwd
~~~
{: .language-bash}
~~~
/users/<username>
~~~
{: .output}

It is very important at all times to know where in the tree you are.
Doing research usually involves dealing with a large amount of
data, exploring several parameters or physical conditions. Therefore, organizing
the filesystem is absolutely key.


When you log into a cluster, by default you are located on your `$HOME`
folder. That is why the `pwd` command should return that
location in the first instance.

The next command `cd` is used to *change directory*.
A directory is another name for *folder* and is
widely used; in UNIX, the terms are
interchangeable. Other Desktop Operating Systems like Windows and MacOS
have the concept of *smart folders* or *virtual folders*, where the
*folder* that you see on screen has no correlation with a directory in
the filesystem. In those cases the distinction is relevant.

There is another important folder defined in our clusters, its called
the scratch folder and each user has its own. The location of the folder
is stored in the variable `$SCRATCH`. Notice that this is internal
convection and is not observed in other HPC clusters.

Use the next command to go to that folder:

~~~
$ cd $SCRATCH
$ pwd
~~~
{: .language-bash}
~~~
/scratch/<username>
~~~
{: .output}

Notice that the location is different now, if you are using this account
for the first time you will not have files on this folder. It is time to
learn another command to list the contents of a *folder*, execute:

~~~
$ ls
~~~
{: .language-bash}

Assuming that you are using your HPC account for the first time, you
will not have anything in your `$SCRATCH` folder and should therefore see no
output from `ls`. This is a good opportunity to start your filesystem by creating one folder
and moving into it, execute:

~~~
$ mkdir test_folder
$ cd test_folder
~~~
{: .language-bash}

`mkdir` allows you to create folders
in places where you are authorized to do so, such as your `$HOME`
and `$SCRATCH` folders. Try this command:

~~~
$ mkdir /test_folder
~~~
{: .language-bash}
~~~
mkdir: cannot create directory `/test_folder': Permission denied
~~~
{: .output}

There is an important difference between `test_folder` and
`/test_folder`. The former is a location in your current
directory, the later is a location starting on the root directory
`/`. A normal user has no rights to create folders on that directory so
`mkdir` will fail and an error message will be shown on your screen.

Notice that we named it `test_folder` instead of `test folder`. In UNIX, there is no restriction regarding files or
directories with spaces, but using them can become a nuisance on the command
line. If you want to create the folder with spaces from the command
line, here are the options:

~~~
$ mkdir "test folder with spaces"
$ mkdir another\ test\ folder\ with\ spaces
~~~
{: .language-bash}

In any case, you have to type extra characters to prevent the command
line application of considering those spaces as separators for several
arguments in your command. Try executing the following:

~~~
$ mkdir another folder with spaces
$ ls
~~~
{: .language-bash}
~~~
another folder with spaces  folder  spaces  test_folder  test folder with spaces  with
~~~
{: .output}

Maybe is not clear what is happening here. There is an option for `ls`
that present the contents of a directory:

~~~
$ ls -l
~~~
{: .language-bash}
~~~
total 0
drwxr-xr-x 2 myname mygroup 512 Nov  2 15:44 another
drwxr-xr-x 2 myname mygroup 512 Nov  2 15:45 another folder with spaces
drwxr-xr-x 2 myname mygroup 512 Nov  2 15:44 folder
drwxr-xr-x 2 myname mygroup 512 Nov  2 15:44 spaces
drwxr-xr-x 2 myname mygroup 512 Nov  2 15:45 test_folder
drwxr-xr-x 2 myname mygroup 512 Nov  2 15:45 test folder with spaces
drwxr-xr-x 2 myname mygroup 512 Nov  2 15:44 with
~~~
{: .output}

It should be clear, now what happens when the spaces are not contained
in quotes `"test folder with spaces"` or escaped as
`another\ folder\ with\ spaces`. This is the perfect opportunity to
learn how to delete empty folders. Execute:

~~~
$ rmdir another
$ rmdir folder spaces with
~~~
{: .language-bash}

You can delete one or several folders, but all those folders must be
empty. If those folders contain files or more folders, the command will
fail and an error message will be displayed.

After deleting those folders created by mistake, let\'s check the
contents of the current directory. The command `ls -1` will list the
contents of a file one per line, something very convenient for future
scripting:

~~~
$ ls -1
~~~
{: .language-bash}
~~~
total 0
drwxr-xr-x 2 myname mygroup 512 Nov  2 15:45 another folder with spaces
drwxr-xr-x 2 myname mygroup 512 Nov  2 15:45 test_folder
drwxr-xr-x 2 myname mygroup 512 Nov  2 15:45 test folder with spaces
~~~
{: .output}

Commands for copy and move
--------------------------

The next two commands are `cp` and `mv`. They are used to copy or move
files or folders from one location to another. In its simplest usage,
those two commands take two arguments, the first argument is the source
and the last one the destination. In the case of more than two
arguments, the destination must be a directory. The effect will be to
copy or move all the source items into the folder indicated as the
destination.

Before doing a few examples with `cp` and `mv`, let\'s use a very handy
command to create files. The command `touch` is used to update the
access and modification times of a file or folder to the current time.
In case there is not such a file, the command will create a new empty
file. We will use that feature to create some empty files for the
purpose of demonstrating how to use `cp` and `mv`.

Lets create a few files and directories:

~~~
$ mkdir even odd
$ touch f01 f02 f03 f05 f07 f11
~~~
{: .language-bash}

Now, lets copy some of those existing files to complete all the numbers
up to `f11`:

~~~
$ cp f03 f04
$ cp f05 f06
$ cp f07 f08
$ cp f07 f09
$ cp f07 f10
~~~
{: .language-bash}

This is good opportunity to present the `*` *wildcard*, use it to
replace an arbitrary sequence of characters. For instance, execute this
command to list all the files created above:

~~~
$ ls f*
~~~
{: .language-bash}
~~~
f01  f02  f03  f04  f05  f06  f07  f08  f09  f10  f11
~~~
{: .output}

The *wildcard* is able to replace zero or more arbitrary characters, see
for example:

~~~
$ ls f*1
~~~
{: .language-bash}
~~~
f01  f11
~~~
{: .output}

There is another way of representing files or directories that follow a
pattern, execute this command:

~~~
$ ls f0[3,5,7]
~~~
{: .language-bash}
~~~
f03  f05  f07
~~~
{: .output}

The files selected are those whose last character is on the list
`[3,5,7]`. Similarly, a range of characters can be represented. See:

~~~
$ ls f0[3-7]
~~~
{: .language-bash}
~~~
f03  f04  f05  f06  f07
~~~
{: .output}

We will use those special character to move files based on its parity.
Execute:

~~~
$ mv f[0,1][1,3,5,7,9] odd
$ mv f[0,1][0,2,4,6,8] even
~~~
{: .language-bash}

The command above is equivalent to execute the explicit listing of
sources:

~~~
$ mv f01 f03 f05 f07 f09 f11 odd
$ mv f02 f04 f06 f08 f10 even
~~~
{: .language-bash}

Delete files and Folders
------------------------

As we mentioned above, empty folders can be deleted with the command
`rmdir` but that only works if there are no subfolders or files inside
the folder that you want to delete. See for example what happens if you
try to delete the folder called `odd`:

~~~
$ rmdir odd
~~~
{: .language-bash}
~~~
rmdir: failed to remove `odd': Directory not empty
~~~
{: .output}

If you want to delete odd, you can do it in two ways. The command
`rm` allows you to delete one or more files entered as arguments. Let\'s
delete all the files inside odd, followed by the deletion of the folder
`odd` itself:

~~~
$ rm odd/*
$ rmdir odd
~~~
{: .language-bash}

Another option is to delete a folder recursively, this is a powerful but
also dangerous option. Quite unlike Windows/MacOS, recovering deleted files
through a "Trash Can" or "Recycling Bin" does not happen in Linux; deleting
is permanent. Let\'s delete the folder even recursively:

~~~
$ rm -r even
~~~
{: .language-bash}

Summary of Basic Commands
-------------------------

The purpose of this brief tutorial is to familiarize you with the most
common commands used in UNIX environments. We have shown 10 commands
that you will be using, very often on your interaction. This 10 basic
commands and one editor from the next section is all that you need to be
ready for submitting jobs on the cluster.

The next table summarizes those commands.


| Command | Description       | Examples                     |
|---------|:------------------|:-----------------------------|
| `echo`  | Display a given message on the screen | `$ echo "This is a message"` |
|---------|-------------------|------------------------------|
| `cat`   | Display the contents of a file on screen <br> Concatenate files | `$ cat my_file` |
|---------|-------------------|------------------------------|
| `date`  | Shows the current date on screen | `$ date` <br> Wed Nov 7 10:40:05 EST 2018 |
|---------|-------------------|------------------------------|
| `pwd`   | Return the path to the current working directory | `$ pwd` <br> /users/username                  |
|---------|-------------------|------------------------------|
| `cd`    | Change directory  | `$ cd sub_folder`           |
|---------|-------------------|------------------------------|
| `mkdir` | Create directory  | `$ mkdir new_folder`        |
|---------|-------------------|------------------------------|
| `touch` | Change the access and modification time of a file <br> Create empty files     | `$ touch new_file` |
|---------|-------------------|------------------------------|
| `cp`    | Copy a file in another location <br> Copy several files into a destination directory  | `$ cp old_file new_file`  |
|---------|-------------------|------------------------------|
| `mv`    | Move a file in another location <br> Move several files into a destination folder | `$ mv old_name new_name`  |
|---------|-------------------|------------------------------|
| `rm`    | Remove one or more files from the file system tree | `$ rm trash_file` <br> `$ rm -r full_folder`         |
|---------|-------------------|------------------------------|

## Exercise 3

Create two folders called `one` and `two`.
In `one` create the empty file `none1` and in `two` create the empty file `none2`.

Create also in those two folders, files `date1` and `date2` by redirecting the output from the command `date` using `>`.
~~~
$ date > date1
~~~
{: .language-bash}

Check with `cat` that those files contain dates.

Now, create the folders `empty_files` and `dates` and move the corresponding files `none1` and `none2` to `empty_files` and do the same for `date1` and `date2`.

The folders `one` and `two` should be empty now; delete them with `rmdir`
Do the same with folders `empty_files` and `dates` with `rm -r`.


{% include links.md %}
