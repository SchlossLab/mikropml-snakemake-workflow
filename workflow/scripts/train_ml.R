schtools::log_snakemake()
library(dplyr)
doFuture::registerDoFuture()
future::plan(future::multicore, workers = snakemake@threads)

method <- snakemake@params[["method"]]
hyperparams <- snakemake@params[["hyperparams"]][[method]]
data_processed <- readRDS(snakemake@input[["rds"]])$dat_transformed

ml_results <- mikropml::run_ml(
  dataset = data_processed,
  method = method,
  outcome_colname = snakemake@params[["outcome_colname"]],
  find_feature_importance = FALSE,
  kfold = as.numeric(snakemake@params[["kfold"]]),
  seed = as.numeric(snakemake@params[["seed"]]),
  hyperparameters = hyperparams
)

wildcard_names <- snakemake@wildcards %>%
  names() %>%
  Filter(function(x) {
    nchar(x) > 0
  }, .)
wildcards <- snakemake@wildcards[wildcard_names] %>%
  as_tibble() %>%
  mutate(seed = as.numeric(seed))

readr::write_csv(
  ml_results$performance %>%
    inner_join(wildcards, by = c("method", "seed")),
  snakemake@output[["perf"]]
)
readr::write_csv(ml_results$test_data, snakemake@output[["test"]])
saveRDS(ml_results$trained_model, file = snakemake@output[["model"]])
