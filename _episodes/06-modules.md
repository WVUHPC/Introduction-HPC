---
title: "Environment Modules"
teaching: 15
exercises: 15
questions:
- "How to load modules to access software that I want to use for my research?"
objectives:
- "Learn about *modules*, how to search, load and unload modules"
keypoints:
- Use `module avail` to know all the modules on the cluster.
- Use `module load <module_name>` to load the module that you need.
- You can preload modules for each login by adding the load line on your `$HOME/.bashrc`
---

## Environment Variables

The shell, and many other command line programs uses a set of variables to control their behavior. Those variables are called **Environment Variables**.
Think about them as placeholders for information stored within the system that passes data to programs launched in the shell.

Environment Variables control a big deal of CLI functionality. They declare where to search for executable commands, where to search for libraries, which language display messages to you, how you prompt looks. Beyond the shell itself, Environment Variables are use by many codes to control their own operation.

You can see all the variables currently defined by executing:

~~~
$ env
~~~
{: .language-bash}

Shell variables can be created like

~~~
$ A=10
$ B=20
~~~
{: .language-bash}

Environment variables are shell variables that are exported, ie converted into global variables, the command to do this could be like:

~~~
$ A=10
$ B=20
$ export A
$ export B
~~~
{: .language-bash}

Or simply:

~~~
$ export A=10
$ export B=20
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

Some common environment variables are:

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

## Environment Modules

The modules software package allows you to dynamically modify your user environment by using **modulefiles**.

Each modulefile contains the information needed to configure the shell for an application. After the modules software package is initialized, the environment can be modified on a per-module basis using the module command, which interprets modulefiles. Typically, modulefiles instruct the module command to alter or set shell environment variables such as `PATH`, `MANPATH`, and others. The modulefiles can be shared by many users on a system, and users can have their own collection to supplement or replace the shared modulefiles.

As a user, you can add and remove modulefiles from the current environment. The environment changes contained in a modulefile can also be summarized through the module show command. You are welcome to change modules in your `.bashrc` or `.cshrc`, but be aware that some modules print information (to standard error) when loaded, this should be directed to a file or `/dev/null` when loaded in an initialization script.

## Basic arguments

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

## Modules on Spruce

~~~
$ module avail
~~~
{: .language-bash}
~~~
--------------------------------------------- /usr/share/Modules/modulefiles ---------------------------------------------
dot     modules null    use.own

