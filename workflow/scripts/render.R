source(snakemake@input[['logR']])
rmarkdown::render(snakemake@input[["Rmd"]],
  output_file = snakemake@output[["doc"]]
)
