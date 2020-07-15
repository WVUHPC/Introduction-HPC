---
title: "Job Submission and scheduling: Torque/Moab"
teaching: 30
exercises: 30
questions:
- "How to submit jobs on the HPC cluster?"
objectives:
- "Learn the most frequently used commands for Torque and Moab"
keypoints:
- "It is a good idea to keep aliases to common torque commands for easy execution."
---

When you are using your own computer, you execute your calculations and you are responsible of not overloading the machine with more workload that the machine can actually process efficiently. Also, you probably have only one machine to work, if you have several you login individually on each and execute calculations by directly running calculations.

On a shared resource like an HPC cluster, things are very different. You and several others, maybe hundreds are competing for getting their calculations done. A Resource Manager take care of receiving job submissions. From the other side a Job Scheduler is in charge of associate jobs with the appropriated resources and trying to maximize and objective function such as total utilization constrained by priorities and the best balance between the resources requested and resources available.

# TORQUE Resource and Queue Manager

Terascale Open-source Resource and QUEue Manager (TORQUE) is a distributed resource manager providing control over batch jobs and distributed compute nodes. TORQUE can be integrated both, commercial and non-commercial Schedulers. In the case of Mountaineer and Spruce TORQUE is used with the commercial Moab Scheduler.

This is a list of TORQUE commands:

|Command	  |Description|
|:----------|:----------|
|`momctl`	  |Manage/diagnose MOM (node execution) daemon|
|`pbsdsh`	  |Launch tasks within a parallel job|
|`pbsnodes`	|View/modify batch status of compute nodes|
|`qalter`	  |Modify queued batch jobs|
|`qchkpt`	  |Checkpoint batch jobs|
|`qdel`	    |Delete/cancel batch jobs|
|`qgpumode`	|Specifies new mode for GPU|
|`qgpureset`|Reset the GPU|
|`qhold`	  |Hold batch jobs|
|`qmgr`	    |Manage policies and other batch configuration|
|`qmove`	  |Move batch jobs|
|`qorder`	  |Exchange order of two batch jobs in any queue|
|`qrerun`	  |Rerun a batch job|
|`qrls`	    |Release batch job holds|
|`qrun`	    |Start a batch job|
|`qsig`	    |Send a signal to a batch job|
|`qstat`	  |View queues and jobs|
|`qsub`	    |Submit jobs|
|`qterm`	  |Shutdown pbs server daemon|
|`tracejob`	|Trace job actions and states recorded in Torque logs (see Using "tracejob" to Locate Job Failures)|

From those commands, a basic knowledge about `qsub`, `qstat` and `qdel` is suficient for most purposes on a normal usage of the cluster.

