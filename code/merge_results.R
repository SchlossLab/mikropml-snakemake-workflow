source('code/log_smk.R')
library(dplyr)
snakemake@input[['csv']] %>%
  purrr::map(readr::read_tsv) %>%
  dplyr::bind_rows() %>%
  readr::write_tsv(snakemake@output[['csv']])