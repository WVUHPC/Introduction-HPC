#!/bin/sh

#This is an example script for executing generic jobs with 
# the use of the command 'qsub <name of this script>'


#These commands set up the Grid Environment for your job.  Words surrounding by a backet ('<','>') should be changed
#Any of the SBATCH directives can be commented out by placing another pound sign in front
#example
##SBATCH -J name
#The above line will be skipped by qsub because of the two consecutive # signs 

# Specify job name
#SBATCH -J induced_spin

# Specify the resources need for the job
##PBS -l nodes=4:ppn=1:ivy,walltime=4:00:00,pvmem=54gb
#SBATCH --nodes=4 --ntasks-per-node=4 --mem=54G -t 10080

#  CCTK_Proc0-$PBS_JOBID.err
#SBATCH -e error.txt
#SBATCH -o output.txt
#  CCTK_Proc0-$PBS_JOBID.out

# Specify the queue to execute task in. Current options can be found by excuting the command qstat -q at the terminal
#SBATCH -p comm_small_week

module load lang/gcc/9.3.0
module load parallel/openmpi/4.1.6_gcc93
#module load libs/hdf5/1.14.3_intel21/impi21
module load astronomy/etk/ET_2021_11

which mpirun

cd $HOME
rm -f hostfile 
touch hostfile
echo $SLURM_JOB_NODELIST
###sort -u 
##echo $SLURM_JOB_NODELIST >> hostfile.$SLURM_JOBID

# get number of MPI processes 
#export NPROCS=`wc -l hostfile | awk ' { print $1 } '`h
export NPROCS=16  # This is total MPI processes so if 2 nodes and 4 MPI processes per node this variable will be 8

# Enter your command below with arguments just as if you where going to execute on the command line
# It is generally good practice to issue a 'cd' command into the directory that contains the files
# you want to use or use full path names
cd $SLURM_SUBMIT_HOST

####OMP_NUM_THREADS=16 mpirun -envall -n $NPROCS -machinefile $HOME/hostfile.$PBS_JOBID ./cactus_etilgrmhdold -reo ml-lr.par
##-machinefile $HOME/hostfile.$SLURM_JOBID 
OMP_NUM_THREADS=16 mpirun -x PATH -x LIBRARY_PATH -x LD_LIBRARY_PATH -n $NPROCS cactus_sim /users/penelson/Introduction-HPC/DiffEq-Workshop/shooting_blackholes/Shooting_BlackHoles_using_TwoPunctures_theta_5.5000e-02__vel_9.8000e-01__sepRadius_5.0000e+01.par-mr
