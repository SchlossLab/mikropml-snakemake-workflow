# TODO: basic feature importance plot as an example
schtools::log_snakemake()
library(ggplot2)
ggsave(filename = snakemake@output[['plot']], 
       plot = ggplot(), 
       device = 'png'
       )