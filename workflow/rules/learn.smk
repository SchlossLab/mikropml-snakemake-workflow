""" Preprocess data, train ML models, calculate performance, and find feature importance
"""


rule preprocess_data:
    input:
        csv=f"data/{dataset}.csv",
    output:
        rds=f"data/processed/{dataset}_preproc.Rds",
    log:
        f"log/{dataset}/preprocess_data.txt",
    benchmark:
        f"benchmarks/{dataset}/preprocess_data.txt"
    params:
        outcome_colname=outcome_colname,
    threads: ncores
    resources:
        mem_mb=MEM_PER_GB * 2,
    conda:
        "../envs/mikropml.yml"
    script:
        "../scripts/preproc.R"


rule run_ml:
    input:
        rds=rules.preprocess_data.output.rds,
    output:
        model=f"results/{paramspace.wildcard_pattern}/model.Rds",
        perf=f"results/{paramspace.wildcard_pattern}/performance.csv",
        test=f"results/{paramspace.wildcard_pattern}/test_data.csv",
    log:
        f"log/{paramspace.wildcard_pattern}/run_ml.txt",
    benchmark:
        f"benchmarks/{paramspace.wildcard_pattern}/run_ml.txt"
    params:
        outcome_colname=outcome_colname,
        hyperparams=hyperparams,
        method="{method}",
        seed="{seed}",
        kfold="{kfold}",
    threads: ncores
    resources:
        mem_mb=MEM_PER_GB * 4,
    conda:
        "../envs/mikropml.yml"
    script:
        "../scripts/train_ml.R"


rule calc_model_sensspec:
    input:
        model=rules.run_ml.output.model,
        test=rules.run_ml.output.test,
    output:
        csv=f"results/{paramspace.wildcard_pattern}/sensspec.csv",
    params:
        outcome_colname=outcome_colname,
    log:
        f"log/{paramspace.wildcard_pattern}/calc_model_sensspec.txt",
    conda:
        "../envs/mikropml.yml"
    script:
        "../scripts/calc_model_sensspec.R"


rule find_feature_importance:
    input:
        model=rules.run_ml.output.model,
        test=rules.run_ml.output.test,
    output:
        feat=f"results/{paramspace.wildcard_pattern}/feature_importance.csv",
    log:
        f"log/{paramspace.wildcard_pattern}/find_feature_importance.txt",
    params:
        outcome_colname=outcome_colname,
    threads: ncores
    resources:
        mem_mb=MEM_PER_GB * 1,
    conda:
        "../envs/mikropml.yml"
    script:
        "../scripts/find_feature_importance.R"
