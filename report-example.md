ML Results
================
2022-11-02

Machine learning algorithms used were glmnet and rf. Models were trained
with 10 different random partitions of the otu-large dataset into
training and testing sets using 5-fold cross validation.

## Model Performance

<img src="figures/example/performance.png" width="80%" />

## Feature Importance

<img src="figures/example/feature_importance.png" width="80%" />

## Memory Usage & Runtime

<img src="figures/example/benchmarks.png" width="80%" />

Each model training run was given 8 cores for parallelization.

## Hyperparameter Performance

<img src="figures/example/hp_performance_glmnet.png" width="80%" /><img src="figures/example/hp_performance_rf.png" width="80%" />
