---
title: "Terminal Multiplexing: tmux"
teaching: 35
exercises: 5
start: 600
questions:
- "What is a Terminal Multiplexer?"
- "How I can use tmux?"
objectives:
- "Learn about Sessions, Windows and Panes"
keypoints:
- "tmux allows you to keep terminal sessions on the cluster that persist in case of network disconnection."
---

## Terminal Emulation

<iframe width="560" height="315" src="https://www.youtube.com/embed/f4TosumXhms" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

During your interaction with a HPC cluster you spend most of your time in front o a terminal. We have been working on a terminal during the previous two episodes. Lets understand a bit better what a terminal is before digging into terminal multiplexing and *tmux* in particular.

What you have on your computer is called a terminal emulator. In the old days of mainframes (70s and 80s) people using computers work on what were called dumb terminals, basically a monitor with a keyboard but not processing power, all the processing was happening on a remote machine, the mainframe.

Today, what you have on your side is a perfectly capable computer, but you are using a terminal emulator and a SSH client to connect to a remote machine that is the head node of the cluster. On windows, you have applications like PuTTy <https://www.chiark.greenend.org.uk/~sgtatham/putty/> that will offer a xterm terminal emulator and the SSH client on the same package. You should realize that the terminal emulator and SSH client are two different applications. In other Operating Systems like Linux and MacOS the difference between the terminal emulator and the SSH client is more clear.

Now, on your computer connect to one of our HPC clusters using SSH, you notice that your prompt, the string that indicate that is ready to receive commands is showing the name of the head node on our clusters. Imagine that you are editing a text file using any of the 3 editors from our previous episode. If for some reason the internet connection fails, the program that you were using will be closed, some editors give you some recovery protection but in any case you need to connect again, change working directory and other operations before opening the file and continue your work.

Another limitation of traditional terminals is that you have just one place to enter commands, working with HPC clusters usually involves working with several jobs and projects and you would like to write and submit new jobs, check the status of those jobs that you already submitted and reading the output from the jobs that have finished. You could open more SSH sessions but the chances of those sessions fail to to network issues and managing those extra windows limit your ability to work effectively on the cluster.

The solutions for the two problems above is using a Terminal Multiplexer, a program that runs on the head node and it is detached from your local terminal session. *tmux* is such terminal multiplexer, with the ability to create multiple emulated terminals.

In this episode we will show you how to create *tmux* sessions on the cluster and  see the effect of detaching and reattaching to the session. Next we will see the four basic concepts in *tmux*: Clients, Sessions, Windows and Panes. We will see how to create and move between them and finally a few tricks on how to personalize your experience on *tmux*. As you progress on the use of the cluster *tmux* will become an important companion for your interaction with the HPC clusters.

*tmux* lets you switch easily between several virtual terminals organized in sessions, windows and panes. One big advantage of terminal multiplexing is that all those virtual terminals remain alive when you logout from the system.
You can work for a while remotely, close the connection and reconnect again, attaching your tmux session and continuing exactly where you left your work.

## Opening a *tmux* Session and Client

The first concepts in *tmux* are client and session. A *tmux* session is made of at least one window that holds at least one pane. We will see about windows and panes later in this episode but right now lets see how to work with *tmux* sessions.

First connect to the cluster using your terminal emulator and SSH client.
Once you are connected to the head node of the cluster execute:

~~~
tmux
~~~
{: .language-bash}

If for some reason you lost the connection to the server or you detached from the multiplexer all that you have to do to reconnect is to execute the command:

~~~
tmux a
~~~
{: .language-bash}


You will see something new here, a green bar on the bottom of your screen. That is the indication that you are inside a *tmux* session. The *tmux* status line at the bottom of the screen shows information on the current session. At this point you have created one *tmux* client that is attached to the session that was also created. Clients and Sessions are separate entities allowing you to detach your client from the session and reattach it later. You can also have several clients attached to the same session and whatever you do on one will be visible on the others. At first sessions and client could be confused but this exercise will help you understand the concepts.

You are now on a *tmux* session. Open *nano* so you can see the top bar and the two command bars on the bottom from the nano session. Write a line, like you were writing a text file. All commands inside a session uses a prefix key combination. The prefix combination is <kbd>Ctrl</kbd>+<kbd>B</kbd> also referred as **C-b**.
You have to press the <kbd>Ctrl</kbd> key, keep it pressed and press the <kbd>B</kbd> key followed for any command for *tmux* to interpret. The first command will detach a session from the client. Use the combination **C-b d** to detach the current session from the client. You will hit the <kbd>Ctrl</kbd> key, keep it press and press <kbd>B</kbd>, raise both keys and press <kbd>D</kbd>. You will see that the nano top and bottom bars disappear, the green *tmux* bottom bar also disappears and you return to your normal terminal. You can go even further and close your terminal on your computer to simulate a loss in internet connection. Reconnect again to the cluster using SSH to return to the head node.

