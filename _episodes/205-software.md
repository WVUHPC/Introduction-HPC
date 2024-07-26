---
title: "Software on HPC Clusters"
teaching: 60
exercises: 30
questions:
- "Which are the options to enable software packages on an HPC cluster?"
- "Which are the differences between environment modules, conda and apptainer?"
- "What are environment modules and how to use them"
- "How to use and create conda environments?"
- "How open a shell and execute commands on a Apptainer/Singularity container?"
objectives:
- "Learn about the three main options to enable software on HPC clusters."
- "Load and unload environment modules"
- "Activate and change conda environments"
- "Get a shell and execute commands inside singularity containers"
keypoints:
- Modules. Use `module avail` to know all the modules on the cluster.
- Modules. Use `module load <module_name>` to load a module.
- Conda. Use `conda env list` to list the available environments.
- Conda. Use `conda activate` to activate a conda environment.
- Singularity. Use `singularity shell <container>` to get a shell inside the container.
- Singularity. Use `singularity exec <container> <command>` to execute a command or script inside the container. 
---

# Introduction

There are many software packages being executed on an HPC cluster.
Each area of science uses its own set of software packages.
Sometimes the same software package is use in multiple versions and those version must be available on the same HPC cluster.
To solve all these challenges there are several options implemented on HPC clusters.
The different options offer various levels of isolation from the host system and some of these options are better suited for particular kinds of software.

## Environment Modules

*Environment modules* is a mechanism to easily enable software by changing the locations where software is installed.
By changing specific variables on the shell, different versions of packages can be made visible to the shell or to a script.
*Environment modules* is a software package that gives the user the ability to change the variables that the shell uses to find executables and libraries. 
To better understand how *environment modules* do its job it is essential to understand the concept of variables in the shell and the particular role of special variables called *environment variables*

### Shell variables and environment variables

The shell is a programming language in itself. As any programming language it has the ability to define placeholders for storing values. Those placeholders are called variables and the shell commands and shell scripts can made use of them.
Shell variables can be created on the shell using the operator `=`. For example:

~~~
$ A=10
$ B=20
~~~
{: .language-bash}

Environment variables are shell variables that are exported, i.e. converted into global variables.
The shell, and many other command line programs uses a set of variables to control their behavior. Those variables are called **environment variables**
Think about them as placeholders for information stored within the system that passes data to programs launched in the shell.

To create an environment variable you can first to create a variable and made it and environment variable using the command `export` followed by the name of the variable.

~~~
$ A=10
$ B=20
$ export A
$ export B
~~~
{: .language-bash}

This procedure can be simplified with a single line that defines and export the variable. Example:

~~~
$ export A=10
$ export B=20
~~~
{: .language-bash}

**Environment Variables** control CLI functionality. They declare where to search for executable commands, where to search for libraries, which language display messages to you, how you prompt looks. Beyond the shell itself, *environment variables* are use by many codes to control their own operation.

You can see all the variables currently defined by executing:

~~~
$ env
~~~
{: .language-bash}

Environment variables are similar to the shell variables that you can create of the shell. Shell variables can be used to store data and manipulated during the life of the shell session. However, only environment variables are visible by child processes created from that shell.
To clarify this consider this script:

~~~
#!/bin/bash

echo A= $A
echo B= $B
C=$(( $A + $B ))
echo C= $C
~~~
{: .source}

Now create two shell variables and execute the script, do the same with environment variables and notice that now the script is able to see the variables.

Some common environment variables commonly use by the shell are:

| Environment Variable	| Description |
|:----------------------|:------------|
| $USER	  | Your username  |
| $HOME   | The path to your home directory |
| $PS1	  | Your prompt |
| $PATH	  | List of locations to search for executable commands |
| $MANPATH	  | List of locations to search for manual pages |
| $LD_LIBRARY_PATH	  | List of locations to search for libraries in runtime |
| $LIBRARY_PATH	  | List of locations to search for libraries during compilation (actually during linking) |

Those are just a few environment variables of common use. There are many more. Changing them will change where executables are found, which libraries are used and how the system behaves in general. That is why managing the environment variables properly is so important on a machine, and even more on a HPC cluster, a machine that runs many different codes with different versions.

Here is where environment modules enters.

### Environment Modules

The modules software package allows you to dynamically modify your user environment by using **modulefiles**.

Each modulefile contains the information needed to configure the shell for an application. After the modules software package is initialized, the environment can be modified on a per-module basis using the module command, which interprets modulefiles. Typically, modulefiles instruct the module command to alter or set shell environment variables such as `PATH`, `MANPATH`, and others. The modulefiles can be shared by many users on a system, and users can have their own collection to supplement or replace the shared modulefiles.

As a user, you can add and remove modulefiles from the current environment. The environment changes contained in a modulefile can also be summarized through the module show command. You are welcome to change modules in your `.bashrc` or `.cshrc`, but be aware that some modules print information (to standard error) when loaded, this should be directed to a file or `/dev/null` when loaded in an initialization script.

### Basic arguments

The following table lists the most common module command options

| Command	| Description |
|:--------|:------------|
| module list	  | Lists modules currently loaded in a user's environment. |
| module avail  | Lists all available modules on a system. |
| module show	  | Shows environment changes that will be made by loading a given module. |
| module load	  | Loads a module. |
| module unload	| Unloads a module. |
| module help	  | Shows help for a module. |
| module swap	  | Swaps a currently loaded module for an unloaded module. |


