schtools::log_snakemake()
library(tidyverse)

model <- read_rds(snakemake@input[["model"]])
test_dat <- read_csv(snakemake@input[["test"]])

probs <- predict(model,
  newdata = test_dat,
  type = "prob"
) %>%
  mutate(actual = test_dat$dx)

total <- probs %>%
    count(actual) %>%
    pivot_wider(names_from = "actual", values_from = "n")

sensspec <- probs %>%
    arrange(desc(cancer)) %>%
    mutate(is_pos = actual == "cancer") %>%
    mutate(
      tp = cumsum(is_pos),
      fp = cumsum(!is_pos),
      sensitivity = tp / total$cancer,
      fpr = fp / total$normal
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
