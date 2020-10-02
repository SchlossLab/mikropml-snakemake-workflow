source('code/log_smk.R')
library(dplyr)
future::plan(future::multicore, workers = snakemake@resources[['ncores']])
snakemake@input[['csv']] %>%
  future.apply::future_lapply(readr::read_csv) %>%
  dplyr::bind_rows() %>%
  readr::write_csv(snakemake@output[['csv']])
