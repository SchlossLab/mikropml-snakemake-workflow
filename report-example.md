---
title: "ML Results"
date: "2023-01-31"
output:
  html_document:
    keep_md: true
    self_contained: true
    theme: spacelab
---
            






Machine learning algorithm(s) used: glmnet and rf.
Models were trained with 10 different random
partitions of the otu-large dataset into training and
testing sets using 5-fold cross validation.
See [config/config.yaml](config/config.yaml) 
for the full configuration.

## Workflow

<img src="figures/example/rulegraph.png" width="80%" />

## Model Performance

<img src="figures/example/performance.png" width="80%" />

<img src="figures/example/roc_curves.png" width="80%" />

## Hyperparameter Performance

<img src="figures/example/hp_performance_glmnet.png" width="80%" /><img src="figures/example/hp_performance_rf.png" width="80%" />

## Feature Importance

<img src="figures/example/feature_importance.png" width="80%" />

## Memory Usage & Runtime

Each model training run was given 8 cores
for parallelization.

<img src="figures/example/benchmarks.png" width="80%" />