From the head node we will reattach the session using:

~~~
$ tmux a
~~~
{: .language-bash}

You will see your session recovering exactly the same as you left when you detached and nano should be there with the line that you wrote.
You have created your first *tmux* session and that session will persist until you kill the session or the head node is rebooted, something that happens
rarely, usually one or two times per year. For most part you can keep your *tmux* session open

You can create several *tmux* sessions each one with a given name using:

~~~
$ tmux new -s <session_name>
~~~
{: .language-bash}

Having several sessions is useful if you want a distinctive collections of windows for different projects as they are more isolated than windows on the same session. Changing between sessions is done with **C-b (** and **C-b )** to move between the previous and next session. Another way of moving between sessions is using **C-b w** as we will see next, showing all the windows across all sessions and allowing you to jump into windows from different sessions.

Sessions have names and those names can be changed with **C-b $**

## Windows and Panes

The next concepts on *tmux* are windows and panes. A *tmux* window is the area that fills the entire  space offered by your local terminal emulator.
Windows have the same purpose that *tabs* on a browser.
When you create your first *tmux* session, you also create a single window. *tmux* windows can be further divided in what *tmux* calls panes. You can divide a single *tmux* window in multiple panes and you can have several *tmux* windows on a single *tmux* session. As we will see in a moment, you can have several *tmux* sessions, attached to *tmux* clients or detached from them. Each session can hold several *tmux* windows and each window will have one or more *tmux* panes. On each of those panes you will have a shell waiting for your commands. At the end *tmux* is the equivalent of a window manager in the world of terminals with the ability to attach and detach at will and running commands concurrently.

In case you are not already attached to the *tmux* session, enter into the *tmux* session with:

~~~
$ tmux a
~~~
{: .language-bash}

You have one window with one pane inside that fills the entire space.
You can create new *tmux* windows with **C-b c**. Start creating a few of them.
Each new window will appears in the bottom *tmux* bar. The first 10 are identified with a number from a digit number from 0 to 9.

Moving between windows is done using the number associated on the bottom bar of *tmux*, to move to the first window (with number 0) use **C-b 0**, similarly for all the first 10 windows. You can create more windows beyond the first 10 but only for those you can jump into them using the **C-b <WIN no>** combination. Another way of moving between the previous and next window. Use
**C-b p** and **C-b n** for the previous and next respectively. You can change the number of a window using **C-b .**

Notice that windows receive names shown on the bottom bar in *tmux*. You can change the name of the window using **C-b ,**. This is useful to generate windows with consistent names for the task or project related to the window.
You can also use the different windows connected to different machines so the label could be useful to identify which machine you are connected at a given window.

You can kill the current window with **C-b &** and see all the windows across all sessions with **C-b w**. This is another way of moving between windows in different sessions.

The last division in the hierarchy are panes. Panes create new terminals by diving the window horizontally or vertically. You can create new panes using
**C-b %** for vertical division or **C-b "** for horizontal division.

You can move between panes with **C-b o** or using the arrows to go to the panes on the direction of the arrow such as **C-b <LEFT ARROW>**

One easy way of organizing the panes is using the predefined layouts and **C-b SPACE** will cycle between them. Panes can be swapped with **C-b {** and **C-b }**. You can zoom into the current pane to take the whole window using **C-b z** and executing the same command to return to the previous layout.

## Copy mode

All the commands above are related to movement and creation of sessions, windows and panes. Inside a pane, you can enter in Copy mode in case you want to scroll the lines on the pane or you want to copy and paste lines.
The procedure to use copy mode is as follows:


  1. Press **C-b [** to enter in copy mode.

  2. Move to start/end of text to highlight.

  3. Press **C-SPACEBAR** to start selection

    Start highlighting text. Selected text changes the color and background, so you'll know if the command worked.

  4. Move to opposite end of text to copy.

  5. Press **ALT-w** to copy selected text into *tmux* clipboard.

  6. Move cursor to opposite *tmux* pane, or completely different *tmux* window. Put the cursor where you want to paste the text you just copied.

  7. Press **C-b ]** to paste copied text from *tmux* clipboard.

If you are working from a Mac, the ALT key (In Mac called *option*) will not work. One alternative is to use vi-copy mode:

  1. Press **C-b :** and write: **setw -g mode-keys vi**

  2. Now enter in copy  mode with **C-b [**

  3. To start selecting the text use **SPACEBAR**

  4. Move to the opposite end of text to copy

  5. Copy the selection with **ENTER**

  6. Go to the window and pane you want to paste

  7. Press **C-b ]** to paste copied text from *tmux* clipboard.

## Final remarks