> ### Exercise: Using modulefiles
>
> 1. Check the modules that you currently have and clean (purge) your environment from them. Check again and confirm that no module is loaded.
>
> 2. Check which versions of Python, R and GCC you have from the RHEL itself. Try to get and idea of how old those three components are. For python and R all that you have to do is enter the corresponding command (`R` or `python`). For GCC you need to use `gcc --version` and see the date of those programs.
>
> 3. Now lets get newer version of those 3 components by loading the corresponding modules. Search for the module for Python 3.10.11 and R 4.4.1 and GCC 9.3.0 and load the corresponding modules. To make things easier, you can use check the availability of modules just in the languages section. 
>
>    ~~~
>    module avail lang
>    ~~~
>    {: .source}
>
>
>    ~~~
>    module load lang/python/cpython_3.11.3_gcc122 lang/r/4.4.1_gcc122 lang/gcc/12.2.0 
>    ~~~
>    {: .source}
>
>
>
> 4. Check again which version of those 3 components you have now. Notice that in the case of Python 3, the command python still goes towards the old python 2.6.6, as the python 3.x interpreter is not backwards compatible with python 2.x the new command is called `python3`, check its version by entering the command.
>
>    ~~~
>    python3 --version
>    ~~~
>    {: .source}
>
>
>
> 5. Clean all of the environment
>
>    ~~~
>    module purge
>    ~~~
>    {: .source}
>
> 6. Go back and purge all the modules from your environment. We will now explore why it is important to use a recent compiler. Try to compile the code at `workshops_hands-on/Introduction_HPC/5._Environment_Modules/lambda_c++14.cpp`. Go to the folder and execute:
>
>    ~~~
>    g++ lambda_c++14.cpp
>    ~~~
>    {: .source}
>
>
>    At this point you should have received a list of errors, that is because even if the code is C++ it uses elements of the language that were not present at that time on C++ Specification. The code actually uses C++14 and only recent versions of GCC allows for these declarations. Lets check how many GCC compilers we have available on Thorny Flat.
>
>    ~~~
>    module avail lang/gcc
>    ~~~
>    {: .source}
>
>
>    Now from that list, start loading and trying to compile the code as indicated above. Which versions of GCC allow you to compile the code? Also try the Intel compilers. In the case of intel the command to compile the code is
>
>    ~~~
>    icpc lambda_c++14.cpp
>    ~~~
>    {: .source}
>
>
>    Try with all the Intel compilers, it will fail with all of them. That is because the default standard for the Intel C++ compiler is not C++14, you need to declare it explicitly and only for Intel Compiler suite 17.0.1
>
>    ~~~
>    icpc lambda_c++14.cpp -std=c++14
>    ~~~
>    {: .source}
>
>
>    Now it should be clearer why modules is an important feature of any HPC infrastructure as it allows you to use several compilers, libraries and packages in different versions. On a normal computer, you usually have just one.
>
>{: .source}
{: .challenge}


## Conda

Conda is an open source package management system and environment management system.
Conda quickly installs, runs and updates packages and their dependencies.
Conda easily creates, saves, loads and switches between environments.
It was created for Python programs, but it can package and distribute software for any language.

Conda as a package manager helps you find and install packages.
If you need a package that requires a different version of Python, you do not need to switch to a different environment manager, because conda is also an environment manager.
With just a few commands, you can set up a totally separate environment to run that different version of Python, while continuing to run your usual version of Python in your normal environment.

There are two installers for conda, Anaconda and Miniconda.

### Anaconda vs Miniconda

Anaconda is a downloadable, free, open source, high-performance and optimized Python and R distribution.
Anaconda includes conda, conda-build, Python, and 100+ automatically installed, open source scientific packages and their dependencies that have been tested to work well together, including SciPy, NumPy and many others.
Ananconda is more suited to be installed on a desktop environment as you get after installation a fairly complete environment for scientific computing.

From the other side Miniconda is free minimal installer for conda.
Miniconda is a small, bootstrap version of Anaconda that includes only conda, Python, the packages they depend on and a small number of other useful packages, including pip, zlib and a few others.
Miniconda is more suited for HPC environments where a minimal installation is all that is needed and users can create their own environments as needed.

### Activating Conda on Thorny Flat and Dolly Sods

On Thorny Flat the command to activate conda is:

~~~
source /shared/software/conda/conda_init.sh
~~~
{: .language-bash}

After activation your are positioned on the ``base`` environment.

When you have activated conda, you are always inside a conda environment.
Initially, you start on the `base` environment and your prompt in the shell will include a prefix in parenthesis indicating the name of the conda environment you are currently using.

### Conda Environments

Conda allows you to change your environment easily.
It also give you tools to create new environments, installing packages and their dependencies.
Conda environments will not interact with other environments so you can easily keep different versions of packages just by creating multiple conda environments and populating those with the various versions of software you want to use.

When you begin using conda, you already have a default environment named ``base``.
You cannot install packages on the ``base`` environment as that is a centrally managed environment.
Yous can, however, create new environments for installing packages.
Try to keep separate environments for different packages or group of packages.
That reduces the chances of incompatibility between them

### Knowing which environments are available

By the time of writing this tutorial Thorny Flat offers three environments
centrally installed::

~~~
$> conda env list

