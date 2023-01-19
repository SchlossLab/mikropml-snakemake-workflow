FROM condaforge/mambaforge:latest
LABEL io.github.snakemake.containerized="true"
LABEL io.github.snakemake.conda_env_hash="13c135c49e238a3de34c11f438bd0efbaee84d5e84d05e1d3516d2392dabbea9"

# Step 1: Retrieve conda environments

# Conda environment:
#   source: workflow/envs/mikropml.yml
#   prefix: /conda-envs/67570867c99c9c3db185b41548ad6071
#   name: mikropml
#   channels:
#     - conda-forge
#     - r
#   dependencies:
#     - r-base=4
#     - r-doFuture
#     - r-cowplot
#     - r-foreach
#     - r-future
#     - r-future.apply
#     - r-import
#     - r-mikropml>=1.5.0
#     - r-rmarkdown
#     - r-rpart
#     - r-purrr
#     - r-schtools>=0.4.0
#     - r-tidyverse
RUN mkdir -p /conda-envs/67570867c99c9c3db185b41548ad6071
COPY workflow/envs/mikropml.yml /conda-envs/67570867c99c9c3db185b41548ad6071/environment.yaml

# Step 2: Generate conda environments

RUN mamba env create --prefix /conda-envs/67570867c99c9c3db185b41548ad6071 --file /conda-envs/67570867c99c9c3db185b41548ad6071/environment.yaml && \
    mamba clean --all -y
