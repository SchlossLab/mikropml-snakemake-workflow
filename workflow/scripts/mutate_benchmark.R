schtools::log_snakemake()
library(tidyverse)

snakemake@input[['tsv']]
  read_tsv() %>%
  mutate(
      method = snakemake@wildcards[['method']],
      seed = snakemake@wildcards[['seed']]
  ) %>%
  write_csv(snakemake@output[['csv']])
