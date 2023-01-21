schtools::log_snakemake()
library(dplyr)

snakemake@input[["csv"]] %>%
  purrr::map_dfr(readr::read_csv) %>%
  readr::write_csv(snakemake@output[["csv"]])