(base) trcis001:~$ conda env list
# conda environments:
#
base                    * /shared/software/conda
abienv_py36               /shared/software/conda/envs/abienv_py36
abienv_py37               /shared/software/conda/envs/abienv_py37
cutadaptenv               /shared/software/conda/envs/cutadaptenv
genomics_2024             /shared/software/conda/envs/genomics_2024
materials_2024            /shared/software/conda/envs/materials_2024
materials_2024_gcc93      /shared/software/conda/envs/materials_2024_gcc93
materials_discovery       /shared/software/conda/envs/materials_discovery
moose                     /shared/software/conda/envs/moose
neural_gpu                /shared/software/conda/envs/neural_gpu
picrust                   /shared/software/conda/envs/picrust
picrust2                  /shared/software/conda/envs/picrust2
python27                  /shared/software/conda/envs/python27
python35                  /shared/software/conda/envs/python35
python36                  /shared/software/conda/envs/python36
python37                  /shared/software/conda/envs/python37
qiime2-2022.8             /shared/software/conda/envs/qiime2-2022.8
qiime2-2023.2             /shared/software/conda/envs/qiime2-2023.2
qiime2-amplicon-2023.9    /shared/software/conda/envs/qiime2-amplicon-2023.9
qiime2-shotgun-2023.9     /shared/software/conda/envs/qiime2-shotgun-2023.9
qiime2-tiny-2023.9        /shared/software/conda/envs/qiime2-tiny-2023.9
r_4.2                     /shared/software/conda/envs/r_4.2
scipoptsuite              /shared/software/conda/envs/scipoptsuite
sourcetracker2            /shared/software/conda/envs/sourcetracker2
st2_py36                  /shared/software/conda/envs/st2_py36
st2_py37                  /shared/software/conda/envs/st2_py37
tensorflow18-py36         /shared/software/conda/envs/tensorflow18-py36
~~~
{: .language-bash}

### Activating an existing environment

Suppose that you want to use the environment called "tpd0001", to
achieve that execute::

~~~
conda activate tpd0001
~~~
{: .language-bash}

### Deactivating the current environment

The current environment can be deactivated with::

~~~
conda deactivate
~~~
{: .language-bash}

If you are in the ``base`` environment, the deactivation will not have any effect.
You are always at least on the ``base`` environment.

### Create a new environment

We will name the environment snowflakes and install the package BioPython.
At the Anaconda Prompt or in your terminal window, type the following::

~~~
(base) trcis001:~$ conda create --name snowflakes
Retrieving notices: ...working... done
Channels:
 - https://conda.software.inl.gov/public
 - conda-forge
Platform: linux-64
Collecting package metadata (repodata.json): done
Solving environment: done

## Package Plan ##

  environment location: /users/gufranco/.conda/envs/snowflakes



Proceed ([y]/n)? y

Preparing transaction: done
Verifying transaction: done
Executing transaction: done
#
# To activate this environment, use
#
#     $ conda activate snowflakes
#
# To deactivate an active environment, use
#
#     $ conda deactivate

~~~
{: .language-bash}

From here you can activate your environment and install the packages of your willing.

~~~
(base) trcis001:~$ conda activate snowflakes
(snowflakes) trcis001:~$
~~~
{: .language-bash}


or if you want also to install a package you can execute::

~~~
conda create --name snowflakes -c bioconda biopython
~~~
{: .language-bash}

Conda collects metadata about the package and its dependencies and produces an installation plan::

~~~
Channels:
 - bioconda
 - https://conda.software.inl.gov/public
 - conda-forge
Platform: linux-64
Collecting package metadata (repodata.json): done
Solving environment: done

## Package Plan ##

  environment location: /users/gufranco/.conda/envs/snowflakes

  added / updated specs:
    - biopython


The following packages will be downloaded:

    package                    |            build
    ---------------------------|-----------------
    biopython-1.70             |      np112py36_1         2.6 MB  bioconda
    ca-certificates-2024.7.4   |       hbcca054_0         151 KB  conda-forge
    ld_impl_linux-64-2.40      |       hf3520f5_7         691 KB  conda-forge
    libgcc-ng-14.1.0           |       h77fa898_0         822 KB  conda-forge
    libgomp-14.1.0             |       h77fa898_0         446 KB  conda-forge
    libpng-1.6.43              |       h2797004_0         281 KB  conda-forge
    libsqlite-3.46.0           |       hde9e2c9_0         845 KB  conda-forge
    libstdcxx-ng-14.1.0        |       hc0a3c3a_0         3.7 MB  conda-forge
    libwebp-base-1.4.0         |       hd590300_0         429 KB  conda-forge
    libzlib-1.2.13             |       h4ab18f5_6          60 KB  conda-forge
    mmtf-python-1.1.3          |     pyhd8ed1ab_0          25 KB  conda-forge
    ncurses-6.5                |       h59595ed_0         867 KB  conda-forge
    numpy-1.12.1               |py36_blas_openblash1522bff_1001         3.8 MB  conda-forge
    reportlab-3.5.68           |   py36h3e18861_0         2.4 MB  conda-forge
    sqlite-3.46.0              |       h6d4b2fc_0         840 KB  conda-forge
    zlib-1.2.13                |       h4ab18f5_6          91 KB  conda-forge
    zstd-1.5.6                 |       ha6fb4c9_0         542 KB  conda-forge
    ------------------------------------------------------------
                                           Total:        18.5 MB

