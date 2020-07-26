---
title: "Software Containers: Singularity"
teaching: 30
exercises: 30
questions:
- "What are software containers and how to use them?"
objectives:
- "Learn about singularity containers, both using and creating images."
keypoints:
- "Singularity containers give you control on the software you want on a machine, helping you with reproducible executions."
---

Containers are a software technology that allows us to keep control of the environment where a given code runs. Consider for example that you want to run a code in such a way the same code runs on several machines or clusters ensuring that the same libraries are loaded and the same general environment is present. Different clusters could come installed with different compilers, different Linux distributions and different libraries in general. Containers can be used to package entire scientific workflows, software and libraries, and even data and move them to several compute infrastructures with complete reproducibility.

Containers are similar to Virtual Machines, however, the differences are enough to consider them different technologies and those differences are very important for HPC. Virtual Machines takes up a lot of system resources. Each Virtual Machine (VM) runs not just a full copy of an operating system, but a virtual copy of all the hardware that the operating system needs to run. This quickly adds up to a lot of precious RAM and CPU cycles, valuable resources for HPC.

In contrast, all that a container requires is enough of an operating system, supporting programs and libraries, and system resources to run a specific program. From the user perspective, a container is in most cases a single file that contains the file system, ie a rather complete Unix filesystem tree with all libraries, executables, and data that are needed for a given workflow or scientific computation.

There are several container solutions, the most popular probably is Docker, however, the main issue with using docker on HPC is security, despite the name, containers do not actually contain the powers of the user who executes code on them. That is why you do not see Docker installed on an HPC cluster. Using dockers requires superuser access something that on shared resources like an HPC cluster is not typically possible.

Singularity offers an alternative solution to Docker, users can run the prepared images that we are offering on our clusters or bring their own.

For more information about Singularity and complete documentation see: https://singularity.lbl.gov/quickstart

## How to use a singularity Image

There are basically two scenarios, interactive execution and job submission.

### Interactive Job

If you are using Visit or RStudio, programs that uses the X11 forwarding, ensure to connect first to the cluster with X11 forwarding, before asking for an interactive job.
In order to connect into Spruce with X11 forwarding use:

~~~
ssh -X <username>@spruce.hpc.wvu.edu
~~~
{: .source}


Once you have login into the cluster, create an interactive job with the following command line, in this case we are using standby as queue but any other queue is valid.

~~~
qsub -X -I -q standby
~~~
{: .source}


Once you get inside a compute node, load the module:

~~~
module load singularity/2.5.2
~~~
{: .source}


After loading the module the command singularity is available for usage, and you can get a shell inside the image with:

~~~
singularity shell /shared/software/containers/<Image Name>
~~~
{: .source}


### Job Submission

In this case you do not need to export X11, just login into Spruce

~~~
ssh <username>@spruce.hpc.wvu.edu
~~~
{: .source}


Once you have login into the cluster, create a submission script ("runjob.pbs" for this example), in this case we are using standby as queue but any other queue is valid.

~~~
#!/bin/sh

#PBS -N JOB
#PBS -l nodes=1:ppn=1
#PBS -l walltime=04:00:00
#PBS -m ae
#PBS -q standby

module load singularity/2.5.1

singularity exec /shared/software/containers/<Image Name> <command_or_script_to_run>
~~~
{: .source}


Submit your job with

~~~
qsub runjob.pbs
~~~
{: .source}

> ## Exercise 1: Using singularity on the cluster (Interactive)
>
> This exercise propose the use of singularity to access RStudio 1.1 and R 3.4.4
>
> Follow the instructions for accessing an interactive session
>
> The image is located at:
>
> ~~~
> /shared/software/containers/RStudio-desktop-1.1.442_R-3.4.4.simg
> ~~~
> {: .source}
> Be sure that you can execute basic R commands. You can get an error message like:
>
>>   WARNING: You are configured to use the CRAN mirror at https://cran.rstudio.com/. This mirror supports secure (HTTPS) downloads however your system is unable to communicate securely with the server (possibly due to out of date certificate files on your system). Falling back to using insecure URL for this mirror.
>
> That is normal and due to the fact that compute nodes have no Internet access.
>
{: .challenge}

> ## Exercise 2: Using singularity on the cluster (Non-interactive)
>
> Create a script that reads a CSV with official statistics of population for US. The file can be downloaded from:
>~~~
>$ wget https://www2.census.gov/programs-surveys/popest/datasets/2010-2018/state/detail/SCPRC-EST2018-18+POP-RES.csv
>~~~
>{: .source}
>
> However, the file is also present in the repository for hands-ons
>~~~
>$ git clone git@github.com:WVUHPC/Introduction-HPC_Data.git
>~~~
>{: .language-bash}
>
>The folder is `Introduction-HPC_Data/08-singularity`. If you are not familiar with R programming, the script is there too. Notice that you cannot write your script to download the CSV file directly from the Census Bureau as the compute  nodes have no Internet access.
> Write a submission script and submit.
>
{: .challenge}

## Creating your own images

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
