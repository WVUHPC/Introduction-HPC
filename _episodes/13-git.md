---
title: "Version Control: git"
teaching: 50
exercises: 10
questions:
- "How to keep track of changes in text files?"
objectives:
- "Learn the basic commands of git to version control text files"
objectives:
- "First learning objective. (FIXME)"
keypoints:
- "Version control systems were created to keep track of changes in a set of files."
- "They work better with text files"
---

# Version Control with Git

A version control system is a tool that keeps track of changes in a folder and all the files there in. That works by effectively creating different versions of your files. It allows you to decide which changes will be made to the next version (each record of these changes is called a commit), and keeps useful metadata about them. The complete history of commits for a particular project and their metadata make up a repository. Repositories can be kept in sync across different computers, facilitating collaboration among different people.

In scientific computing there are 3 typical scenarios where using a Version Control system is crucial in your effectiveness as researcher.

1. You write code, scripts and sometimes even data and you need to keep track on the changes on that code in case you need to go back and review for example, why a previous version was producing better results!.

2. You are writing a paper: Your paper will go into a spiral of reviews, by you, your collaborators, you PhD advisor,  the referees. If you are using LateX for you paper, as you probably should do, it is easy to keep track of changes and keep your paper in sync across several computers.

3. You are writing your Thesis, same principle, your manuscript will have several cycles of review and corrections. You do not want to keep all your precious PhD Thesis on a single place and you do not want to get lost figuring out which version is the last version!.

Version control systems can help you with this, they are designed to keep track of changes on files, in particular text files. Even if they work also for binary files like figures and plots, adding too many figures, photos or other media could make the repository grow quickly.

