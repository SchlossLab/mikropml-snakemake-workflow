schtools::log_snakemake()
print(paste("doPar workers: ", foreach::getDoParWorkers()))
doFuture::registerDoFuture()
future::plan(future::multicore, workers = snakemake@threads)
print(paste("doPar workers: ", foreach::getDoParWorkers()))

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

saveRDS(ml_results$trained_model, file = snakemake@output[["model"]])
readr::write_csv(ml_results$performance, snakemake@output[["perf"]])
readr::write_csv(ml_results$test_data, snakemake@output[["test"]])
