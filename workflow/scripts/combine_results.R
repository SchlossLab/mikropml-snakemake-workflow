schtools::log_snakemake()

snakemake@input[["csv"]] %>%
  purrr::map_dfr(readr::read_csv) %>%
  readr::write_csv(snakemake@output[["csv"]])
