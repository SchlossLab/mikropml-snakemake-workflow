source("code/log_smk.R")
library(mikropml)

doFuture::registerDoFuture()
future::plan(future::multicore, workers = snakemake@resources[["ncores"]])

data_raw <- readr::read_csv(snakemake@input[["csv"]])
data_processed <- preprocess_data(data_raw, outcome_colname = snakemake@params[['outcome_colname']])

saveRDS(data_processed, file = snakemake@output[["rds"]])
