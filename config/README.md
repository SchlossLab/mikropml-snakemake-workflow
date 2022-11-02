## Quick Start

1. Clone or download this repo and go to the directory.

    ``` sh
    git clone https://github.com/SchlossLab/mikropml-snakemake-workflow
    cd mikropml-snakemake-workflow
    ```

    Alternatively, if you're viewing this on GitHub,
    you can click the green `Use this template` button to create
    your own version of the repo on GitHub, then clone it.

1. Install the dependencies.

    1. If you don't have conda yet, we recommend installing
       [miniconda](https://docs.conda.io/en/latest/miniconda.html).

    1. Next, install [mamba](https://mamba.readthedocs.io/en/latest/),
       a fast drop-in replacement for conda:

       ``` sh
       conda install mamba -n base -c conda-forge
       ```

    1. Create a conda environment with snakemake installed:

       ``` sh
       mamba env create -f workflow/envs/smk.yml
       conda activate smk
       ```

    - Alternatively, you can install the dependencies listed in
    [`workflow/envs/environment.yml`](/workflow/envs/environment.yml) however you like.

1. Edit the configuration file [`config/default.yml`](/config/default.yml).
    - `dataset_csv`: the path to the dataset as a csv file.
    - `dataset_csv`: a short name to identify the dataset.
    - `outcome_colname`: column name of the outcomes or classes for the dataset.
    - `ml_methods`: list of machine learning methods to use. Must be supported by mikropml or caret.
    - `kfold`: k number for k-fold cross validation during model training.
    - `ncores`: the number of cores to use for preprocessing and for each `mikropml::run_ml()` call. Do not exceed the number of cores you have available.
    - `nseeds`: the number of different random seeds to use for training models with `mikropml::run_ml()`.
    - `hyperparams`: override the default model hyperparameters set by mikropml for each ML method (optional). Leave this blank if you'd like to use the defaults. You will have to set these if you wish to use an ML method from caret that we don't officially support.
    - `find_feature_importance`: whether to calculate feature importances with permutation tests.

    You can leave these options as-is if you'd like to first make sure the
    workflow runs without error on your machine before using your own dataset
    and custom parameters.

    The default and test config files are suitable for initial testing,
    but we recommend using more cores if available and
    more seeds for model training.
    A more robust configuration is provided in
    [`config/robust.yml`](/config/robust.yml).

1. Do a dry run to make sure the snakemake workflow is valid.

    ``` sh
    snakemake -n
    ```

1. Run the workflow.

    Run it **locally** using 2 cores with:
    ``` sh
    snakemake --use-conda --cores 2
    ```

    Or specify a different config file with:
    ``` sh
    snakemake --use-conda --cores 2 --configfile config/test.yml
    ```

    To run the workflow on an **HPC with Slurm**:

    1. Edit your email (`YOUR_EMAIL_HERE`), Slurm account (`YOUR_ACCOUNT_HERE`), and other Slurm parameters as needed in:

        - [`workflow/scripts/submit_slurm.sh`](/workflow/scripts/submit_slurm.sh)
        - [`config/slurm/config.yaml`](/config/slurm/config.yaml)

    1. Submit the snakemake workflow with:

        ``` sh
        sbatch workflow/scripts/submit_slurm.sh
        ```

        The main job will then submit all other snakemake jobs, allowing
        independent steps of the workflow to run on different nodes in parallel.
        Slurm output files will be written to `log/hpc/`.

1. View the results in `report.md` ([see example here](report-example.md)).

    This example report was created by running the workflow on the Great Lakes HPC
    at the University of Michigan with [`config/robust.yml`](config/robust.yml).

## Out of memory or walltime

If any of your jobs fail because it ran out of memory, you can increase the
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
[config/slurm/config.yml](/config/slurm/config.yml)

## More resources

- [mikropml docs](http://www.schlosslab.org/mikropml/)
- [Snakemake tutorial](https://snakemake.readthedocs.io/en/stable/tutorial/tutorial.html)
- [conda user guide](https://docs.conda.io/projects/conda/en/latest/user-guide/getting-started.html)
