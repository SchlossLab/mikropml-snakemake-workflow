#!/bin/bash
#SBATCH --job-name=mikropml # sbatch options here only affect the overall job
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=100MB
#SBATCH --time=96:00:00
#SBATCH --output=log/hpc/slurm-%j_%x.out 
#SBATCH --account=YOUR_ACCOUNT_HERE      # your account name
#SBATCH --partition=standard             # the partition
#SBATCH --mail-user=YOUR_EMAIL_HERE      # your email
#SBATCH --mail-type=BEGIN,END,FAIL

# Load any required modules for your HPC.
# At UMich, the GreatLakes HPC provides a singularity module which is required 
#    if you wish to run snakemake with --use-singularity.
# It is recommended to use your own local conda/mamba installation rather than 
#    the conda module provided by GreatLakes.
module load singularity 

# Run snakemake
snakemake \
    --profile config/slurm \ # use the slurm profile to run jobs
    --latency-wait 90 \ # wait 90 seconds for file system latency
    --use-singularity \ # use singularity to build the container image
    --use-conda \ # use the conda environments specified by the rules
    --conda-frontend mamba \ # specify mamba for faster environment solving
    --configfile config/test.yml # set a different configfile from default
