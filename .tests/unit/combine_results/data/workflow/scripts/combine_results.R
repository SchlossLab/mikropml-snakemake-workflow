schtools::log_snakemake()
library(tidyverse)

snakemake@input[["csv"]] %>%
  lapply(read_csv) %>%
  bind_rows() %>%
  write_csv(snakemake@output[["csv"]])