------------------------------------------------ /usr/share/Modules/tier0 ------------------------------------------------
benchmarks/hpl/2.3_intel18           libraries/arpack-ng/3.6.2_gcc63      libs/hdf5/1.10.5_gcc82
compilers/binutils/2.26              libraries/arpack-ng/3.6.2_gcc82      libs/hdf5/1.10.5_gcc82_ompi4
compilers/cuda/7.5                   libraries/bioconductor/3.2           libs/hdf5/1.10.5_intel19
compilers/gcc/4.9.0                  libraries/boost/1.57.0               libs/hdf5/1.10.5_intel19_impi19
compilers/gcc/5.3.0                  libraries/boost/1.66                 libs/libxc/3.0.0_gcc82
compilers/gcc/6.3.0                  libraries/boost/1.68_gcc63           libs/libxc/4.3.4_gcc82
compilers/gcc/8.2.0                  libraries/boost/1.68_gcc82           libs/libxc/4.3.4_intel19
compilers/idl/8.5.1                  libraries/bupc/2.2                   libs/netcdf/4.x_gcc82
compilers/intel/13.0.1               libraries/DFS/myhadoop               libs/netcdf/4.x_gcc82_ompi4
compilers/intel/14.0                 libraries/fftw/3.3.6_gcc63           libs/netcdf/4.x_intel19
compilers/intel/15.0.1               libraries/gtest/1.7.0                libs/netcdf/4.x_intel19_impi19
compilers/intel/17.0.1               libraries/hdf5/1.10.4_intel19_impi19 libs/openblas/0.2.20_gcc82
compilers/intel/17.0.1_MKL_only      libraries/hdf5/1.8.13_intel          libs/openblas/0.3.5_gcc82
compilers/intel/19.0                 libraries/hdf5/1.8.19_gcc63          libs/openblas/0.3.5_gcc82_broadwell
compilers/intel/python_3.6.5         libraries/jemalloc/3.6.0             libs/openblas/0.3.5_gcc82_haswell
compilers/java/bazel-0.5.2           libraries/libgd/2.2.4                libs/sparskit/2.0_gcc82
compilers/java/jdk1.8.0              libraries/log4cpp/1.1.2              mpi/intel/4.1.0.024
compilers/java/jre1.8.0              libraries/mkl/11.2.1                 mpi/intel/4.1.1.036
compilers/julia/1.0.0                libraries/mkl/4.1.1.036              mpi/intel/5.0.3.048
compilers/python/2.7.13              libraries/openfoam/3.0+              mpi/intel/5.1.3
compilers/ruby/2.2.3                 libraries/petsc/3.9.3_gcc82          mpi/mpich2/1.2.1
compilers/swig/3.0.7                 libraries/Qt/4.7.3                   mpi/mvapich2/2.0.1
dev/cmake/3.9.0                      libraries/Qt/5.5.1                   mpi/mvapich2/2.2.0
dev/oxygen/1.8.15                    libraries/R/Rhipe                    mpi/openmpi/1.6.5
git/2.8.3                            libraries/scons/3.0.1                mpi/openmpi/1.6.5-intel
kitware/cmake/3.9.0                  libraries/sparsehash/2.0.2           mpi/openmpi/1.8.4
lang/gcc/8.2.0                       libraries/suitesparse/5.3_gcc63      mpi/openmpi/2.1.2_gcc63
lang/intel/2018_u4                   libraries/suitesparse/5.3_gcc82      mpi/openmpi/2.1.2_intel17
lang/intel/2019                      libraries/superlu/3.0_gcc63          mpi/ucx/1.3.1
lang/java/jdk1.8.0_201               libraries/superlu/3.0_gcc82          parallel/hwloc/1.11.13_gcc82
lang/pgi/19.4                        libraries/tbb/2018U5_gcc82           parallel/openmpi/3.1.4_gcc44
lang/python/2.7.13_pypy_gcc82        libraries/valgrind/3.13_gcc82        parallel/openmpi/3.1.4_gcc82
lang/python/2.7.15_gcc82             libraries/yices/2.6.0_gcc63          parallel/openmpi/3.1.4_intel18
lang/python/3.5.3_pypy_gcc82         libraries/yices/2.6.0_gcc82          parallel/pvm/3.4
lang/python/3.6.8_gcc82              libs/cuda/9.2                        utils/doxygen
lang/python/3.7.2_gcc82              libs/fftw/3.3.8_gcc82                utils/mc+tmux
lang/R/3.5.2                         libs/fftw/3.3.8_intel19              utils/mercurial
libraries/armadillo/9.100.5_gcc63    libs/fftw3/3.3.8_gcc82               xalt/0.6.0
libraries/armadillo/9.100.5_gcc82    libs/fftw3/3.3.8_intel19

------------------------------------------------ /usr/share/Modules/tier1 ------------------------------------------------
conda             singularity/2.5.1 singularity/2.5.2

