---
title: "Environment management: Conda"
teaching: 35
exercises: 10
questions:
- "What are software containers and how to use them?"
objectives:
- "Learn about singularity containers, both using and creating images."
keypoints:
- "Singularity containers give you control on the software you want on a machine, helping you with reproducible executions."
---

# Conda

Conda is an open source package management system and environment management system.
Conda quickly installs, runs and updates packages and their dependencies.
Conda easily creates, saves, loads and switches between environments.
It was created for Python programs, but it can package and distribute software for any language.

Conda as a package manager helps you find and install packages.
If you need a package that requires a different version of Python, you do not need to switch to a different environment manager, because conda is also an environment manager.
With just a few commands, you can set up a totally separate environment to run that different version of Python, while continuing to run your usual version of Python in your normal environment.

There are two installers for conda, Anaconda and Miniconda.

## Anaconda vs Miniconda

Anaconda is a downloadable, free, open source, high-performance and optimized Python and R distribution.
Anaconda includes conda, conda-build, Python, and 100+ automatically installed, open source scientific packages and their dependencies that have been tested to work well together, including SciPy, NumPy and many others.
Ananconda is more suited to be installed on a desktop environment as you get after installation a fairly complete environment for scientific computing.

From the other side Miniconda is free minimal installer for conda.
Miniconda is a small, bootstrap version of Anaconda that includes only conda, Python, the packages they depend on and a small number of other useful packages, including pip, zlib and a few others.
Miniconda is more suited for HPC environments where a minimal installation is all that is needed and users can create their own environments as needed.

## Activating Conda on Spruce and Thorny Flat

On Spruce you can activate conda with:

~~~
source /shared/software/miniconda3/etc/profile.d/conda.sh
~~~
{: .language-bash}

On Thorny Flat the command to activate conda is:

~~~
source /shared/software/conda/conda_init.sh
~~~
{: .language-bash}

After activation your are positioned on the ``base`` environment.


## Conda Environments

Conda allows you to create separate environments containing files, packages and their dependencies that will not interact with other environments.

When you begin using conda, you already have a default environment named ``base``.
You cannot install packages on the ``base`` environment.
Yous should create new environments for installing packages.
Try to keep separate environments for different packages or group of packages.
That reduces the chances of incompatibility between them

### Knowing which environments are available

By the time of writing this tutorial Spruce offers three environments
centrally installed::

~~~
$> conda info --envs

# conda environments:
#
                         /scratch/gufranco/conda-intel
base                     /shared/software/miniconda3
genomics-core            /shared/software/miniconda3/envs/genomics-core
jupyter                  /shared/software/miniconda3/envs/jupyter
python27                 /shared/software/miniconda3/envs/python27
python35                 /shared/software/miniconda3/envs/python35
python36                 /shared/software/miniconda3/envs/python36
python37                 /shared/software/miniconda3/envs/python37
qiime2-2018.8            /shared/software/miniconda3/envs/qiime2-2018.8
snowflakes               /shared/software/miniconda3/envs/snowflakes
tpd0001                  /shared/software/miniconda3/envs/tpd0001
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
conda create --name snowflakes
~~~
{: .language-bash}


or if you want also to install a package you can execute::

~~~
conda create --name snowflakes biopython
~~~
{: .language-bash}

Conda collects metadata about the package and its dependencies and produces an installation plan::

~~~
## Package Plan ##

environment location: /shared/software/conda/envs/snowflakes

added / updated specs:
- biopython


The following packages will be downloaded:

package                    |            build
---------------------------|-----------------
_libgcc_mutex-0.1          |             main           3 KB
biopython-1.74             |   py37h7b6447c_0         2.0 MB
blas-1.0                   |              mkl           6 KB
ca-certificates-2019.8.28  |                0         132 KB
certifi-2019.9.11          |           py37_0         154 KB
intel-openmp-2019.4        |              243         729 KB
libedit-3.1.20181209       |       hc058e9b_0         163 KB
libffi-3.2.1               |       hd88cf55_4          40 KB
libgcc-ng-9.1.0            |       hdf63c60_0         5.1 MB
libgfortran-ng-7.3.0       |       hdf63c60_0        1006 KB
libstdcxx-ng-9.1.0         |       hdf63c60_0         3.1 MB
mkl-2019.4                 |              243       131.2 MB
mkl-service-2.3.0          |   py37he904b0f_0         218 KB
mkl_fft-1.0.14             |   py37ha843d7b_0         155 KB
mkl_random-1.1.0           |   py37hd6b4f25_0         321 KB
ncurses-6.1                |       he6710b0_1         777 KB
numpy-1.17.2               |   py37haad9e8e_0           4 KB
numpy-base-1.17.2          |   py37hde5b4d6_0         4.2 MB
openssl-1.1.1d             |       h7b6447c_1         3.7 MB
pip-19.2.3                 |           py37_0         1.9 MB
python-3.7.4               |       h265db76_1        32.1 MB
readline-7.0               |       h7b6447c_5         324 KB
setuptools-41.2.0          |           py37_0         630 KB
six-1.12.0                 |           py37_0          23 KB
sqlite-3.29.0              |       h7b6447c_0         1.1 MB
tk-8.6.8                   |       hbc83047_0         2.8 MB
wheel-0.33.6               |           py37_0          40 KB
xz-5.2.4                   |       h14c3975_4         283 KB
zlib-1.2.11                |       h7b6447c_3         103 KB
------------------------------------------------------------
                                       Total:       192.2 MB
~~~
{: .language-bash}

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

When you create a new environment, conda installs the same Python version used to install conda on Spruce and Thorny (3.7).
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
    name: spruce-bowtie2
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

By default, new environments are created inside your $HOME folder on
$HOME/.conda

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

#PBS -N MY_JOB
#PBS -q standby
#PBS -j oe
#PBS -l nodes=1:ppn=2

source /shared/software/miniconda3/etc/profile.d/conda.sh
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


{% include links.md %}
