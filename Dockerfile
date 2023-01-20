FROM condaforge/mambaforge:latest
LABEL io.github.snakemake.containerized="true"
LABEL io.github.snakemake.conda_env_hash="a3713ec99770d7dcc2bbdbe9b79e1a9f0c798f396d49f533486fb3193730b7b3"

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

# Conda environment:
#   source: workflow/envs/smk.yml
#   prefix: /conda-envs/9af38ac9af9135264be16dd13f279cd7
#   name: smk
#   channels:
#     - conda-forge
#     - bioconda
#   dependencies:
#     - snakemake=7
#     - snakedeploy
RUN mkdir -p /conda-envs/9af38ac9af9135264be16dd13f279cd7
COPY workflow/envs/smk.yml /conda-envs/9af38ac9af9135264be16dd13f279cd7/environment.yaml

# Step 2: Generate conda environments

RUN mamba env create --prefix /conda-envs/b42323b0ffd5d034544511c9db1bdead --file /conda-envs/b42323b0ffd5d034544511c9db1bdead/environment.yaml && \
    mamba env create --prefix /conda-envs/67570867c99c9c3db185b41548ad6071 --file /conda-envs/67570867c99c9c3db185b41548ad6071/environment.yaml && \
    mamba env create --prefix /conda-envs/9af38ac9af9135264be16dd13f279cd7 --file /conda-envs/9af38ac9af9135264be16dd13f279cd7/environment.yaml && \
    mamba clean --all -y