The following NEW packages will be INSTALLED:

  _libgcc_mutex      conda-forge/linux-64::_libgcc_mutex-0.1-conda_forge 
  _openmp_mutex      conda-forge/linux-64::_openmp_mutex-4.5-2_gnu 
  biopython          bioconda/linux-64::biopython-1.70-np112py36_1 
  blas               conda-forge/linux-64::blas-1.1-openblas 
  ca-certificates    conda-forge/linux-64::ca-certificates-2024.7.4-hbcca054_0 
  freetype           conda-forge/linux-64::freetype-2.12.1-h267a509_2 
  jpeg               conda-forge/linux-64::jpeg-9e-h0b41bf4_3 
  lcms2              conda-forge/linux-64::lcms2-2.12-hddcbb42_0 
  ld_impl_linux-64   conda-forge/linux-64::ld_impl_linux-64-2.40-hf3520f5_7 
  lerc               conda-forge/linux-64::lerc-3.0-h9c3ff4c_0 
  libdeflate         conda-forge/linux-64::libdeflate-1.10-h7f98852_0 
  libffi             conda-forge/linux-64::libffi-3.4.2-h7f98852_5 
  libgcc-ng          conda-forge/linux-64::libgcc-ng-14.1.0-h77fa898_0 
  libgfortran-ng     conda-forge/linux-64::libgfortran-ng-7.5.0-h14aa051_20 
  libgfortran4       conda-forge/linux-64::libgfortran4-7.5.0-h14aa051_20 
  libgomp            conda-forge/linux-64::libgomp-14.1.0-h77fa898_0 
  libnsl             conda-forge/linux-64::libnsl-2.0.1-hd590300_0 
  libpng             conda-forge/linux-64::libpng-1.6.43-h2797004_0 
  libsqlite          conda-forge/linux-64::libsqlite-3.46.0-hde9e2c9_0 
  libstdcxx-ng       conda-forge/linux-64::libstdcxx-ng-14.1.0-hc0a3c3a_0 
  libtiff            conda-forge/linux-64::libtiff-4.3.0-h0fcbabc_4 
  libwebp-base       conda-forge/linux-64::libwebp-base-1.4.0-hd590300_0 
  libzlib            conda-forge/linux-64::libzlib-1.2.13-h4ab18f5_6 
  mmtf-python        conda-forge/noarch::mmtf-python-1.1.3-pyhd8ed1ab_0 
  msgpack-python     conda-forge/linux-64::msgpack-python-1.0.2-py36h605e78d_1 
  ncurses            conda-forge/linux-64::ncurses-6.5-h59595ed_0 
  numpy              conda-forge/linux-64::numpy-1.12.1-py36_blas_openblash1522bff_1001 
  olefile            conda-forge/noarch::olefile-0.46-pyh9f0ad1d_1 
  openblas           conda-forge/linux-64::openblas-0.3.3-h9ac9557_1001 
  openjpeg           conda-forge/linux-64::openjpeg-2.5.0-h7d73246_0 
  openssl            conda-forge/linux-64::openssl-1.1.1w-hd590300_0 
  pillow             conda-forge/linux-64::pillow-8.3.2-py36h676a545_0 
  pip                conda-forge/noarch::pip-21.3.1-pyhd8ed1ab_0 
  python             conda-forge/linux-64::python-3.6.15-hb7a2778_0_cpython 
  python_abi         conda-forge/linux-64::python_abi-3.6-2_cp36m 
  readline           conda-forge/linux-64::readline-8.2-h8228510_1 
  reportlab          conda-forge/linux-64::reportlab-3.5.68-py36h3e18861_0 
  setuptools         conda-forge/linux-64::setuptools-58.0.4-py36h5fab9bb_2 
  sqlite             conda-forge/linux-64::sqlite-3.46.0-h6d4b2fc_0 
  tk                 conda-forge/linux-64::tk-8.6.13-noxft_h4845f30_101 
  wheel              conda-forge/noarch::wheel-0.37.1-pyhd8ed1ab_0 
  xz                 conda-forge/linux-64::xz-5.2.6-h166bdaf_0 
  zlib               conda-forge/linux-64::zlib-1.2.13-h4ab18f5_6 
  zstd               conda-forge/linux-64::zstd-1.5.6-ha6fb4c9_0 


Proceed ([y]/n)? 

~~~
{: .}

Conda asks if you want to proceed with the plan::

~~~
Proceed ([y]/n)? y
Type "y" and press Enter to proceed.
~~~
{: .language-bash}

After that, conda, download and installs the packages creating a new environment for you.
The final message shows how to activate and deactivate the environment::

~~~
Preparing transaction: done
Verifying transaction: done
Executing transaction: done
#
# To activate this environment, use
#
#     $ conda activate snowflakes
#
# To deactivate an active environment, use
#
#     $ conda deactivate
~~~
{: .language-bash}

Each environment is isolated from other conda environments and that allow you to keep several environments with different packages on them or different versions of the same packages.
As the message shows you activate the environment with::

~~~
conda activate snowflakes
~~~
{: .language-bash}

Notice that when you activate a new environment, the prompt changes adding a prefix in parenthesis to indicate on which conda environment are you using at that moment.
To check the environments available execute::

~~~
conda env list
~~~
{: .language-bash}

or::

~~~
conda info --envs
~~~
{: .language-bash}

### Conda and Python

