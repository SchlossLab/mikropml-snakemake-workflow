FROM condaforge/mambaforge:latest
LABEL io.github.snakemake.containerized="true"
LABEL io.github.snakemake.conda_env_hash="a74f7d4466792ff7cab43f2d5772c161f05c6a46c13b58da2d1073c05fad2a1e"

# Step 1: Retrieve conda environments

# Conda environment:
#   source: workflow/envs/mikropml.yml
#   prefix: /conda-envs/192b1b4708354ef65bddf4eec0ec00c9
#   name: mikropml
#   channels:
#     - conda-forge
#     - r
#   dependencies:
#     - r-base=4
#     - r-doFuture
#     - r-cowplot
#     - r-devtools
#     - r-foreach
#     - r-future
#     - r-future.apply
#     - r-import
#     - r-mikropml>=1.4.0
#     - r-rmarkdown
#     - r-rpart
#     - r-purrr
#     - r-schtools>=0.3.0
#     - r-tidyverse
RUN mkdir -p /conda-envs/192b1b4708354ef65bddf4eec0ec00c9
COPY workflow/envs/mikropml.yml /conda-envs/192b1b4708354ef65bddf4eec0ec00c9/environment.yaml

# Step 2: Generate conda environments

RUN mamba env create --prefix /conda-envs/192b1b4708354ef65bddf4eec0ec00c9 --file /conda-envs/192b1b4708354ef65bddf4eec0ec00c9/environment.yaml && \
    mamba clean --all -y