TORQUE includes numerous directives, which are used to specify resource
requirements and other attributes for batch and interactive jobs.
TORQUE directives can appear as header lines (lines that start with #PBS)
in a batch job script or as command-line options to the `qsub` command.

## Submission scripts

A TORQUE job script for a serial job might look like this:

~~~
#!/bin/bash
#PBS -k o
#PBS -l nodes=1:ppn=1,walltime=00:30:00
#PBS -M username@mix.wvu.edu
#PBS -m abe
#PBS -N JobName
#PBS -j oe
#PBS -q standby

cd $PBS_O_WORKDIR
./a.out
~~~
{: .source}

The following table describes the most basic directives

| TORQUE directive	| Description |
|:------------------|:------------|
|#PBS -k o	| Keeps the job output |
|#PBS -l nodes=1:ppn=1,walltime=00:30:00	| Indicates the job requires one node, one processor per node, and 30 minutes of wall-clock time |
|#PBS -M username@mix.wvu.edu	| Sends job-related email to username@mix.wvu.edu |
|#PBS -m abe	| Sends email if the job is (a) aborted, when it (b) begins, and when it (e) ends |
|#PBS -N JobName	| Names the job JobName |
|#PBS -j oe	| Joins standard output and standard error |
|#PBS -q standby | Submit the job on the standby queue |

A parallel job using MPI could be like this:

~~~
#!/bin/bash
#PBS -k o
#PBS -l nodes=1:ppn=16,walltime=30:00
#PBS -M username@mix.wvu.edu
#PBS -m abe
#PBS -N JobName
#PBS -j oe
#PBS -q standby

cd $PBS_O_WORKDIR
mpirun -np 16 -machinefile $PBS_NODEFILE ./a.out
~~~
{: .source}

The directives are very similar to the serial case

| TORQUE directive	| Description |
|:------------------|:------------|
|#PBS -l nodes=1:ppn=16,walltime=00:30:00	| Indicates the job requires one node, using 16 processors per node, and 30 minutes of runtime. |

> ## Exercise: Creating a Job script and submit it
>
> On `1.Intro-HPC/07.jobs` you will find the same 3 ABINIT files that we worked on the Command Line Interface episode. The exercise is to prepare a submission script for computing the calculation. This is all that you need to know:
>
> 1. You need to load the these modules to use ABINIT
>    ~~~
>    module load compilers/gcc/6.3.0 mpi/openmpi/2.1.2_gcc63 libraries/fftw/3.3.6_gcc63 compilers/intel/17.0.1_MKL_only  atomistic/abinit/8.6.3_gcc63
>    ~~~
>    {: .bash}
>
>    It is good idea to purge the modules first to avoid conflicts with the modules that you probably are loading by default.
>
> 2. ABINIT works in parallel using MPI, for this exercise lets request 4 cores on a single node. The actual command to be executed is:
>    ~~~
>    mpirun -np 4 abinit < t17.files
>    ~~~
>    {: .bash}
>
>    Assuming that you have moved into the folder that has the 3 files.
>
>{: .source}
{: .challenge}

## Job Arrays

Job array is a way to submit many jobs that can be indexed. The jobs are
independent between them but you can submit them with a single qsub

~~~
#!/bin/sh

#PBS -N <jobname>_${PBS_ARRAYID}
#PBS -t <num_range>
#PBS -l nodes=<number_of_nodes>:ppn=<PPN number>,walltime=<time_needed_by_job>
#PBS -m ae
#PBS -M <email_address>
#PBS -q <queue_name>
#PBS -j oe

cd $PBS_O_WORKDIR
# Enter the command here
mpirun -np <PPN number> ./a.out
~~~
{: .source}

There a few new elements here: `${PBS_ARRAYID}`  is a variable that receives one different value for each job in the range described from the `-t` variable.
`#PBS -j oe` is an option often used for job arrays, it merges the standard output and error files in a single file, avoiding the overload of files for large job arrays.

> ## Exercise: Job arrays
>
> Using the same 3 files from our previous exercise, prepare a set of 5 folders called `1`, `2`, `3`, `4` and `5`. The file `14si.pspnc` is better as a symbolic link as that file will never change.
>
>> ## Solution
>>
>>  ~~~
>>  $ mkdir 1 2 3 4 5
>>  $ cp t17.* 1
>>  $ cp t17.* 2
>>  $ cp t17.* 3
>>  $ cp t17.* 4
>>  $ cp t17.* 5
>>  $ ln -s ../14si.pspnc 1/14si.pspnc
>>  $ ln -s ../14si.pspnc 2/14si.pspnc
>>  $ ln -s ../14si.pspnc 3/14si.pspnc
>>  $ ln -s ../14si.pspnc 4/14si.pspnc
>>  $ ln -s ../14si.pspnc 5/14si.pspnc
>>  ~~~
>>  {: .bash}
> {: .solution}
>
> Modify the submission script from the previous exercise to create a job array.
> When executed, each job in the array receives a different value inside `${PBS_ARRAYID}`, we use the value to go into the corresponding folder and execute ABINIT there.
>
>> ## solution
>>
>> ~~~
>> #!/bin/bash
>>
>> #PBS -N ABINIT_${PBS_ARRAYID}
>> #PBS -l nodes=1:ppn=4
>> #PBS -q debug
>> #PBS -t 1-5
>> #PBS -j oe
>>
>> module purge
>> module load compilers/gcc/6.3.0 mpi/openmpi/2.1.2_gcc63 libraries/fftw/3.3.6_gcc63 compilers/intel/17.0.1_MKL_only  atomistic/abinit/8.6.3_gcc63
>>
>> cd $PBS_O_WORKDIR
>> cd ${PBS_ARRAYID}
>>
>> mpirun -np 4 abinit < t17.files
>> ~~~
>> {: .bash}
> {: .solution}
>
>{: .source}
{: .challenge}


## Environment variables

We are using PBS_O_WORKDIR to change directory to the place where the job was submitted
The following environment variables will be available to the batch job.

| Variable | Description |
|:---------|:------------|
|PBS_O_HOST| the name of the host upon which the qsub command is running. |
|PBS_SERVER| the hostname of the pbs_server which qsub submits the job to. |
|PBS_O_QUEUE | the name of the original queue to which the job was submitted. |
|PBS_O_WORKDIR | the absolute path of the current working directory of the qsub command. |
|PBS_ARRAYID | each member of a job array is assigned a unique identifier (see -t) |
|PBS_ENVIRONMENT | if set to PBS_BATCH is a batch job, if set to PBS_INTERACTIVE is an interactive job. |
|PBS_JOBID| the job identifier assigned to the job by the batch system. |
|PBS_JOBNAME| the job name supplied by the user. |
|PBS_NODEFILE| the name of the file contain the list of nodes assigned to the job (for parallel and cluster systems). |
|PBS_QUEUE| the name of the queue from which the job is executed. |

## Montioring jobs

To monitor the status of a queued or running job, use the qstat command from Torque
of showq from Moab.

Useful qstat options include:

| qstat option |	Description |
|:-------------|:-------------|
|-Q |show all queues available |
|-u user_list	| Displays jobs for users listed in user_list |
|-a	| Displays all jobs |
|-r	| Displays running jobs |
|-f	| Displays the full listing of jobs (returns excessive detail) |
|-n	| Displays nodes allocated to jobs |

Moab showq offers:

| showq option |	Description |
|:-------------|:-------------|
| -b	| blocked jobs only |
| -c	| details about recently completed jobs. |
| -g	| grid job and system id's for all jobs. |
| -i	| extended details about idle jobs. |
| -l	| local/remote view. For use in a Grid environment, displays job usage of both local and remote compute resources.
| -n	| normal showq output, but lists job names under JOBID |
| -o	| jobs in the active queue in the order specified (uses format showq -o <specifiedOrder>). Valid options include REMAINING, REVERSEREMAINING, JOB, USER, STATE, and STARTTIME. The default is REMAINING. |
| -p	| only jobs assigned to the specified partition. |
| -r	| extended details about active (running) jobs.  |
| -R	| only jobs which overlap the specified reservation. |
| -u	| specified user's jobs. Use showq -u -v to display the full username if it is truncated in normal -u output. |
| -v	| local and full resource manager job IDs as well as partitions. |
| -w	| only jobs associated with the specified constraint. Valid constraints include user, group, acct, class, and qos. |

## Deleting jobs

With Torque you can use `qdel`. Moab uses `mjobctl -c`. For example:

~~~
$ qdel 1045
~~~
{: .bash}

~~~
$ mjobctl -c 1045
~~~
{: .bash}

## Prologue and Epilogue

Torque provides administrators the ability to run scripts before and/or after each job executes. With such a script, you can prepare the system, perform node health checks, prepend and append text to output and error log files, cleanup systems, and so forth.

You can add prologue and epilogue scripts from the command line.

~~~
$ qsub -l prologue=/home/user/prologue.sh,epilogue=/home/user/epilogue.sh
~~~
{: .bash}

or adding the corresponding lines on your submission script.

~~~
#!/bin/bash
...
#PBS -l prologue=/home/user/prologue.sh
#PBS -l
...
~~~
{: .bash}

A simple `prologue.sh` can be like this:

~~~
#!/bin/sh

echo "Prologue Args:"
echo "Job ID: $1"
echo "User ID: $2"
echo "Group ID: $3"
echo ""

exit 0
~~~
{: .bash}

And a simple epilogue can be like:

~~~
#!/bin/sh

echo "Epilogue Args:"
echo "Job ID: $1"
echo "User ID: $2"
echo "Group ID: $3"
echo "Job Name: $4"
echo "Session ID: $5"
echo "Resource List: $6"
echo "Resources Used: $7"
echo "Queue Name: $8"
echo "Account String: $9"
echo ""

exit 0
~~~
{: .bash}


The purpose of the scripts above is to provide information about the job being stored in the same file as the standard output file created for the job. That is very useful if you want to adjust resources based on previous executions and the epilogue will store the information on file.


The prologue is also useful, it can check if the proper environment for the job is present and based on the return of that script indicate Torque if the job should continue for execution, resubmit it or cancel it. The following table describes each exit code for the prologue scripts and the action taken.



|Error	  |Description |Action|
|:--------|:-----------|:-----|
|-4	|The script timed out	              |Job will be requeued|
|-3	|The wait(2) call returned an error	|Job will be requeued|
|-2	|Input file could not be opened	    |Job will be requeued|
|-1	|Permission error (script is not owned by root, or is writable by others) |Job will be requeued|
|0	|Successful completion	            |Job will run|
|1	|Abort exit code	                  |Job will be aborted|
|>1	|other	                            |Job will be requeued|




> ## Exercise: Prologue and Epilogue arrays
>
> Add prologue and epilogue to the job array from the previous exercise
>
{: .challenge}


## Interactive jobs with X11 Forwarding

Sometimes you need to do some interactive job to create some plots and we would like to see the figures on the fly rather than, bring all the data back to the desktop, this example shows how to achieve that.

~~~
$ ssh -Y username@spruce.hpc.wvu.edu
~~~
{: .bash}

Test the X11 Forwarding

~~~
$ xeyes
~~~
{: .bash}

A windows should appear with two eyes facing you, you can close the window and create a new session with `qsub`

~~~
$ qsub -X -I
~~~
{: .bash}

After you get a new session and test it again with `xeyes`​. This new eyes comes from the compute node, not from the head node.

~~~
$ xeyes
~~~
{: .bash}

Lets suppose that the plot will be created with R, load the module for R 3.4.1 (the latest version by the time this was written)

~~~
$ module load compilers/R/3.4.1
~~~
{: .bash}

Enter in the text-based R interpreter

~~~
$ R
~~~
{: .bash}

Test a simple plot in R

~~~
> # Define the cars vector with 5 values
> cars <- c(1, 3, 6, 4, 9)
>

> # Graph the cars vector with all defaults
> plot(cars)
>
~~~
{: .source}

You should get a new window with a plot and a few points.
On the episode about Singularity we will see some other packages that use the X11 server like RStudio and Visit.

{% include links.md %}
