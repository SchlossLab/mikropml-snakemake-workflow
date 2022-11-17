schtools::log_snakemake()
library(tidyverse)

model <- read_rds(snakemake@input[["model"]])
test_dat <- read_csv(snakemake@input[["test"]])

probs <- predict(model,
  newdata = test_dat,
  type = "prob"
) %>%
  mutate(actual = test_dat$pos_cdiff_d1)

total <- probs %>% 
    count(actual) %>%
    pivot_wider(names_from = "actual", values_from = "n") 

sensspec <- probs %>%
    arrange(desc(yes)) %>%
    mutate(is_pos = actual == "yes") %>%
    mutate(
      tp = cumsum(is_pos),
      fp = cumsum(!is_pos),
      sensitivity = tp / total$yes,
      fpr = fp / total$no
    ) %>%
    mutate(
      specificity = 1 - fpr,
      precision = tp / (tp + fp)
    )

sensspec %>%
  mutate(
    seed = snakemake@wildcards[["seed"]],
    method = snakemake@wildcards[["method"]],
  ) %>%
  write_csv(snakemake@output[["csv"]])