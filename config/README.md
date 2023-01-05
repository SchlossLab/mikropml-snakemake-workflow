# General configuration

To configure this workflow, modify [`config/config.yaml`](/config/config.yaml) according to your needs.

**Configuration options:**

  - `dataset_csv`: the path to the dataset as a csv file. 
  - `dataset_name`: a short name to identify the dataset.
  - `outcome_colname`: column name of the outcomes or classes for the dataset. If blank, the first column of the dataset will be used as the outcome and all other columns are features.
  - `ml_methods`: list of machine learning methods to use. Must be [supported by mikropml or caret](http://www.schlosslab.org/mikropml/articles/introduction.html#the-methods-we-support).
  - `kfold`: k number for k-fold cross validation during model training.
  - `ncores`: the number of cores to use for `preprocess_data()`, `run_ml()`, and `get_feature_importance()`. Do not exceed the number of cores you have available.
  - `nseeds`: the number of different random seeds to use for training models with `run_ml()`. This will result in `nseeds` different train/test splits.
  - `find_feature_importance`: whether to calculate feature importances with permutation tests (`true` or `false`). If `false`, the plot in the report will be blank.
  - `hyperparams`: override the default model hyperparameters set by mikropml for each ML method (optional). Leave this blank if you'd like to use the defaults. You will have to set these if you wish to use an ML method from caret that we don't officially support.

We also provide [`config/test.yaml`](/config/test.yaml), which uses a smaller dataset so 
you can first make sure the workflow runs without error on your machine 
before using your own dataset and custom parameters.

The default and test config files are suitable for initial testing,
but we recommend using more cores (if available) and
more seeds for model training.
A more robust configuration is provided in
[`config/robust.yaml`](/config/robust.yaml).

## SLURM

1. If you plan to run the workflow on an **HPC with Slurm**, you will need to 
   edit your email (`YOUR_EMAIL_HERE`), 
   Slurm account (`YOUR_ACCOUNT_HERE`), 
   and other Slurm parameters as needed in 
   [`config/slurm/config.yaml`](/config/slurm/config.yaml).

1. Create a slurm submission script (`workflow/scripts/submit_slurm.sh`) with the following contents:

    ```sh
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
    module load singularity 

    # Run snakemake
    snakemake \
        --profile config/slurm \ # use the slurm profile to run jobs
        --latency-wait 90 \ # wait for file system latency
        --use-conda \ # use conda environments specified by rules
        --use-singularity \ # use singularity to build the container image
        --configfile config/test.yaml # specify a different configfile from default
    ```
    Edit the slurm options as needed.

1. Submit the snakemake workflow with: 

    ``` sh
    sbatch workflow/scripts/submit_slurm.sh
    ```

    The main job will submit all other snakemake jobs using the default resources specified in [`config/slurm/config.yaml`](/config/slurm/config.yaml). 
    This allows independent steps of the workflow to run on different nodes in parallel.
    Slurm output files will be written to `log/hpc/`.


### Out of memory or walltime

When using slurm,
if any of your jobs fail because it ran out of memory, you can increase the
memory for the given rule with the
[resources directive](https://snakemake.readthedocs.io/en/stable/snakefiles/rules.html#resources)
in the Snakefile. For example, if the `combine_hp_performance` rule fails, you
can increase the memory from 16GB to say 24GB in
[workflow/rules/combine.smk](/workflow/rules/combine.smk):

```
rule combine_hp_performance:
    input:
        ...
    resources:
        mem_mb = MEM_PER_GB * 24
    ...
```

The new `mem_mb` value then gets passed on to the slurm configuration.

To specify more cores for a rule, use the
[threads directive](https://snakemake.readthedocs.io/en/stable/snakefiles/rules.html#threads):

```
rule combine_hp_performance:
    input:
        ...
    resources:
        mem_mb = MEM_PER_GB * 24
    threads: 8
    ...
```

You can also change other slurm parameters that are defined in
[config/slurm/config.yaml](/config/slurm/config.yaml)
