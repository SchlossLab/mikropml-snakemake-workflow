schtools::log_snakemake()
library(tidyverse)

wildcards <- schtools::get_wildcards_tbl()

read_tsv(snakemake@input[["tsv"]]) %>%
  bind_cols(wildcards) %>%
  write_csv(snakemake@output[["csv"]])
