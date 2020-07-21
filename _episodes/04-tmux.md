---
title: "Terminal Multiplexing: tmux"
teaching: 30
exercises: 30
questions:
- "What is a Terminal Multiplexer?"
- "How I can use tmux?"
objectives:
- "Learn about Sessions, Windows and Panes"
keypoints:
- "tmux allows you to keep terminal sessions on the cluster that persist in case of network disconnection."
---

## Terminal Emulation

During your interaction with a HPC cluster you spend most of your time in front o a terminal. We have been working on a terminal during the previous two episodes. Lets understand a bit better what a terminal is before digging into terminal multiplexing and *tmux* in particular.

What you have on your computer is called a terminal emulator. In the old days of mainframes (70s and 80s) people using computers work on what were called dumb terminals, basically a monitor with a keyboard but not processing power, all the processing was happening on a remote machine, the mainframe.

Today, what you have on your side is a perfectly capable computer, but you are using a terminal emulator and a SSH client to connect to a remote machine that is the head node of the cluster. On windows, you have applications like PuTTy <https://www.chiark.greenend.org.uk/~sgtatham/putty/> that will offer a xterm terminal emulator and the SSH client on the same package. That is convenient but it good to realize that terminal emulation and SSH are two different applications. In other Operating Systems like Linux and MacOS the difference between the terminal emulator and the SSH client is more clear.

Now, on your computer connect to one of our HPC clusters using SSH, you notice that your prompt, the string that indicate that is ready to receive commands is showing the name of the head node on our clusters. Imagine that you are editing a text file using any of the 3 editors from our previous episode. If for some reason the internet connection fails, the program that you were using will be closed, some editors give you some recovery protection but in any case you need to connect again, change working directory and other operations before opening the file and continue your work.

Another limitation of traditional terminals is that you have just one place to enter commands, working with HPC clusters usually involves working with several jobs and projects and you would like to write and submit new jobs, check the status of those jobs that you already submitted and reading the output from the jobs that have finished. You could open more SSH sessions but the chances of those sessions fail to to network issues and managing those extra windows limit your ability to work effectively on the cluster.

The solutions for the two problems above is using a Terminal Multiplexer, a program that runs on the head node and it is detached from your local terminal session. *tmux* is such terminal multiplexer, with the ability to create multiple emulated terminals.

In this episode we will show you how to create *tmux* sessions on the cluster and  see the effect of detaching and reattaching to the session. Next we will see the four basic concepts in *tmux*: Clients, Sessions, Windows and Panes. We will see how to create and move between them and finally a few tricks on how to personalize your experience on *tmux*. As you progress on the use of the cluster *tmux* will become an important companion for your interaction with the HPC clusters.

## Opening a *tmux* Session and Client

The first concepts in *tmux* are client and session. A *tmux* session is made of at least one window that holds at least one pane. We will see about windows and panes later in this episode but right now lets see how to work with *tmux* sessions.

First connect to the cluster using your terminal emulator and SSH client.
Once you are connected to the head node of the cluster execute:

~~~
$ tmux
~~~
{: .language-bash}

You will see something new here, a green bar on the bottom of your screen. That is the indication that you are inside a *tmux* session. The *tmux* status line at the bottom of the screen shows information on the current session. At this point you have created one *tmux* client that is attached to the session that was also created. Clients and Sessions are separate entities allowing you to detach your client from the session and reattach it later. You can also have several clients attached to the same session and whatever you do on one will be visible on the others. At first sessions and client could be confused but this exercise will help you understand the concepts.

You are now on a *tmux* session. Open *nano* so you can see the top bar and the two command bars on the bottom from the nano session. Write a line, like you were writing a text file. All commands inside a session uses a prefix key combination. The prefix combination is **CTRL-b** also referred as **C-b**.
You have to press the **CONTROL** key, keep it pressed and press the **b** key followed for any command for *tmux* to interpret. The first command will detach a session from the client. Use the combination **C-b d** to detach the current session from the client. You will hit the **CONTROL** key, keep it press and press **b**, raise both keys and press **d**. You will see that the nano top and bottom bars dissapear, the green *tmux* bottom bar also dissapears and you return to your normal terminal. You can go even further and close your terminal on your computer to simulate a loss in internet connection. Reconnect again to the cluster using SSH to return to the head node.

From the head node we will reattach the session using:

~~~
$ tmux a
~~~
{: .language-bash}

You will see your session recovering exactly the same as you left when you detached and nano should be there with the line that you wrote.
You have created your first tmux session and that session will persist until you kill the session or the head node is rebooted, something that happens
rarely, usually one or two times per year. For most part you can keep your tmux session open

## Windows and Panes

The next concepts on *tmux* are windows and panes. A *tmux* window is a space that fills the entire space offered by your local terminal emulator. When you create your first *tmux* session, you also create a single window. *tmux* windows can be further divided in what *tmux* calls panes. You can divide a single *tmux* window in multiple panes and you can have several *tmux* windows on a single *tmux* session. As we will see in a moment, you can have several *tmux* sessions, attached to *tmux* clients or detached from them. Each session can hold several *tmux* windows and each window will have one or more *tmux* panes. On each of those panes you will have a shell waiting for your commands. At the end *tmux* is the equivalent of a window manager in the world of terminals with the ability to attach and detach at will and running commands concurrently.

Lets focus on windows and panes. In case you are not already attached to the *tmux* session, enter into the *tmux* session with:

~~~
$ tmux a
~~~
{: .language-bash}

You have one window with one pane inside that fills the entire space.
You can create new *tmux* windows with **C-b c**. Start creating a few of them.
Each new window will appears in the bottom *tmux* bar. The first 10 are identified with a number from a digit number from 0 to 9. 




{% include links.md %}
