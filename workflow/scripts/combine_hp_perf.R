source("code/log_smk.R")

models <- lapply(snakemake@input[["rds"]], function(x) readRDS(x))
hp_perf <- mikropml::combine_hp_performance(models) 
hp_perf$method <- snakemake@wildcards[["method"]]
saveRDS(hp_perf, file = snakemake@output[["rds"]])
