source("code/log_smk.R")
library(here)
rmarkdown::render(here(snakemake@input[["Rmd"]]),
  output_file = here(snakemake@output[["doc"]])
)