When you create a new environment, conda installs the same Python version used to install conda on Thorny Flat (3.9).
If you want to use a different version of Python, for example Python 2.7, simply create a new environment and specify the version of Python that you want::

~~~
conda create --name python27 python=2.7
~~~
{: .language-bash}

You activate the environment::

~~~
conda activate python27
~~~
{: .language-bash}

And verify the python version::

~~~
$ python --version
Python 2.7.16 :: Anaconda, Inc.
~~~
{: .language-bash}

Conda has packages for versions of python for 2.7, 3.5, 3.6 and 3.7

### Managing packages and channels

New packages can be installed to existing conda environments. First search for packages with::

~~~
conda search mkl
~~~
{: .language-bash}

Packages are stored in repositories called **channels**.
By default, conda search on the ``pkgs/main`` channel only.
However, there are many other packages on several other channels.

The most prominent channels to search for packages are **intel**, **conda-forge** and **bioconda**
To search for packages there execute::

~~~
conda search -c intel mkl

conda search -c conda-forge nitime

conda search -c bioconda blast
~~~
{: .language-bash}

Packages can be installed on the current environment with::

~~~
conda install -c conda-forge nitime
~~~
{: .language-bash}

In this case conda will pick the most recent version of the package compatible with the packages already present on the current environment.
You can also be very selective on version and build that you want for the package.
First get the list of versions and builds for the package that you want::

~~~
  $ conda search -c intel mkl
  Loading channels: done
  # Name                       Version           Build  Channel
  mkl                         2017.0.3         intel_6  intel
  mkl                         2017.0.4      h4c4d0af_0  pkgs/main
  mkl                         2018.0.0      hb491cac_4  pkgs/main
  mkl                         2018.0.0         intel_4  intel
  mkl                         2018.0.1      h19d6760_4  pkgs/main
  mkl                         2018.0.1         intel_4  intel
  mkl                         2018.0.2               1  pkgs/main
  mkl                         2018.0.2         intel_1  intel
  mkl                         2018.0.3               1  pkgs/main
  mkl                         2018.0.3         intel_1  intel
  mkl                           2019.0             117  pkgs/main
  mkl                           2019.0             118  pkgs/main
  mkl                           2019.0       intel_117  intel
  mkl                           2019.1             144  pkgs/main
  mkl                           2019.1       intel_144  intel
  mkl                           2019.2       intel_187  intel
  mkl                           2019.3             199  pkgs/main
  mkl                           2019.3       intel_199  intel
  mkl                           2019.4             243  pkgs/main
  mkl                           2019.4       intel_243  intel
  mkl                           2019.5       intel_281  intel
  ~~~
  {: .language-bash}


Now, install the package declaring the version and build::

~~~
$ conda install -c intel mkl=2019.4=intel_243
Collecting package metadata (current_repodata.json): done
Solving environment: done

## Package Plan ##

  environment location: /users/gufranco/.conda/envs/test

  added / updated specs:
    - mkl==2019.4=intel_243


The following packages will be downloaded:

    package                    |            build
    ---------------------------|-----------------
    intel-openmp-2019.5        |        intel_281         888 KB  intel
    mkl-2019.4                 |        intel_243       204.1 MB  intel
    tbb-2019.8                 |        intel_281         874 KB  intel
    ------------------------------------------------------------
                                           Total:       205.8 MB

The following NEW packages will be INSTALLED:

  intel-openmp       intel/linux-64::intel-openmp-2019.5-intel_281
  mkl                intel/linux-64::mkl-2019.4-intel_243
  tbb                intel/linux-64::tbb-2019.8-intel_281


Proceed ([y]/n)?


Downloading and Extracting Packages
tbb-2019.8           | 874 KB    | #################################################################################################################################### | 100%
mkl-2019.4           | 204.1 MB  | #################################################################################################################################### | 100%
intel-openmp-2019.5  | 888 KB    | #################################################################################################################################### | 100%
Preparing transaction: done
Verifying transaction: done
Executing transaction: done
~~~
{: .language-bash}

### Creating a new environment from a YML file

You can create your own environment, one easy way of doing that is via a
YML file that describes the channels and packages that you want on your
environment. The YML file will look like this, for a simple case when
you want one env for bowtie2 (bowtie2.yml)

~~~
    name: thorny-bowtie2
    channels:
      - bioconda
      - conda-forge
      - defaults
    dependencies:
      - bowtie2
~~~
{: .language-bash}

Another example is this YML file for installing a curated set of basic
genomics codes that requires just a few dependencies. (biocore.yml)

~~~
name: biocode
channels:
  - bioconda
  - conda-forge
  - defaults
dependencies:
  - bamtools
  - bcftools
  - bedtools
  - hmmer
  - muscle
  - raxml
  - samtools
  - sga
  - soapdenovo-trans
  - soapdenovo2
  - sra-tools
  - vcftools
  - velvet
~~~
{: .language-bash}

To create an environment from those YML files you can select one
location on your scratch folder

~~~
conda env create -p $SCRATCH/bowtie2 -f bowtie2.yml
~~~
{: .language-bash}

or for the biocore.yml

~~~
conda env create -p $SCRATCH/biocore -f biocore.yml
~~~
{: .language-bash}

By default, new environments are created inside your `$HOME` folder on
`$HOME/.conda`

### Listing the packages inside one environment

Bowtie2 has a number of dependencies (19 dependencies for 1 package)
Notice that only bowtie2 comes from bioconda channel. All other packages
are part of conda-forge, a lower level channel.

