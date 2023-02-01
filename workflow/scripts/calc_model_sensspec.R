schtools::log_snakemake()
library(tidyverse)

model <- read_rds(snakemake@input[["model"]])
test_dat <- read_csv(snakemake@input[["test"]])
outcome_colname <- snakemake@params[["outcome_colname"]]
mikropml::calc_model_sensspec(
  model,
  test_dat,
  outcome_colname
) %>%
  bind_cols(schtools::get_wildcards_tbl()) %>%
  write_csv(snakemake@output[["csv"]])
