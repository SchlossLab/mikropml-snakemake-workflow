schtools::log_snakemake()
library(dplyr)
doFuture::registerDoFuture()
future::plan(future::multicore, workers = snakemake@threads)

method <- snakemake@params[["method"]]
seed <- as.numeric(snakemake@params[["seed"]])
hyperparams <- snakemake@params[["hyperparams"]][[method]]
data_processed <- readRDS(snakemake@input[["rds"]])$dat_transformed

ml_results <- mikropml::run_ml(
  dataset = data_processed,
  method = method,
  outcome_colname = snakemake@params[["outcome_colname"]],
  find_feature_importance = FALSE,
  kfold = as.numeric(snakemake@params[["kfold"]]),
  seed = seed,
  hyperparameters = hyperparams
)

wildcards <- schtools::get_wildcards_tbl() %>%
  dplyr::mutate(seed = as.numeric(seed))

readr::write_csv(
  ml_results$performance %>%
    inner_join(wildcards, by = c("method", "seed")),
  snakemake@output[["perf"]]
)
readr::write_csv(ml_results$test_data, snakemake@output[["test"]])
saveRDS(ml_results$trained_model, file = snakemake@output[["model"]])
