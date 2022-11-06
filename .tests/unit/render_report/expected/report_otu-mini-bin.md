ML Results
================
2022-11-05

Machine learning algorithms used were glmnet. Models were trained with 2
different random partitions of the otu-mini-bin dataset into training
and testing sets using 2-fold cross validation.

## Model Performance

<img src="figures/otu-mini-bin/performance.png" width="80%" />

## Feature Importance

<img src="figures/otu-mini-bin/feature_importance.png" width="80%" />

## Memory Usage & Runtime

<img src="figures/otu-mini-bin/benchmarks.png" width="80%" />

Each model training run was given 4 cores for parallelization.

## Hyperparameter Performance

<img src="figures/otu-mini-bin/hp_performance_glmnet.png" width="80%" />