------------------------------------------------ /usr/share/Modules/tier2 ------------------------------------------------
ansys/fluids_18.1                    data/cdf/3.5.0.2                     genomics/pindel/0.2.5b1
ansys/structures_18.1                data/mongodb/4.0                     genomics/pindel/0.2.5b8
astronomy/casa/5.3.0                 data/sqlite/3.9.2                    genomics/plink
atomistic/abinit/8.10.2_intel18      engineering/damask/2.0.1             genomics/qiime
atomistic/abinit/8.4.2_intel17       engineering/damask/2.0.1_petsc364    genomics/repeatexplorer
atomistic/dftbplus/18.1              genomics/abyss/2.1.0                 genomics/repeatmasker
atomistic/elk/5.2.14_intel18         genomics/allpaths                    genomics/rsem
atomistic/espresso/6.4_intel19_seq   genomics/beagle                      genomics/samtools/0.1.19
atomistic/espresso/6.4_intel19_thd   genomics/bedtools                    genomics/samtools/1.2
atomistic/gromacs/2016.3             genomics/bioconda                    genomics/sga
atomistic/gromacs/2016.3_serial      genomics/bioperl                     genomics/shapeit
atomistic/gromacs/2016.4             genomics/blasr                       genomics/sickle
atomistic/gromacs/2016.6             genomics/blast/2.2.28                genomics/sratoolkit/2.9.2
atomistic/gromacs/2019.3             genomics/blast/2.3.0                 genomics/stringtie/1.3.4
atomistic/lammps/2016.11.17          genomics/bowtie                      genomics/structure
atomistic/lammps/2017.08.11          genomics/bowtie2/2.3.4               genomics/svseq
atomistic/lammps/2018.03.16          genomics/breakdancer                 genomics/tabix
atomistic/lammps/2019.06.05          genomics/canu/1.7                    genomics/tablet
atomistic/namd/2018-04-26            genomics/celera                      genomics/tophat2
atomistic/namd/2.12                  genomics/clumpp                      genomics/trf
atomistic/namd/2.12_iverbs           genomics/cufflinks/2.2.1             genomics/trinity/2.0.6
atomistic/octopus/9.0_gcc82          genomics/delly                       genomics/trinity/2.2.0
atomistic/vasp/5.3.3_intel17         genomics/diamond                     genomics/vcflib
atomistic/vasp/5.4.4_intel17         genomics/distruct                    genomics/vcftools/0.1.14
atomistic/vasp/5.4.4_intel17_ompi212 genomics/dwgsim                      gnu/coreutils
cfd/ansys/14.5.7                     genomics/eigensoft                   gnu/parallel
cfd/ansys/forte/17.2                 genomics/errcorr_tools               mae/cmg/2014.10
cfd/converge/2.4.12                  genomics/express                     mae/cmg/2015.10
cfd/converge/2.4.21                  genomics/falcon                      mae/cmg/2017.10
chemistry/amber/12                   genomics/falcon_171012               mae/elk/2.2.10
chemistry/amber/14                   genomics/fasta36                     mae/elk/2.3.16
chemistry/amber/16                   genomics/fastqc/0.11.7               math/dakota/6.10
chemistry/autodock_vina              genomics/fastx_toolkit               math/dakota/6.10-UI
chemistry/gamess                     genomics/gatk/4.0                    math/dakota/6.8
chemistry/gaussian/g03               genomics/genometools                 math/dakota/6.8-UI
chemistry/gaussian/g09               genomics/genomics-core               math/gams/26.1
chemistry/gromacs/4.6.5              genomics/hmmer                       statistics/matlab/2018a
chemistry/gromacs/5.0.5              genomics/htslib                      statistics/rstudio/0.97.551
chemistry/gromacs/5.0.5-gpu          genomics/igv                         visualization/graphviz/2.40_gcc82
chemistry/gromacs/5.1.2              genomics/lastz                       visualization/paraview
chemistry/gromacs/5.1.2-gpu          genomics/ltrfinder                   visualization/visit/2.10
chemistry/namd/ibverbs/2.10          genomics/mmseqs2                     visualization/visit/2.10.2
chemistry/namd/ibverbs/2.11          genomics/mrsfast                     visualization/visit/2.12.2
chemistry/namd/ibverbs/2.9           genomics/pbdagcon                    visualization/visit/2.12.3
chemistry/namd/mpi                   genomics/phase                       visualization/vtk/7.0.0
chemistry/orca                       genomics/phrap
chemistry/schrodinger                genomics/picard-tools

------------------------------------------------ /usr/share/Modules/tier3 ------------------------------------------------
environment/gcc-mpi    environment/gcc-serial environment/intel      null
~~~
{: .output}

## Creating a private repository

The basic procedure is to locate modules on a folder accessible by relevant users and add the variable `MODULEPATH` to your `.bashrc`

`MODULEPATH` controls the path that the module command searches when looking for
modulefiles.  
Typically, it is set  to a  default  value by the bootstrap procedure.  
`MODULEPATH` can be set using ’module use’ or by the module initialization
script to search group or personal modulefile directories before  or  after
the master modulefile directory.


> ## Exercise: Using modulefiles
>
> 1. Check the modules that you currently have and clean (purge) your environment from them. Check again and confirm that no module is loaded.
>
> 2. Check which versions of Python, R and GCC you have from the RHEL itself. Try to get and idea of how old those three components are. For python and R all that you have to do is enter the corresponding command (`R` or `python`). For GCC you need to use `gcc --version` and see the date of those programs.
>
> 3. Now lets get newer version of those 3 components by loading the corresponding modules. Search for the module for Python 3.7.2 and R 3.4.1 and GCC 8.2.0 and load the corresponding modules. To make things easier, you can use check the availability of modules just in the languages section.
>
>    ~~~
>    module avail lang
>    ~~~
>    {: .source}
>
>
> 4. Check again which version of those 3 components you have now. Notice that in the case of Python 3, the command python still goes towards the old python 2.6.6, as the python 3.x interpreter is not backwards compatible with python 2.x the new command is called `python3`, check its version by entering the command.
>
> 5. Clean all of the environment
>
>    ~~~
>    module purge
>    ~~~
>    {: .source}
>
> 6. Go back and purge all the modules from your environment. We will now explore why it is important to use a recent compiler. Try to compile the code at `1.Intro-HPC/05.modules/lambda_c++14.cpp`. Go to the folder and execute:
>
>    ~~~
>    g++ lambda_c++14.cpp
>    ~~~
>    {: .source}
>
>
>    At this point you should have received a list of errors, that is because even if the code is C++ it uses elements of the language that were not present at that time on C++ Specification. The code actually uses C++14 and only recent versions of GCC allows for these declarations. Lets check how many GCC compilers we have available on Spruce.
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

{% include links.md %}
