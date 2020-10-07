# Running mikropml with snakemake

## The Workflow

The [Snakemake workflow](Snakefile) preprocesses the dataset ([`data/otu_large.csv`](data/otu_large.csv)),
calls `mikropml::run_ml()` for each seed and ML method set in[ `config/config.yml`](config/config.yml),
combines the results files,
plots performance results,
and renders a simple [R Markdown report](report.Rmd) as a GitHub-flavored [markdown file](report.md).

![rulegraph](figures/rulegraph.png)

## Quick Start

1. Clone or download this repo and go to the directory.

    ``` sh
    git clone https://github.com/SchlossLab/mikropml-snakemake-workflow
    cd mikropml-snakemake-workflow
    ```

    Alternatively you can click the green `Use this template` button to create
    your own version of the repo on GitHub, then clone it.

1. Create a conda environment and activate it.
    ``` sh
    conda env create -f config/environment.yml
    conda activate smk-ML
    ```
    (Recommend [miniconda](https://docs.conda.io/en/latest/miniconda.html) if you don't already have conda installed.)

    Alternatively, you can [install snakemake](https://snakemake.readthedocs.io/en/stable/getting_started/installation.html) and the other dependencies listed in [`config/environment.yml`](config/environment.yml) however you like.
1. Install the mikropml R package. [mikropml install instructions](https://github.com/SchlossLab/mikropml#installation)

    e.g.
    ``` sh
    R -e 'devtools::install_github("SchlossLab/mikropml")'
    ```
1. Edit the configuration file [`config/config.yml`](config/config.yml).
    - `ml_methods`: list of machine learning methods to use. Must be supported by mikropml.
    - `ncores`: the number of cores to use for preprocessing and for each `mikropml::run_ml()` call. Do not exceed the number of cores you have available.
    - `nseeds`: the number of different random seeds to use for training models with `mikropml::run_ml()`.

1. Do a dry run to make sure the snakemake workflow is valid.
    ``` sh
    snakemake -n
    ```
1. Run the workflow.

    Run it locally with:
    ``` sh
    snakemake
    ```

    To run the workflow on an HPC with SLURM:

    1. Edit your email (`YOUR_EMAIL_HERE`) and SLURM account (`YOUR_ACCOUNT_HERE`) in:
        - [`code/submit_slurm.sh`](code/submit_slurm.sh)
        - [`config/cluster.json`](config/cluster.json)
    1. Submit the snakemake workflow with:
        ``` µsh
        sbatch code/submit_slurm.sh
        ```
        The main job will then submit other snakemake jobs.
1. View the results in [`report.md`](report.md).

## Resources

- [Snakemake docs](https://snakemake.readthedocs.io/en/stable)
- [mikropml docs](http://www.schlosslab.org/mikropml/)
