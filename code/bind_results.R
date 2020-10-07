source("code/log_smk.R")
library(tidyverse)

snakemake@input[["csv"]] %>%
  lapply(readr::read_csv) %>%
  bind_rows() %>%
  write_csv(snakemake@output[["csv"]])