**tmux** is far more than the few commands shown here. There are many ways to personalize the environment. Some personalizations involve edit the file
$HOME/.tmux.conf

Consider for example this **.tmux.conf** that changes several colors in the *tmux* status bar.

~~~
######################
### DESIGN CHANGES ###
######################

# loud or quiet?
set -g visual-activity off
set -g visual-bell off
set -g visual-silence off
setw -g monitor-activity off
set -g bell-action none

#  modes
setw -g clock-mode-colour colour5
setw -g mode-style 'fg=colour1 bg=colour18 bold'

# panes
set -g pane-border-style 'fg=colour19 bg=colour0'
set -g pane-active-border-style 'bg=colour0 fg=colour9'

# statusbar
set -g status-position bottom
set -g status-justify left
set -g status-style 'bg=colour18 fg=colour137 dim'
set -g status-left ''
set -g status-right '#[fg=colour233,bg=colour19] %d/%m #[fg=colour233,bg=colour8] %H:%M:%S '
set -g status-right-length 50
set -g status-left-length 20

setw -g window-status-current-style 'fg=colour1 bg=colour19 bold'
setw -g window-status-current-format ' #I#[fg=colour249]:#[fg=colour255]#W#[fg=colour249]#F '

setw -g window-status-style 'fg=colour9 bg=colour18'
setw -g window-status-format ' #I#[fg=colour237]:#[fg=colour250]#W#[fg=colour244]#F '

setw -g window-status-bell-style 'fg=colour255 bg=colour1 bold'

# messages
set -g message-style 'fg=colour232 bg=colour16 bold'
~~~
{: .language-bash}

There is a lot of things that can be changed to everyones taste. There are several **.tmux.conf** files shared on github and other repositories that customize tmux in several ways.

> ## Exercise: TMUX Sessions, Windows and Panes
>
> This exercise will help you familiarize with the 3 concepts in TMUX.
>
>   1. Create 3 sessions on TMUX, give each of them different names, either creating the session with the name or using **C-b $** to rename session names.
>
>   2. In one of those sessions create 2 windows and on the other create 3 windows. Move between sessions to accomplish this.
>
>   3. In one of those windows, split the window vertically, on another horizontally and on the third one create 3 panes and cycle between the different layouts using **C-b SPACE**
>
>   4. Detach or close your terminal and reconnect, attach your sessions and verify that your windows and panes remain the same.
>
>{: .source}
{: .challenge}

> ## Exercise: Using tmux
>
> Using the tables above follow this simple challenge with tmux
>
> 1. Log in to Thorny Flat and create a tmux session
>
> 2. Inside the session create a new window
>
> 3. Go back to window 0 and create a horizontal pane and inside on of those panes create a vertical pane.
>
> 4. Create a big clock pane
>
> 5. Detach from your current session, close your terminal and reconnect.
> Log in again on Thorny Flat and reattach your session.
>
> 6. Now that you are again in you original session, create a new session.
> You will be automatically redirected there. Leave your session, check the list of sessions.
>
> 7. Kill the second session (session ID is 1)
>
>{: .source}
{: .challenge}


## Reference of *tmux* commands

In tmux, by default the prefix is <kbd>Ctrl</kbd>+<kbd>b</kbd>.
Use the prefix followed by one of the options below:

### Sessions
~~~
    :new<CR>  new session
    s  list sessions
    $  name session
~~~
{: .source}

### Windows (tabs)

~~~
    c  create window
    w  list windows
    n  next window
    p  previous window
    f  find window
    ,  name window
    &  kill window
~~~
{: .source}

### Panes (splits)

~~~
    %  vertical split
    "  horizontal split
    o  swap panes
    q  show pane numbers
    x  kill pane
    +  break pane into window (e.g. to select text by mouse to copy)
    -  restore pane from window
    ⍽  space - toggle between layouts
    q (Show pane numbers, when the numbers show up type the key to goto that pane)
    { (Move the current pane left)
    } (Move the current pane right)
    z toggle pane zoom
~~~
{: .source}

### Copy model

~~~
    [  Copy mode
~~~
{: .source}

In copy mode use this commands to copy a region to the *tmux* clipboard.

~~~
    Ctrl SPACE  Start Selection
    Alt w       Copy the selection to the clipboard
~~~
{: .source}

After this use the command to paste

~~~
    ]  Paste from clipboard
~~~
{: .source}

### Others

~~~
    d  detach
    t  big clock
    ?  list shortcuts
    :  prompt
~~~
{: .source}

### Command line arguments for tmux

~~~
    tmux ls                       list sessions
    tmux new                      new session
    tmux rename -t <ID> new_name  rename a session
    tmux kill-session -t <ID>     kill session by target
~~~
{: .source}

{% include links.md %}
