schtools::log_snakemake()
rmarkdown::render("report.Rmd",
  output_file = snakemake@output[["doc"]]
)
