FROM condaforge/miniforge3:latest
LABEL io.github.snakemake.containerized="true"
LABEL io.github.snakemake.conda_env_hash="c1edb6a4917211d511a661c54768e671f7f067b1ea473011e8fdcbc485178d2c"

# Step 2: Retrieve conda environments

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
#   prefix: /conda-envs/e7c23e20e8aab7662ae81be2ad57d998
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
#     - r-mikropml>=1.6.0
#     - r-patchwork
#     - r-rmarkdown
#     - r-rpart
#     - r-purrr
#     - r-schtools>=0.4.0
#     - r-tidyverse
RUN mkdir -p /conda-envs/e7c23e20e8aab7662ae81be2ad57d998
COPY workflow/envs/mikropml.yml /conda-envs/e7c23e20e8aab7662ae81be2ad57d998/environment.yaml

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

# Step 3: Generate conda environments

RUN conda env create --prefix /conda-envs/b42323b0ffd5d034544511c9db1bdead --file /conda-envs/b42323b0ffd5d034544511c9db1bdead/environment.yaml && \
    conda env create --prefix /conda-envs/e7c23e20e8aab7662ae81be2ad57d998 --file /conda-envs/e7c23e20e8aab7662ae81be2ad57d998/environment.yaml && \
    conda env create --prefix /conda-envs/457b7b75191d44b96e5086432876e333 --file /conda-envs/457b7b75191d44b96e5086432876e333/environment.yaml && \
    conda clean --all -y
