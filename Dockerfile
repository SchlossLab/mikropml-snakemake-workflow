FROM condaforge/mambaforge:latest
LABEL io.github.snakemake.containerized="true"
LABEL io.github.snakemake.conda_env_hash="a57a1be27a188ebf9bb5feda054b3c8e501423ae80bcd6c24c221ca36de41d15"

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
#   prefix: /conda-envs/bbc262640c3353e62cad877627dd3174
#   name: smk
#   channels:
#     - conda-forge
#     - bioconda
#   dependencies:
#     - pandas
#     - pytest
#     - pytest-xdist
#     - snakemake=7
#     - snakedeploy
#     - zip
RUN mkdir -p /conda-envs/bbc262640c3353e62cad877627dd3174
COPY workflow/envs/smk.yml /conda-envs/bbc262640c3353e62cad877627dd3174/environment.yaml

# Step 2: Generate conda environments

RUN mamba env create --prefix /conda-envs/b42323b0ffd5d034544511c9db1bdead --file /conda-envs/b42323b0ffd5d034544511c9db1bdead/environment.yaml && \
    mamba env create --prefix /conda-envs/3f83a46ff5ea715a12fde6ee46136b0b --file /conda-envs/3f83a46ff5ea715a12fde6ee46136b0b/environment.yaml && \
    mamba env create --prefix /conda-envs/bbc262640c3353e62cad877627dd3174 --file /conda-envs/bbc262640c3353e62cad877627dd3174/environment.yaml && \
    mamba clean --all -y
