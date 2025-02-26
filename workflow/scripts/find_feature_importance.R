schtools::log_snakemake()
library(mikropml)
library(dplyr)
library(readr)
doFuture::registerDoFuture()
future::plan(future::multicore, workers = snakemake@threads)
message(paste("# workers: ", foreach::getDoParWorkers()))

model <- readRDS(snakemake@input[["model"]])
outcome_colname <- snakemake@params[["outcome_colname"]]
train_dat <- model$trainingData
names(train_dat)[names(train_dat) == ".outcome"] <- outcome_colname
test_dat <- read_csv(snakemake@input[["test"]])
method <- snakemake@params[["method"]]
seed <- as.numeric(snakemake@params[["seed"]])

outcome_type <- get_outcome_type(c(
  train_dat %>% pull(outcome_colname),
  test_dat %>% pull(outcome_colname)
))
class_probs <- outcome_type != "continuous"
perf_metric_function <- get_perf_metric_fn(outcome_type)
perf_metric_name <- get_perf_metric_name(outcome_type)

if (!is.na(seed)) {
  set.seed(seed)
}
feat_imp <- mikropml::get_feature_importance(
  trained_model = model,
  test_data = test_dat,
  outcome_colname = outcome_colname,
  perf_metric_function = perf_metric_function,
  perf_metric_name = perf_metric_name,
  class_probs = class_probs,
  method = method,
  seed = seed,
)

wildcards <- schtools::get_wildcards_tbl() %>%
  dplyr::mutate(seed = as.numeric(seed))

readr::write_csv(
  feat_imp %>%
    inner_join(wildcards, by = c("method", "seed")),
  snakemake@output[["feat"]]
)
