schtools::log_snakemake()
library(tidyverse)

read_tsv(snakemake@input[["tsv"]]) %>%
  mutate(
    method = snakemake@wildcards[["method"]],
    seed = snakemake@wildcards[["seed"]]
  ) %>%
  write_csv(snakemake@output[["csv"]])