~~~
$ conda activate $SCRATCH/bowtie2
$ conda list
# packages in environment at /scratch/gufranco/bowtie2:
#
# Name                    Version                   Build  Channel
bowtie2                   2.3.4.2          py36h2d50403_0    bioconda
bzip2                     1.0.6                h470a237_2    conda-forge
ca-certificates           2018.8.24            ha4d7672_0    conda-forge
certifi                   2018.8.24                py36_1    conda-forge
libffi                    3.2.1                hfc679d8_5    conda-forge
libgcc-ng                 7.2.0                hdf63c60_3    conda-forge
libstdcxx-ng              7.2.0                hdf63c60_3    conda-forge
ncurses                   6.1                  hfc679d8_1    conda-forge
openssl                   1.0.2p               h470a237_0    conda-forge
perl                      5.26.2               h470a237_0    conda-forge
pip                       18.0                     py36_1    conda-forge
python                    3.6.6                h5001a0f_0    conda-forge
readline                  7.0                  haf1bffa_1    conda-forge
setuptools                40.2.0                   py36_0    conda-forge
sqlite                    3.24.0               h2f33b56_1    conda-forge
tk                        8.6.8                         0    conda-forge
wheel                     0.31.1                   py36_1    conda-forge
xz                        5.2.4                h470a237_1    conda-forge
zlib                      1.2.11               h470a237_3    conda-forge
~~~
{: .language-bash}

### Using a conda environment in a submission script

To execute software in a non-interactive job you need to source the main
script, activate the environment that contains the software you need,
execute the the scientific code and deactivate the environment. This is
a simple example showing that for bowtie2

~~~
#!/bin/bash

#SBATCH -J CONDA_JOB
#SBATCH -N 1
#SBATCH -c 4
#SBATCH -p standby
#SBATCH -t 4:00:00

source /shared/software/conda/conda_init.sh
conda activate $SCRATCH/bowtie2

bowtie2 .....

conda deactivate
~~~
{: .language-bash}


### Deleting a environment

To remove an environment you can just execute this command.

~~~
conda remove --all -p $SCRATCH/bowtie2
~~~
{: .language-bash}


### More documentation

`Conda Documentation <https://conda.io/docs/index.html>`__

[https://conda.io/docs/user-guide/tasks/manage-environments.html\ #
Managing environments]

`Using Bioconda — Bioconda
documentation <https://bioconda.github.io/>`__

`Available packages — Bioconda
documentation <https://bioconda.github.io/conda-recipe_index.html>`__

### Downloading Miniconda

Miniconda can be downloaded from::

~~~
wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
sh Miniconda3-latest-Linux-x86_64.sh
~~~
{: .language-bash}

### No installing anything

Just load the module::

~~~
module purge
module load genomics/qiime
~~~
{: .language-bash}

This module will load python 2.7.3 and qiime on top of that

## Singularity Containers

Containers are a software technology that allows us to keep control of the environment where a given code runs. Consider for example that you want to run a code in such a way the same code runs on several machines or clusters ensuring that the same libraries are loaded and the same general environment is present. Different clusters could come installed with different compilers, different Linux distributions and different libraries in general. Containers can be used to package entire scientific workflows, software and libraries, and even data and move them to several compute infrastructures with complete reproducibility.

Containers are similar to Virtual Machines, however, the differences are enough to consider them different technologies and those differences are very important for HPC. Virtual Machines takes up a lot of system resources. Each Virtual Machine (VM) runs not just a full copy of an operating system, but a virtual copy of all the hardware that the operating system needs to run. This quickly adds up to a lot of precious RAM and CPU cycles, valuable resources for HPC.

In contrast, all that a container requires is enough of an operating system, supporting programs and libraries, and system resources to run a specific program. From the user perspective, a container is in most cases a single file that contains the file system, ie a rather complete Unix filesystem tree with all libraries, executables, and data that are needed for a given workflow or scientific computation.

There are several container solutions, the most popular probably is Docker, however, the main issue with using docker on HPC is security, despite the name, containers do not actually contain the powers of the user who executes code on them. That is why you do not see Docker installed on an HPC cluster. Using dockers requires superuser access something that on shared resources like an HPC cluster is not typically possible.

Singularity offers an alternative solution to Docker, users can run the prepared images that we are offering on our clusters or bring their own.

For more information about Singularity and complete documentation see: https://singularity.lbl.gov/quickstart

### How to use a singularity Image

There are basically two scenarios, interactive execution and job submission.

#### Interactive Job

If you are using Visit or RStudio, programs that uses the X11 forwarding, ensure to connect first to the cluster with X11 forwarding, before asking for an interactive job.
In order to connect into Thorny with X11 forwarding use:

~~~
ssh -X <username>@ssh.wvu.edu
~~~
{: .source}

~~~
ssh -X <username>@tf.hpc.wvu.edu
~~~
{: .source}

Once you have login into the cluster, create an interactive job with the following command line, in this case we are using standby as queue but any other queue is valid.

~~~
salloc -c 4 -p standby
~~~
{: .source}


Once you get inside a compute node, load the module:

~~~
module load singularity
~~~
{: .source}


After loading the module the command singularity is available for usage, and you can get a shell inside the image with:

~~~
singularity shell /shared/containers/<Image Name>
~~~
{: .source}


#### Job Submission

In this case you do not need to export X11, just login into Thorny Flat

