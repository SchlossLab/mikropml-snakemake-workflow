source('code/log_smk.R')
library(dplyr)
snakemake@input[['csv']] %>%
  purr::map(readr::read_tsv) %>%
  dplyr::bind_rows() %>%
  readr::write_tsv(snakemake@output[['csv']])