source("code/log_smk.R")
doFuture::registerDoFuture()
future::plan(future::multicore, workers = snakemake@resources[["ncores"]])

data_raw <- readr::read_csv(snakemake@input[["csv"]])
data_processed <- mikropml::preprocess_data(data_raw, outcome_colname = "dx")

saveRDS(data_processed, file = snakemake@output[["rds"]])
