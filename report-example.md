ML Results
================
2021-01-13

Machine learning algorithms used include: glmnet, rf, rpart2, svmRadial.
Models were trained with 100 different random partitions of the data
into training and testing sets using 5-fold cross validation.

## Model Performance

<img src="figures/performance-example.png" width="80%" />

## Hyperparameter Performance

<img src="figures/hp_performance_glmnet-example.png" width="80%" /><img src="figures/hp_performance_rf-example.png" width="80%" /><img src="figures/hp_performance_rpart2-example.png" width="80%" /><img src="figures/hp_performance_svmRadial-example.png" width="80%" />

## Memory Usage & Runtime

<img src="figures/benchmarks-example.png" width="80%" />

Each model training run was given 36 cores for parallelization.
