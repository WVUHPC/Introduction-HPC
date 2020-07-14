---
title: "Terminal-based Editors"
teaching: 30
exercises: 30
questions:
- "How do I edit files with the terminal?"
objectives:
- "First learning objective. (FIXME)"
keypoints:
- "First key point. Brief Answer to questions. (FIXME)"
---

## Terminal-based Text Editors

There are several terminal-based editors available on our clusters. We
will focus our attention on three of them: **nano**, **emacs**, and **vim**. Your
choice of an editor depends mostly on how much functionality do you want
from your editor, how many fingers do you want to use for a given
command, and the learning curve to master it. Most of your time you are on the terminal executing
commands or editing files, being those input files, submission scripts
or the output of your calculations.

Let\'s review those three editors to give you the opportunity to have an
informed choice.

### Nano

Nano is a small, free and friendly editor with commands that are generally
accessed by using Control (CTRL) combined with some other key.

You can start editing a file using a command line like this:

~~~
$ nano myfile.f90
~~~
{: .language-bash}

You will notice that you cannot move around the text file with your mouse but instead must use the keyboard.
There are several commands available, and the list below comes from the help
text. When you see the symbol \"\^\", it means to press the Control
(CTRL) key; the symbol \"M-\" is called Meta, but in most keyboards is
identified with the (Alt) key.

    ^G  (F1)            Display this help text
    ^X  (F2)            Close the current file buffer / Exit from nano
    ^O  (F3)            Write the current file to disk
    ^J  (F4)            Justify the current paragraph

    ^R  (F5)            Insert another file into the current one
    ^W  (F6)            Search for a string or a regular expression
    ^Y  (F7)            Move to the previous screen
    ^V  (F8)            Move to the next screen

    ^K  (F9)            Cut the current line and store it in the cutbuffer
    ^U  (F10)           Uncut from the cutbuffer into the current line
    ^C  (F11)           Display the position of the cursor
    ^T  (F12)           Invoke the spell checker, if available

    ^_  (F13)   (M-G)   Go to line and column number
    ^\  (F14)   (M-R)   Replace a string or a regular expression
    ^^  (F15)   (M-A)   Mark text at the cursor position
            (F16)   (M-W)   Repeat last search

    M-^             (M-6)   Copy the current line and store it in the cutbuffer
    M-}                     Indent the current line
    M-{                     Unindent the current line

    ^F                      Move forward one character
    ^B                      Move back one character
    ^Space                  Move forward one word
    M-Space                 Move back one word
    ^P                      Move to the previous line
    ^N                      Move to the next line

<!--
    ^A                      Move to the beginning of the current line
    ^E                      Move to the end of the current line
    M-(             (M-9)   Move to the beginning of the current paragraph
    M-)             (M-0)   Move to the end of the current paragraph
    M-\             (M-|)   Move to the first line of the file
    M-/             (M-?)   Move to the last line of the file

    M-]                     Move to the matching bracket
    M--             (M-\_)   Scroll up one line without scrolling the cursor
    M-+             (M-=)   Scroll down one line without scrolling the cursor

    M-<             (M-,)   Switch to the previous file buffer
    M->             (M-.)   Switch to the next file buffer

    M-V                     Insert the next keystroke verbatim
    ^I                      Insert a tab at the cursor position
    ^M                      Insert a newline at the cursor position
    ^D                      Delete the character under the cursor
    ^H                      Delete the character to the left of the cursor
    M-T                     Cut from the cursor position to the end of the file

    M-J                     Justify /_staticthe entire file
    M-D                     Count the number of words, lines, and characters
    ^L                      Refresh (redraw) the current screen

    M-X                     Help mode enable/disable
    M-C                     Constant cursor position display enable/disable
    M-O                     Use of one more line for editing enable/disable
    M-S                     Smooth scrolling enable/disable
    M-P                     Whitespace display enable/disable
    M-Y                     Color syntax highlighting enable/disable

    M-H                     Smart home key enable/disable
    M-I                     Auto indent enable/disable
    M-K                     Cut to end enable/disable
    M-L                     Long line wrapping enable/disable
    M-Q                     Conversion of typed tabs to spaces enable/disable

    M-B                     Backup files enable/disable
    M-F                     Multiple file buffers enable/disable
    M-M                     Mouse support enable/disable
    M-N                     No conversion from DOS/Mac format enable/disable
    M-Z                     Suspension enable/disable
-->

The most basic usage is to edit a file, and exit from the editor with
CTRL-X. Nano ask you if you want to save the file, you answer \"Y\" and
offers you a name. Simply press ENTER and your file is saved.

### Emacs

Emacs is an extensible, customizable, open-source text editor. Together
with Vi/Vim is one the most widely used editors in Linux environments.
There are a big number of commands, customization and extra modules
that can be integrated with Emacs. We will just briefly cover the
basics.

~~~
$ emacs -nw data.txt
~~~
{: .language-bash}