~~~
ssh <username>@ssh.wvu.edu

ssh <username>@tf.hpc.wvu.edu
~~~
{: .source}


Once you have login into the cluster, create a submission script ("runjob.pbs" for this example), in this case we are using standby as queue but any other queue is valid.

~~~
#!/bin/sh

#SBATCH -J SINGULARITY_JOB
#SBATCH -N 1
#SBATCH -c 4
#SBATCH -p standby
#SBATCH -t 4:00:00

module load singularity

singularity exec /shared/containers/<Image Name> <command_or_script_to_run>
~~~
{: .source}


Submit your job with

~~~
sbatch runjob.pbs
~~~
{: .source}

> ### Exercise 1: Using singularity on the cluster (Interactive)
>
> This exercise propose the use of singularity to access RStudio-server version 2023.12.1-402 and R 4.4.1
>
> Follow the instructions for accessing an interactive session
>
> The image is located at:
>
> ~~~
> /shared/containers/RStudio-server-2023.12.1-402_R-4.4.1_jammy.sif 
> ~~~
> {: .source}
> Be sure that you can execute basic R commands. You can get an error message like:
>
>>   WARNING: You are configured to use the CRAN mirror at https://cran.rstudio.com/. This mirror supports secure (HTTPS) downloads however your system is unable to communicate securely with the server (possibly due to out of date certificate files on your system). Falling back to using insecure URL for this mirror.
>
> That is normal and due to the fact that compute nodes have no Internet access.
>
{: .challenge}

> ### Exercise 2: Using singularity on the cluster (Non-interactive)
>
> Create a script that reads a CSV with official statistics of population for US. The file can be downloaded from:
>~~~
>$ wget https://www2.census.gov/programs-surveys/popest/datasets/2010-2018/state/detail/SCPRC-EST2018-18+POP-RES.csv
>~~~
>{: .source}
>
> However, the file is also present in the repository for hands-ons
>~~~
>$ git clone https://github.com/WVUHPC/workshops_hands-on.git
>~~~
>{: .language-bash}
>
>The folder is `workshops_hands-on/Introduction_HPC/11._Software_Containers_Singularity`. If you are not familiar with R programming, the script is there too. Notice that you cannot write your script to download the CSV file directly from the Census Bureau as the compute  nodes have no Internet access.
> Write a submission script and submit.
>
{: .challenge}

## Advanced topics

### **Modules:** Creating a private repository

The basic procedure is to locate modules on a folder accessible by relevant users and add the variable `MODULEPATH` to your `.bashrc`

`MODULEPATH` controls the path that the module command searches when looking for
modulefiles.
Typically, it is set  to a  default  value by the bootstrap procedure.
`MODULEPATH` can be set using ’module use’ or by the module initialization
script to search group or personal modulefile directories before  or  after
the master modulefile directory.

### **Singularity:** Creating your own images

You can create your own Singularity images and use them on our clusters.
The only constrain is that images can only be created on your own machine as you need root access to create them.

The procedure that we will show will be executed on a remote machine provided by JetStream, it should the same if you have your own Linux machine and you have superuser access to it.

The creation of images is an interactive procedure. You learn how to put pieces together and little by little you build your own recipe for your image.

Lets start with a very clean image with centos.

The minimal recipe will bring an image from Docker with the latest version of CentOS. Lets call the file `centos.bst`

~~~
# Singularity container with centos
#
# This is the Bootstrap file to recreate the image.
#

Bootstrap: docker
From: centos:latest

%runscript
exec echo "The runscript is the containers default runtime command!"

%files

%environment

%labels
AUTHOR username@mail.wvu.edu

%post
echo "The post section is where you can install, and configure your container."
mkdir -p /data/bin
mkdir -p /gpfs
mkdir -p /users
mkdir -p /group
mkdir -p /scratch
touch /usr/bin/nvidia-smi
~~~
{: .source}

A few folders are created that help us to link special folders like `/users`, `/scratch` to the host file system. Other than that the image contains a very small but usable Linux CentOS machine.

We start with a writable sandboxed version, the exact command varies from machine to machine, but assuming that you can do sudo and the command singularity is available for root execute this:

~~~
sudo singularity build --sandbox centos centos.bst
~~~
{: .language-bash}
~~~
Using container recipe deffile: centos.bst
Sanitizing environment
Adding base Singularity environment to container
Docker image path: index.docker.io/library/centos:latest
Cache folder set to /root/.singularity/docker
Exploding layer: sha256:8ba884070f611d31cb2c42eddb691319dc9facf5e0ec67672fcfa135181ab3df.tar.gz
Exploding layer: sha256:306a59f4aef08d54a38e1747ff77fc446103a3ee3aea83676db59d6d625b02a1.tar.gz
User defined %runscript found! Taking priority.
Adding files to container
Adding environment to container
Running post scriptlet
+ echo 'The post section is where you can install, and configure your container.'
The post section is where you can install, and configure your container.
+ mkdir -p /data/bin
+ mkdir -p /gpfs
+ mkdir -p /users
+ mkdir -p /group
+ mkdir -p /scratch
+ touch /usr/bin/nvidia-smi
Adding deffile section labels to container
Adding runscript
Finalizing Singularity container
Calculating final size for metadata...
Skipping checks
Singularity container built: centos
Cleaning up...
~~~
{: .output}

