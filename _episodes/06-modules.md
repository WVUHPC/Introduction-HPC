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

**Environment Variables** control CLI functionality. They declare where to search for executable commands, where to search for libraries, which language display messages to you, how you prompt looks. Beyond the shell itself, Environment Variables are use by many codes to control their own operation.

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
> 6. Go back and purge all the modules from your environment. We will now explore why it is important to use a recent compiler. Try to compile the code at `Introduction-HPC_Data/06-modules/lambda_c++14.cpp`. Go to the folder and execute:
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

## Reference: Modules on the clusters

This is the list of all modules on Thorny Flat on July 2020.

| TIER 0 | TIER 1 | TIER 2 |
|-|-|-|
| benchmarks/hpl/2.3_gcc48<br>benchmarks/hpl/2.3_gcc82<br>dev/cmake/3.15.2<br>dev/cmake/3.15.4<br>dev/doxygen/1.8.15<br>lang/gcc/7.5.0<br>lang/gcc/8.2.0<br>lang/gcc/8.4.0<br>lang/gcc/9.3.0<br>lang/go/1.12.7<br>lang/intel/2018<br>lang/intel/2018_u4<br>lang/intel/2019<br>lang/intel/2019_u5<br>lang/java/jdk1.8.0_201<br>lang/julia/1.1.1<br>lang/julia/1.2.0<br>lang/pgi/19.10<br>lang/pgi/19.4<br>lang/python/cpython_3.6.9_gcc82<br>lang/python/cpython_3.7.2_gcc82<br>lang/python/cpython_3.7.4_gcc82<br>lang/python/intelpython_2.7.14<br>lang/python/intelpython_2.7.16<br>lang/python/intelpython_3.6.3<br>lang/python/intelpython_3.6.9<br>lang/python/pypy2.7-7.1.1-portable<br>lang/python/pypy3.6-7.1.1-portable<br>lang/python/pypy3.6-v7.1.1-thorny<br>lang/r/3.5.2<br>lang/r/3.6.2<br>libs/atompaw/4.1.0.5_gcc48<br>libs/atompaw/4.1.0.5_intel18<br>libs/boost/1.70_gcc48_ompi216<br>libs/boost/1.70_gcc82_ompi216<br>libs/boost/1.70_intel18<br>libs/boost/1.73<br>libs/cfitsio/3.47_gcc82<br>libs/eigen/3.3.7<br>libs/fftw/3.3.8_gcc48<br>libs/fftw/3.3.8_gcc75<br>libs/fftw/3.3.8_gcc75_ompi3.1.6<br>libs/fftw/3.3.8_gcc82<br>libs/fftw/3.3.8_gcc82b<br>libs/fftw/3.3.8_gcc82_ompi4<br>libs/fftw/3.3.8_gcc84<br>libs/fftw/3.3.8_gcc84_ompi3.1.6<br>libs/fftw/3.3.8_gcc93<br>libs/fftw/3.3.8_gcc93_ompi3.1.6<br>libs/fftw/3.3.8_intel18<br>libs/gmp/6.2.0<br>libs/hdf5/1.10.5_gcc48<br>libs/hdf5/1.10.5_gcc48_ompi31<br>libs/hdf5/1.10.5_gcc82<br>libs/hdf5/1.10.5_gcc82_ompi31<br>libs/hdf5/1.10.5_intel18<br>libs/hdf5/1.10.5_intel18_impi18<br>libs/hdf5/1.10.5_intel19<br>libs/hdf5/1.10.5_intel19_impi19<br>libs/hdf5/1.10.6_gcc82_ompi31<br>libs/hdf5/1.12.0_gcc75<br>libs/hdf5/1.12.0_gcc75_ompi31<br>libs/hdf5/1.12.0_gcc84<br>libs/hdf5/1.12.0_gcc84_ompi31<br>libs/hdf5/1.12.0_gcc93<br>libs/hdf5/1.12.0_gcc93_ompi31<br>libs/libpsml/1.1.7_gcc82<br>libs/libxc/3.0.1_gcc48<br>libs/libxc/3.0.1_gcc82<br>libs/libxc/3.0.1_intel18<br>libs/libxc/4.2.3_intel18<br>libs/libxc/4.3.4_gcc82<br>libs/libxc/4.3.4_intel18<br>libs/magma/2.5.1_gcc48<br>libs/netcdf/4.1.1_gcc48<br>libs/netcdf/4.7.1_gcc82<br>libs/netcdf/4.7.1_intel18<br>libs/netcdf/4.7.1_intel19<br>libs/netcdf/4.x_gcc48<br>libs/netcdf/4.x_gcc48_ompi2<br>libs/netcdf/4.x_gcc82<br>libs/netcdf/4.x_gcc82_ompi4<br>libs/netcdf/4.x_intel18<br>libs/netcdf/4.x_intel18_impi18<br>libs/netcdf/fortran-4.5.2_intel18<br>libs/netlib/3.8.0_gcc82<br>libs/netlib/3.8.0_intel18<br>libs/openblas/0.3.5_gcc48<br>libs/openblas/0.3.5_gcc82<br>libs/openblas/0.3.7_gcc82<br>libs/openblas/0.3.9_gcc75<br>libs/openblas/0.3.9_gcc84<br>libs/openblas/0.3.9_gcc93<br>libs/refblas/3.8_gcc82<br>libs/suitesparse/5.4.0_gcc82<br>libs/swig/4.0.1_gcc82<br>libs/xmlf90/1.5.4_gcc48<br>libs/xmlf90/1.5.4_gcc82<br>libs/yaml/0.2.2_gcc82<br>libs/zeromq/4.3.1_gcc82<br>parallel/cuda/10.0.130<br>parallel/hwloc/1.10.1_gcc48<br>parallel/hwloc/1.10.1_gcc82<br>parallel/hwloc/1.10.1_intel18<br>parallel/hwloc/1.11.13_gcc82<br>parallel/hwloc/2.0.3_gcc82<br>parallel/hwloc/2.0.3_intel18<br>parallel/impi/2017<br>parallel/mpich/3.3_gcc82<br>parallel/mvapich2/2.3.1_gcc82<br>parallel/openmpi/2.1.2_gcc48<br>parallel/openmpi/2.1.6_gcc48<br>parallel/openmpi/2.1.6_gcc82<br>parallel/openmpi/2.1.6_intel18<br>parallel/openmpi/3.1.4_gcc48<br>parallel/openmpi/3.1.4_gcc82<br>parallel/openmpi/3.1.4_intel18<br>parallel/openmpi/3.1.6_gcc75<br>parallel/openmpi/3.1.6_gcc84<br>parallel/openmpi/3.1.6_gcc93<br>parallel/ucx/1.5.0_gcc82<br>utils/tmux/3.0a | conda<br>matlab/2018b<br>singularity/2.5.2 | ansys/fluids_19.2<br>astronomy/casa/5.3.0<br>astronomy/casa/5.4.1<br>astronomy/casa/5.6.0<br>atomistic/abinit/8.10.2_intel18<br>atomistic/abinit/8.10.3_gcc82<br>atomistic/abinit/8.10.3_gcc82_mpiio<br>atomistic/abinit/8.10.3_intel18<br>atomistic/abinit/9.0.4_gcc82<br>atomistic/amber/18_cuda<br>atomistic/amber/18_mpi<br>atomistic/amber/18_openmp<br>atomistic/elk/5.2.14_intel18<br>atomistic/espresso/6.4_intel18_seq<br>atomistic/espresso/6.4_intel18_thd<br>atomistic/gaussian/g16<br>atomistic/gaussian/g16_rev1<br>atomistic/gromacs/2016.6<br>atomistic/gromacs/2016.6_cuda<br>atomistic/gromacs/2016.6_gcc48_cuda<br>atomistic/gromacs/2016.6_gcc82<br>atomistic/gromacs/2016.6_plumed_gcc82<br>atomistic/gromacs/2018.8_gcc82<br>atomistic/gromacs/2018.8_plumed_gcc82<br>atomistic/gromacs/2019.3<br>atomistic/gromacs/2019.3_gcc48_cuda<br>atomistic/gromacs/2019.4<br>atomistic/gromacs/2019.4_double<br>atomistic/gromacs/2019.4_gcc82<br>atomistic/gromacs/2019.4_plumed_gcc82<br>atomistic/gromacs/5.1.5_cuda<br>atomistic/lammps/2018-12-12_gcc82<br>atomistic/lammps/2018-12-12_gcc82_ompi2<br>atomistic/lammps/2019.06.05<br>atomistic/lammps/2019.08.07_gcc82_ompi31<br>atomistic/lammps/2019.08.07_intel19_impi19<br>atomistic/namd/2.13_CPU<br>atomistic/namd/2.13_CUDA<br>atomistic/namd/NAMD_Git-2020-01-02-mpi<br>atomistic/namd/NAMD_Git-2020-01-02-mpi-smp<br>atomistic/namd/NAMD_Git-2020-01-02-ofi<br>atomistic/namd/NAMD_Git-2020-01-02-ofi-smp<br>atomistic/octopus/9.1_gcc82<br>atomistic/octopus/9.1_gcc82_ompi31<br>atomistic/orca/4.2.1_ompi216<br>atomistic/orca/4.2.1_ompi314<br>atomistic/plumed/2.5.3_gcc82<br>atomistic/siesta/4.0.2_intel18<br>atomistic/siesta/4.0.2_intel19<br>atomistic/vasp/5.4.4_intel18_seq<br>atomistic/vasp/5.4.4_intel18_thd<br>atomistic/vasp/5.4.4_intel19_seq<br>atomistic/vasp/5.4.4_intel19_thd<br>bioinformatics/emboss/6.6.0<br>bioinformatics/gatk/4.1.0<br>data/hdfview/3.1.0<br>math/dakota/6.10<br>math/dakota/6.10-UI<br>math/dakota/6.8<br>math/dakota/6.8-UI<br>math/gams/26.1<br>visual/graphviz/2.40.1_gcc82<br>visual/paraview/5.6.0<br>/shared/modulefiles/tier3:<br>general_gcc82<br>general_intel18<br>jupyter_kernels<br>r/3.5.2<br>r/3.6.2 |
|  |  |  |


{% include links.md %}
