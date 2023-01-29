schtools::log_snakemake()
library(dplyr)
doFuture::registerDoFuture()
future::plan(future::multicore, workers = snakemake@threads)

method <- snakemake@wildcards[["method"]]
seed <- as.numeric(snakemake@wildcards[["seed"]])
kfold <- as.numeric(snakemake@wildcards[["kfold"]])
hyperparams <- snakemake@params[["hyperparams"]][[method]]
outcome_colname <- snakemake@params[["outcome_colname"]]
data_processed <- readRDS(snakemake@input[["rds"]])$dat_transformed

ml_results <- mikropml::run_ml(
  dataset = data_processed,
  method = method,
  outcome_colname = outcome_colname,
  find_feature_importance = FALSE,
  kfold = kfold,
  seed = seed,
  hyperparameters = hyperparams
)

wildcards <- schtools::get_wildcards_tbl()

ml_results$performance %>%
  inner_join(wildcards) %>%
  readr::write_csv(snakemake@output[["perf"]])
ml_results$test_data %>% readr::write_csv(snakemake@output[["test"]])
ml_results$trained_model %>% saveRDS(file = snakemake@output[["model"]])
