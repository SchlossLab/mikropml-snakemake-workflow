FROM condaforge/mambaforge:latest
LABEL io.github.snakemake.containerized="true"
LABEL io.github.snakemake.conda_env_hash="6aa289536136aae2d34bac6dce9ce47d037da888ed09e2c8ada989c90ef10658"

# Step 1: Retrieve conda environments

# Conda environment:
#   source: workflow/envs/graphviz.yml
#   prefix: /conda-envs/b42323b0ffd5d034544511c9db1bdead
#   name: graphviz
#   channels:
#     - conda-forge
#   dependencies:
#     - graphviz
RUN mkdir -p /conda-envs/b42323b0ffd5d034544511c9db1bdead
COPY workflow/envs/graphviz.yml /conda-envs/b42323b0ffd5d034544511c9db1bdead/environment.yaml

# Conda environment:
#   source: workflow/envs/mikropml.yml
#   prefix: /conda-envs/3f83a46ff5ea715a12fde6ee46136b0b
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
#     - r-patchwork
#     - r-rmarkdown
#     - r-rpart
#     - r-purrr
#     - r-schtools>=0.4.0
#     - r-tidyverse
RUN mkdir -p /conda-envs/3f83a46ff5ea715a12fde6ee46136b0b
COPY workflow/envs/mikropml.yml /conda-envs/3f83a46ff5ea715a12fde6ee46136b0b/environment.yaml

# Conda environment:
#   source: workflow/envs/smk.yml
#   prefix: /conda-envs/457b7b75191d44b96e5086432876e333
#   name: smk
#   channels:
#     - conda-forge
#     - bioconda
#   dependencies:
#     - snakemake=7
#     - snakedeploy
#     - zip
RUN mkdir -p /conda-envs/457b7b75191d44b96e5086432876e333
COPY workflow/envs/smk.yml /conda-envs/457b7b75191d44b96e5086432876e333/environment.yaml

# Step 2: Generate conda environments

RUN mamba env create --prefix /conda-envs/b42323b0ffd5d034544511c9db1bdead --file /conda-envs/b42323b0ffd5d034544511c9db1bdead/environment.yaml && \
    mamba env create --prefix /conda-envs/3f83a46ff5ea715a12fde6ee46136b0b --file /conda-envs/3f83a46ff5ea715a12fde6ee46136b0b/environment.yaml && \
    mamba env create --prefix /conda-envs/457b7b75191d44b96e5086432876e333 --file /conda-envs/457b7b75191d44b96e5086432876e333/environment.yaml && \
    mamba clean --all -y
