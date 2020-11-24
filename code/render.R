source("code/log_smk.R")
rmarkdown::render(snakemake@input[["Rmd"]],
  output_file = snakemake@output[["doc"]]
)
