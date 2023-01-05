FROM condaforge/mambaforge:latest
LABEL io.github.snakemake.containerized="true"
LABEL io.github.snakemake.conda_env_hash="4ed1adea09ccd5e6e7e24f2aa8e97ea56f7e7bf1edc809fe0c36b8d8f78138b6"

# Step 1: Retrieve conda environments

# Conda environment:
#   source: workflow/envs/mikropml.yml
#   prefix: /conda-envs/87dc1a1422059bb3cacf5b910bc1a96e
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
#     - r-mikropml>=1.4.0
#     - r-rmarkdown
#     - r-rpart
#     - r-schtools>=0.3.0
#     - r-tidyverse
RUN mkdir -p /conda-envs/87dc1a1422059bb3cacf5b910bc1a96e
COPY workflow/envs/mikropml.yml /conda-envs/87dc1a1422059bb3cacf5b910bc1a96e/environment.yaml

# Step 2: Generate conda environments

RUN mamba env create --prefix /conda-envs/87dc1a1422059bb3cacf5b910bc1a96e --file /conda-envs/87dc1a1422059bb3cacf5b910bc1a96e/environment.yaml && \
    mamba clean --all -y
