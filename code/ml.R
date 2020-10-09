source("code/log_smk.R")

doFuture::registerDoFuture()
future::plan(future::multicore, workers = snakemake@resources[["ncores"]])

data_processed <- readRDS(snakemake@input[["rds"]])$dat_transformed
ml_results <- mikropml::run_ml(
  dataset = data_processed,
  method = snakemake@params[["method"]],
  outcome_colname = snakemake@params[['outcome_colname']],
  find_feature_importance = TRUE,
  kfold = as.numeric(snakemake@params[['kfold']]),
  seed = as.numeric(snakemake@params[["seed"]])
)

saveRDS(ml_results$trained_model, file = snakemake@output[["model"]])
readr::write_csv(ml_results$performance, snakemake@output[["perf"]])
readr::write_csv(ml_results$feature_importance, snakemake@output[["feat"]])
