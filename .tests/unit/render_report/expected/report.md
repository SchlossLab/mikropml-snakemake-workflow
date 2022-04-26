ML Results
================
2022-04-22

Machine learning algorithms used include: glmnet. Models were trained
with 2 different random partitions of the data into training and testing
sets using 2-fold cross validation.

## Model Performance

<img src="figures/performance.png" width="80%" />

## Hyperparameter Performance

<img src="figures/hp_performance_glmnet.png" width="80%" />

## Memory Usage & Runtime

<img src="figures/benchmarks.png" width="80%" />

Each model training run was given 4 cores for parallelization.