We will go quickly to cover the basics of Version control using git, there is a complete lesson on Git on Software Carpentry [Version Control with Git](http://swcarpentry.github.io/git-novice/), consider to follow the lesson for a more detailed coverage about what git can do for you.

For the purpose of this hands-on, we will create and work entirely on an local repository. You can otherwise create an account on Github and get the ability to create public repositories for free or private repositories for a fee. WVU Research Computing offers to researchers private repositories for free via an special agreement with Github.

## Exercise 1 (Create an empty repository)

In this exercise you will create an empty repository from the command line.
Before that, there are a few commands to prepare your environment for using with Github:

~~~
git config --global user.name "<Your Full Name>"
git config --global user.email "<username>@mix.wvu.edu"
~~~
{: .language-bash}

The default editor for commits is `vim` and for the purpose of this introduction we will keep it like that.

Now, lets create a folder `project_01` that we will convert into a git repository so Git can store versions of our files.
Move inside the folder (`cd project_01`) and execute:

~~~
$ git init
~~~
{: .language-bash}

If we use `ls` to show the directory's contents you will see no new file apparently.

~~~
$ ls
~~~
{: .language-bash}

But if we add the `-a` flag to show hidden files and folders,
we can see that Git has created a hidden folder within `project_01` called `.git`:

~~~
$ ls -a
~~~
{: .language-bash}

~~~
.	..	.git
~~~
{: .output}

Git uses this special sub-directory to store all the information about the project,
including all files and sub-directories located within the project's directory.
If we ever delete the `.git` sub-directory, we will lose the project's history.
That folder is hidden for a good reason, in almost all circumstances, you are not suppose to manipulate the contents of the `.git` folder directly.

We can check that everything is set up correctly by asking Git to tell us the status of our project:

~~~
$ git status
~~~
{: .language-bash}
~~~
# On branch master
#
# Initial commit
#
nothing to commit (create/copy files and use "git add" to track)
~~~
{: .output}

We have now a repository, an empty one, lets start by adding some basic structure to it. Lets suppose that the project will include: the scripts that you use to create or manipulate the data, a curated set of data, the plots and the manuscript of your paper.

It is not a good idea to store the raw data, raw data is probably too big, we just need the data that will be actually used to create the plots.

 A git repository is not indented to be a file backup. What we should keep in the repository is the code and text that allows to recreate the results from the raw data, if the raw data is lost (something that should never happen if you
 backup your data), you can reconstruct the results, by running all simulations again, using your scripts, producing equivalent plots and recreating your paper for submission.

## Exercise 2 (Adding files to the repository)

 Lets create the structure for `project_01`

 ~~~
 $ mkdir data
 $ mkdir scripts
 $ mkdir plots
 $ mkdir paper
 $ touch data/README.md
 $ touch scripts/README.md
 $ touch plots/README.md
 $ touch paper/README.md
 ~~~
 {: .language-bash}

With `touch` we are creating some empty files, git does not allow us to add empty folders, those `README.md` should contain instructions about the data contained on those folders, how the scripts, plots should operate of how the paper should be build. Research is a long time endeavor, do not assume that you will remember what you did several months ago. Now we are ready to version control those folders.

 ~~~
 $ git add data paper plots scripts
 $ git status
 ~~~
 {: .language-bash}
 ~~~
 On branch master

 No commits yet

 Changes to be committed:
   (use "git rm --cached <file>..." to unstage)

 	new file:   data/README.md
 	new file:   paper/README.md
 	new file:   plots/README.md
 	new file:   scripts/README.md
~~~
 {: .language-bash}

Now is time for our first commit:

~~~
$ git commit -m "My first commit"
~~~
{: .language-bash}
~~~
[master (root-commit) 5b5a7ed] My first commit
 4 files changed, 0 insertions(+), 0 deletions(-)
 create mode 100644 data/README.md
 create mode 100644 paper/README.md
 create mode 100644 plots/README.md
 create mode 100644 scripts/README.md
~~~
{: .output}

When we run `git commit`, Git takes everything we have told it to save by using git add (right now empty files) and stores a copy permanently inside the special .git directory. This permanent copy is called a commit (or revision) and its short identifier is 5b5a7ed. Each identifier is different so you will see a different code.

Now we are ready to populate the repository with some files. On the Hands-On repository <https://github.com/WVUHPC/Introduction-HPC_Data> there are a few files to populate the repository. If you have not done before clone the repository with:

~~~
$ git clone git@github.com:WVUHPC/Introduction-HPC_Data.git
~~~
{: .language-bash}

Go to the folder `Introduction-HPC_Data/09-git` there is a tree structure that mimics the structure suggested above. Copy the files into your own repository, in particular copy the `paper.tex` and `Makefile` into folder `paper` and `Data Generator.py` into scripts. There is also a file `Data Generator.ipynb` that is a IPython Notebook or Jupyter notebook.
Running the python script should produce both the data `wave.dat` and the figure `wave.pdf` in their respective folders. However, for the purpose of this lesson, the files are pre-generated so you can copy them and skip running the script.

~~~
$ git status
~~~
{: .language-bash}
~~~
On branch master
Untracked files:
  (use "git add <file>..." to include in what will be committed)

	data/wave.dat
	paper/Makefile
	paper/paper.pdf
	paper/paper.tex
	plots/wave.pdf
	scripts/Data_Generator.ipynb
	scripts/Data_Generator.py
~~~
{: .output}

Git is telling you that there are a number of new files that are "Untracked", it means, Git is not aware of having them Version Controlled. Git works better with text files, all the files above are text files except the pdf, the data file is not huge, those are basically the same points that we use for plotting. In real scenario your big datafiles should be out of version control. Lets add those files.

~~~
$ git add scripts paper plots data
$ git status
~~~
{: .language-bash}
~~~
On branch master
Changes to be committed:
  (use "git reset HEAD <file>..." to unstage)

	new file:   data/wave.dat
	new file:   paper/Makefile
	new file:   paper/paper.pdf
	new file:   paper/paper.tex
	new file:   plots/wave.pdf
	new file:   scripts/Data_Generator.ipynb
	new file:   scripts/Data_Generator.py
~~~
{: .output}

We can commit those files and create a new commit point.

~~~
$ git commit "Adding scripts and paper"
~~~
{: .language-bash}
~~~
[master 4aaa7ad] Adding scripts and paper
 7 files changed, 811 insertions(+)
 create mode 100644 data/wave.dat
 create mode 100644 paper/Makefile
 create mode 100644 paper/paper.pdf
 create mode 100644 paper/paper.tex
 create mode 100644 plots/wave.pdf
 create mode 100644 scripts/Data_Generator.ipynb
 create mode 100644 scripts/Data_Generator.py
~~~
{: .output}

The file `paper.tex` is a LaTeX file that simulates a research paper. If you are not familiar with LaTeX all that you have to do is execute `make` in the `paper` folder and a PDF of the paper will be generated.

~~~
$ cd paper/
$ make
~~~
{: .language-bash}
~~~
pdflatex paper.tex
This is pdfTeX, Version 3.14159265-2.6-1.40.19 (TeX Live 2018/MacPorts 2018.47642_1) (preloaded format=pdflatex)
 restricted \write18 enabled.
entering extended mode
(./paper.tex
LaTeX2e <2018-04-01> patch level 2
Babel <3.18> and hyphenation patterns for 46 language(s) loaded.
(/opt/local/share/texmf-texlive/tex/latex/base/article.cls
...(LONG OUTPUT)
Output written on paper.pdf (1 page, 63254 bytes).
Transcript written on paper.log.
~~~
{: .output}

Teaching LaTeX is out of scope here, at least on Spruce, the command for generating the paper should work, in your own computer, you need a LateX distribution see [https://www.latex-project.org](LaTeX Project) for LaTeX distros for your OS.

~~~
$ cd ..
$ git status
~~~
{: .language-bash}
~~~
On branch master
Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git checkout -- <file>..." to discard changes in working directory)

	modified:   paper/paper.pdf

Untracked files:
  (use "git add <file>..." to include in what will be committed)

	paper/paper.aux
	paper/paper.log

no changes added to commit (use "git add" and/or "git commit -a")
~~~
{: .output}

From one side, `paper.pdf` have changed, as binary file, even a small change such as different internal dates will create a different binary. In general it is not a good idea to keep track of those files. In any case we have the source `paper.tex` and from there we can recreate the PDF. Notice also the `paper.aux` and `paper.log` files. They were generated during the process of compiling the paper. We can take now the decision of not keep track of those files. If you are using emacs and you are editing those files you will also see files like `paper.tex~` and we do not want to keep track of those too.

The solution is editing the file `.gitignore` and indicate git that we do not want to keep track of those files. Using your favorite editor create a `.gitignore` file on the base folder `project_01`

~~~
*~
*.log
*.aux
*.pdf
~~~
{: .source}

~~~
$ git status
~~~
{: .language-bash}
~~~
On branch master
Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git checkout -- <file>..." to discard changes in working directory)

	modified:   paper/paper.pdf

Untracked files:
  (use "git add <file>..." to include in what will be committed)

	.gitignore

no changes added to commit (use "git add" and/or "git commit -a")
~~~
{: .output}

As we make the mistake of adding `paper.pdf` before we need to remove it from the cache, we do not need and probably we do not want to remove it from your working folder.

~~~
$ git rm --cache paper/paper.pdf
~~~
{: .language-bash}
~~~
rm 'paper/paper.pdf'
~~~
{: .output}
~~~
$ git status
~~~
{: .language-bash}
~~~
On branch master
Changes to be committed:
  (use "git reset HEAD <file>..." to unstage)

	deleted:    paper/paper.pdf

Untracked files:
  (use "git add <file>..." to include in what will be committed)

	.gitignore
~~~
{: .output}
~~~
$ git add .gitignore
$ git status
~~~
{: .language-bash}
~~~
On branch master
Changes to be committed:
  (use "git reset HEAD <file>..." to unstage)

	new file:   .gitignore
	deleted:    paper/paper.pdf
~~~
{: .output}
~~~
$ git commit -m "Adding .gitignore"
~~~
{: .language-bash}
~~~
[master 0fcf4d1] Adding .gitignore
 2 files changed, 4 insertions(+)
 create mode 100644 .gitignore
 delete mode 100644 paper/paper.pdf
~~~
{: .output}

> ## Exercise 3: Using git
>
> 1. Edit the paper, just add some text on the places indicated with TO DO. After the file is edited, run make and add and commit the files with git
>
> 2. Change the script, if you do not know python, change for example np.sin() by np.cos(). That should be enough for changing the data file and the figure. Do the proper arrangements to version control the changes.
>
>{: .source}
{: .challenge}

> ## Exercise 4: Using git on as source code repository
>
> This is another example on hot to work with a repository intended for source code, and a bit more oriented to developers than normal users.
>
> 1. Clone the repository at <https://github.com/guilleaf/TutorialGitAutotools.git>
>
> 2. The repository contains a very small program and autotools were used to provide it with a build system. Reconstruct the system with the next commands. The understanding of these commands is beyond the scope of this exercise. The idea is to have a code that you can work with.
>
>~~~
>$ autoconf -i
>$ make
>$ make check
>~~~
>{: .source}
>
>Now lets introduce a few changes to that code. If you know a bit of C language, the challenge is to generalize the code to support real numbers instead of integers. If you are not comfortable with C just edit the file `src/main.c` to print one extra line like:
>
>~~~
>printf("Montani semper liberi");
>~~~
>{: .source}
>
> Once the file is different, stage the file and commit the changes.
{: .challenge}


> ## Working with remote Git Servers
>
> When you use remote git servers, for example, github, gitlab  or any other git server, two basic commands are added to the process:
>
> `git push` is most commonly used to publish an upload local changes to a central repository. You can accumulate local commits before a push.
>
>
> `git pull` command is used to fetch and download content from a remote repository and immediately update the local repository to match that content. Waiting too much before pulling the master repository increases the chances of conflicts specially when several individuals contribute.
>
{: .callout}

> ## Learning more about git
>
> There are several resources available, we just explore the bare minimum you need to know to start using a version control system.
>
> Software Carpentry offers an entire lesson on Git
>
> [Version control with git](http://swcarpentry.github.io/git-novice/)
>
> Atlassian is a company that offers products for code collaboration.
> The have a very nice set of tutorials about git and their own service BitBucket.
>
> [Atlassian Git Tutorials](https://www.atlassian.com/git/tutorials)
>
> Github is the most popular service for Git. The have several videos and tutorials called Github Guides
>
> [Github Guides](https://guides.github.com)
>
> [Git Immersion](http://gitimmersion.com/)
{: .callout}


{% include links.md %}
