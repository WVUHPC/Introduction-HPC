---
title: Setup
---

## Accessing the clusters using Secure shell (SSH)

The most common way of accessing a High-Performance Computing (HPC) cluster is via a remote shell.
A remote shell allows you to execute commands on another machine same as you do sitting in front of it. A remote shell is convenient because it also allows other people to do the same, so you get access to a resource being utilized by several users at the same time.

All that you need on your computer is a terminal emulator and an SSH client.
A terminal emulator is a program that mimics the behavior of old dumb terminals from a few decades ago. An SSH client is a program on your computer that allows you to connect to the SSH server from another computer. In the old times (the 80s), people used to create a remote shell using Telnet. SSH provides a secure channel over an unsecured network such as the internet. SSH offers similar capabilities to Telnet but adding encryption, so all data sent and received between your computer and the remote host is encrypted in such a way that only your computer and the remote computer can see the data. If you want to know more about Secure Shell see it at [Wikipedia](https://en.wikipedia.org/wiki/Secure_Shell). Currently (2021) WVU has two clusters for HPC, Spruce Knob and Thorny Flat. You can access them using SSH.

Regardless of which Operating System you use, there is always a way of having the terminal emulator and SSH client that you need to connect to an HPC cluster.
Both Linux and macOS include an SSH client by default. In this case, all that you have to do is open a terminal. On macOS the terminal is located in the *Utilities* folder inside your *Applications* folder. On Linux, the terminal is so central that most Linux distributions create an icon directly from the desktop.

On Windows machines, you need to install an external application. One option in Windows is a free application called [PuTTY](https://www.putty.org). PuTTY offers a simple SSH client that is enough for this lesson. Another option is [MobaXTerm](https://mobaxterm.mobatek.net) that offers a full-featured SSH client plus the ability to open X11 windows from the remote machine.

 <a href="{{ page.root }}/fig/PuTTY.png">
   <img src="{{ page.root }}/fig/PuTTY.png" alt="PuTTY" />
 </a>

 <a href="{{ page.root }}/fig/MobaXterm.png">
   <img src="{{ page.root }}/fig/MobaXterm.png" alt="MobaXterm" />
 </a>

More recently there are also options to get access to a terminal and SSH clients using Microsoft products. One option is to install [Visual Studio Code](https://code.visualstudio.com).
Instructions to add an SSH client to VSC can be found [here](https://code.visualstudio.com/docs/remote/ssh) and [here](https://code.visualstudio.com/learn/develop-cloud/ssh-lab-machines). Visual Studio Code will give you not only access to remote access to a file manager.

Another alternative is using the Windows Subsystem for Linux (WSL). WSL will allow you to run a full Linux OS inside Windows with all the commands that you will encounter on a typical Linux machine. With the latest version of WSL 2 and the development version of Windows 10, you can even run GUI applications from inside Windows alongside other Windows applications. You can see the files from your windows machine. Running and complete Linux OS inside Windows will give you access not only to SSH client and terminal but also the commands that you will learn during this lesson as you will do from a Native Linux machine. Instructions about installing and configuring WSL can be found [here](https://docs.microsoft.com/en-us/windows/wsl/)

### Connecting to Spruce Knob

Most likely you will connect to Thorny Flat, our newest cluster. However, it is also good to know how to connect to Spruce, our older cluster. Accounts on those clusters are independent of each other, so you can have access to one without necessarily having an account on the other.

To access Spruce from your computer, execute this command from your terminal (Linux, macOS):

~~~
ssh <username>@spruce.hpc.wvu.edu
~~~
{: .language-bash}

If you are using a GUI client such as PuTTY enter ``spruce.hpc.wvu.edu`` as the name of the server and your username in the corresponding field before connecting to the remote machine.

[//]: # (If you received one of the training accounts, this is the machine where you will connect. For example if your username is `training999`, connect to Spruce using:)

~~~
ssh training999@spruce.hpc.wvu.edu
~~~
{: .language-bash}


After entering your credentials with DUO, you get a prompt on Spruce

### Connecting to Thorny Flat

On Thorny Flat, you cannot connect to the front end directly.
First, use your SSH client to connect to ``ssh.wvu.edu`` like this::

~~~
ssh <username>@ssh.wvu.edu
~~~
{: .language-bash}

Enter your DUO authentication and execute this command on the Gateway node.

~~~
ssh <username>@thorny.hpc.wvu.edu
~~~
{: .language-bash}


Once you enter the system, you can start typing commands. You can open several connections simultaneously. Each connection is independent of the other and you have to authenticate on each new terminal.

> ## Login on Thorny or Spruce
>
> Using the username and password given to you for this training or using your account login into Spruce or Thorny and execute the command `hostname`.
>
> What do you see on the terminal?
>
>> ## Solution
>>  You should get the name of the head node:
>>
>>  On Spruce Knob the head node is **srih0001.hpc.wvu.edu**
>>
>>  On Thorny Flat the head node is **trcis001.hpc.wvu.edu**
> {: .solution}
{: .challenge}

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


### Native terminals in various Operating Systems

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

    <h5>Usually the terminal is already a button on your desktop. The icon is commonly depicted as monitor with a black screen </h5>

    </p>
    </blockquote>
    </article>
  </div>
</div>
</div>


## Downloading the materials

The materials of examples and exercises can be downloaded by executing this command on the terminal.

~~~
git clone https://github.com/WVUHPC/workshops_hands-on.git
~~~
{: .language-bash}

This command will download all the files used in our workshops into a folder called
`workshops_hands-on`. You can move into the particular folder for this workshop using the command.

~~~
cd workshops_hands-on/Introduction_HPC
~~~
{: .language-bash}

If are not familiar with these commands, do not worry, you are actually in the right class.
These and many other commands will be the topic of the material that follows.


{% include links.md %}