The result will be a folder called `centos`. We can enter into that folder to learn what we need to install the packages for our image.

~~~
sudo singularity shell --writable centos
~~~
{: .language-bash}

For our exercise lets imagine that we want to use a package that opens a window.
In particular, we now that we need a package that is called libgraph to get access to the graphics capabilities. The software is not provided by CentOS itself, so we need to compile it. We need to download, compile and install this package. We learn first how to do it and add that learning to the Bootstrap recipe file.

We need:

1. Download <http://www.mirrorservice.org/sites/download.savannah.gnu.org/releases/libgraph/libgraph-1.0.2.tar.gz>, so we need `wget` for that. This is one package that we need to install from yum.

2. We need compilers, and make. So we have to install `gcc`, `gcc-c++` and `make`

3. The next time to try, you notice that you will also need some extra packages provided by EPEL, devel packages from CentOS and EPEL repositories.
The packages are `SDL-devel` `epel-release` `SDL_image-devel` `compat-guile18-devel` and `guile-devel`.

Trial and error move you from the original recipe to this one (`centos-libgraph.bst`):

~~~
# Singularity container with centos
#
# This is the Bootstrap file to recreate the image.
#

Bootstrap: docker
From: centos:latest

%runscript
exec echo "The runscript is the containers default runtime command!"

%files

%environment

%labels
AUTHOR username@mail.wvu.edu

%post
echo "The post section is where you can install, and configure your container."

yum -y install wget make gcc gcc-c++ SDL-devel epel-release
yum -y update && yum -y install SDL_image-devel compat-guile18-devel guile-devel

mkdir -p /data/bin
mkdir -p /gpfs
mkdir -p /users
mkdir -p /group
mkdir -p /scratch
touch /usr/bin/nvidia-smi

cd /data
wget http://www.mirrorservice.org/sites/download.savannah.gnu.org/releases/libgraph/libgraph-1.0.2.tar.gz
tar -zxvf libgraph-1.0.2.tar.gz
cd libgraph-1.0.2 && ./configure --prefix=/data && make && make install
~~~
{: .source}

Notice that we have added a few lines using `yum` to install some packages, we add EPEL on the first line and we use it to install some extra packages on the second line.

~~~
yum -y install wget make gcc gcc-c++ SDL-devel epel-release
yum -y update && yum -y install SDL_image-devel compat-guile18-devel guile-devel
~~~
{: .source}

Finally, we use `wget` to get the sources and build `libgraph`.
In order to save space on the VM, lets delete the old folder and create a new one with the new recipe.

~~~
sudo rm -rf centos
sudo singularity build --sandbox centos centos-libgraph.bst
~~~
{: .language-bash}

The command takes longer and at the end you get libgraph installed at `/data`
The final step will be use that to test that we are able to use libgraph with our application. The application is a couple of very small codes that use libgraph as dependency.

To achieve this we need.

1. Modify the environment variables `PATH` and `LD_LIBRARY_PATH` to point to the locations where libgraph and our binaries will be located.

2. Copy the sources `circles.c` and `julia.c` to the image and compile it.

The final version of the Bootstrap recipe looks like this `centos-final.bst`

~~~

# Singularity container with centos
#
# This is the Bootstrap file to recreate the image.
#

Bootstrap: docker
From: centos:latest

%runscript
exec echo "The runscript is the containers default runtime command!"

%files
julia.c
circles.c
sample.c

%environment
SHELL=/bin/bash
export SHELL
PATH=/data/bin:$PATH
export PATH
LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/data/lib
export LD_LIBRARY_PATH

%labels
AUTHOR username@mail.wvu.edu

%post
echo "The post section is where you can install, and configure your container."
yum -y install wget make gcc gcc-c++ SDL-devel epel-release
yum -y update && yum -y install SDL_image-devel compat-guile18-devel guile-devel
mkdir -p /data/bin
mkdir -p /gpfs
mkdir -p /users
mkdir -p /group
mkdir -p /scratch
touch /usr/bin/nvidia-smi

mv /circles.c /julia.c /sample.c /data

cd /data
wget http://www.mirrorservice.org/sites/download.savannah.gnu.org/releases/libgraph/libgraph-1.0.2.tar.gz
tar -zxvf libgraph-1.0.2.tar.gz
cd libgraph-1.0.2 && ./configure --prefix=/data && make && make install

cd /data
gcc julia.c -o bin/julia -I/data/include -L/data/lib -lgraph -lm
gcc circles.c -o bin/circles -I/data/include -L/data/lib -lgraph -lm
gcc sample.c -o bin/sample -I/data/include -L/data/lib -lgraph -lm
~~~
{: .source}

We add a few sample files `sample.c`, `circles.c` and `julia.c` that uses the old `graphics.h` provided by `libgraph`.

The binaries are `sample`, `cicles` and `julia` and they are accessible on the command line.

When you have crafted a good recipe with the codes and data that you need. The last step is to create a final image. The command for that is below, remembering of deleting the `centos` folder to save space.

~~~
sudo rm -rf centos
sudo singularity build centos-final.simg centos-final.bst
~~~
{: .language-bash}

This is the final image. It is not too big, it contains the packages that we installed from yum, the sources and binaries for libgraph and the sources for the couple of example sources that uses libgraph. The image can be move to any machine with singularity and should be able to run the codes.

Remember that to see the windows you should have and Xserver running on your machine and X11 forwarding on your ssh client.




{% include links.md %}
