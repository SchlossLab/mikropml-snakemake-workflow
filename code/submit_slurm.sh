#!/bin/bash

#SBATCH --job-name=mikropml

#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=100MB
#SBATCH --time=96:00:00

#SBATCH --output=log/hpc/slurm-%j_%x.out

#SBATCH --account=YOUR_ACCOUNT_HERE
#SBATCH --partition=standard

#SBATCH --mail-user=YOUR_EMAIL_HERE
#SBATCH --mail-type=BEGIN,END

time snakemake --profile config/slurm --latency-wait 90 --configfile config/config_robust.yml
