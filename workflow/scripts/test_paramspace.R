schtools::log_snakemake()
print(snakemake@params[['params']])

saveRDS(snakemake@params[['params']], snakemake@output[['rds']])
