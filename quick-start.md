# Quick Start Instructions

1. Download this repo with one of these methods:

    - **Clone**:
      ``` sh
      git clone https://github.com/SchlossLab/mikropml-snakemake-workflow
      cd mikropml-snakemake-workflow
      ```
    - **Use this template**:

      If you're viewing this on GitHub,
      click the green `Use this template` button to create
      your own version of the repo in your own GitHub, then clone your repo.
    
1. Install the dependencies.

    1. If you don't have conda/mamba yet, we recommend installing
       [Mambaforge](https://mamba.readthedocs.io/en/latest/installation.html).

    1. Create a conda environment with snakemake and pandas installed:

       ``` sh
       mamba env create -f workflow/envs/smk.yml
       mamba activate smk
       ```

    - Alternatively, you can install the dependencies listed in
    [the conda environments](/workflow/envs/) however you like.

1. Edit the configuration file: [`config/config.yaml`](/config/config.yaml). 
 
   See [config/README.md](/config/README.md) for a description of the configuration options.

1. Do a dry run to make sure the snakemake workflow is valid.

    ``` sh
    snakemake -n
    ```

1. Run the workflow.

    Run it **locally** using 2 cores:
    ``` sh
    snakemake --use-conda --cores 2
    ```

    Or specify a different config file:
    ``` sh
    snakemake --use-conda --cores 2 --configfile config/test.yaml
    ```

    You can use singularity with:
    ``` sh
    snakemake --use-singularity --use-conda --cores 2
    ```

    Or submit the jobs to a slurm cluster:
    ```sh
    snakemake --profile config/slurm --use-singularity--use-conda 
    ```
    See the [slurm config instructions](config/README.md#slurm) for more details
    on slurm configuration.

1. View the results in `report.md` ([see example here](report-example.md)).

    This example report was created by running the workflow on the Great Lakes HPC
    at the University of Michigan.
