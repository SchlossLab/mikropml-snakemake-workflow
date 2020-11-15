ML Results
================
2020-11-13

Machine learning algorithms used include: glmnet, rf, rpart2, svmRadial,
xgbTree. Models were trained with 100 different random partitions of the
data into training and testing sets using 5-fold cross validation.

## Model Performance

<img src="figures/performance.png" width="80%" />

## Memory Usage & Runtime

<img src="figures/benchmarks.png" width="80%" />

Each model training run was given 36 cores for parallelization.