The number of commands for Emacs is large, here the basic list of
commands for editing, moving and searching text.

The best way of learning is keeping at hand a sheet of paper with the commands
For example [GNU Emacs Reference Card](https://www.gnu.org/software/emacs/refcards/pdf/refcard.pdf) can show you most commands that you need.

<!---
Below you can see the same 2 page Reference Card as individual images.

<a href="{{ page.root }}/fig/refcard-0.png">
  <img src="{{ page.root }}/fig/refcard-0.png" alt="Emacs Ref Card" />
</a>

<a href="{{ page.root }}/fig/refcard-1.png">
  <img src="{{ page.root }}/fig/refcard-1.png" alt="Emacs Ref Card" />
</a>
--->

### Vi/Vim

The third editor widely supported on Linux systems is \"vi\". Over the
years since its creation, vi became the \*de-facto\* standard Unix
editor. The Single UNIX Specification specifies vi, so every conforming
system must have it.

~~~
$ vi code.py
~~~
{: .language-bash }

vi is a modal editor: it operates in either insert mode (where typed
text becomes part of the document) or normal mode (where keystrokes are
interpreted as commands that control the edit session). For example,
typing i while in normal mode switches the editor to insert mode, but
typing i again at this point places an \"i\" character in the document.
From insert mode, pressing ESC switches the editor back to normal mode.

A very beautiful Reference Card for vim can be found here: [Vim CheatSheet](http://vimcheatsheet.com/)

<!--
<a href="https://external-preview.redd.it/iigrixvxp5aYN9ox7Gr1dfI_rhLRotWlLsCafjJqjEQ.png?auto=webp&s=1594ddc17408cb9186a73c2a6d1a1bf1e00769dd">
  <img src="https://external-preview.redd.it/iigrixvxp5aYN9ox7Gr1dfI_rhLRotWlLsCafjJqjEQ.png?auto=webp&s=1594ddc17408cb9186a73c2a6d1a1bf1e00769dd" alt="Vim Ref Card" />
</a>
-->

## Exercise

Select an editor. The challenge is write this code in a file called `Sierpinski.c`

~~~
#include <stdio.h>

#define SIZE (1 << 5)
int main()
{
    int x, y, i;
    for (y = SIZE - 1; y >= 0; y--, putchar('\n')) {
        for (i = 0; i < y; i++) putchar(' ');
        for (x = 0; x + y < SIZE; x++)
            printf((x & y) ? "  " : "* ");
    }
    return 0;
}

~~~
{: .source}

Here is the challenge. **You cannot use the arrow keys**. Not a single time!
It is pretty hard if you are not used to it, but it is a good exercise to learn the commands.

Another interesting challenge is to write the line `for (y = SIZE - 1; y >= 0; y--, putchar('\n'))` and copy and paste it to form the other 2 *for loops* in the code, and editing only after being copied.

Once you have successfully written the source code, you can see your hard work in action.

On the terminal screen, execute this:

~~~
$ gcc Sierpinski.c -o Sierpinski
~~~
{: .language-bash}

This will compile your source code `Sierpinski.c` in C into a binary executable called `Sierpinski`. Execute the code with:

~~~
$ ./Sierpinski
~~~
{: .language-bash}

The resulting output is kind of a surprise so I will not post it here.
The original code comes from [rosettacode.org](http://www.rosettacode.org/wiki/Sierpinski_triangle#C)


> ## Why vi was programmed to not use the arrow keys?
>
>From [Wikipedia](https://en.wikipedia.org/wiki/Vi) with a anecdotal story from [The register](https://www.theregister.co.uk/2003/09/11/bill_joys_greatest_gift/)
>
> Joy used a Lear Siegler ADM-3A terminal. On this terminal, the Escape key was at the location now occupied by the Tab key on the widely used IBM PC keyboard (on the left side of the alphabetic part of the keyboard, one row above the middle row). This made it a convenient choice for switching vi modes. Also, the keys h,j,k,l served double duty as cursor movement keys and were inscribed with arrows, which is why vi uses them in that way. The ADM-3A had no other cursor keys. Joy explained that the terse, single character commands and the ability to type ahead of the display were a result of the slow 300 baud modem he used when developing the software and that he wanted to be productive when the screen was painting slower than he could think.
>
>
> <a title="No machine-readable author provided. StuartBrady assumed (based on copyright claims). [CC BY-SA 3.0 (http://creativecommons.org/licenses/by-sa/3.0/)], via Wikimedia Commons" href="https://commons.wikimedia.org/wiki/File:KB_Terminal_ADM3A.svg"><img width="512" alt="KB Terminal ADM3A" src="https://upload.wikimedia.org/wikipedia/commons/thumb/a/a0/KB_Terminal_ADM3A.svg/512px-KB_Terminal_ADM3A.svg.png"></a>
>
>
{: .testimonial}

{% include links.md %}
