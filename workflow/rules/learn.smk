rule preprocess_data:
    input:
        R="workflow/scripts/preproc.R",
        csv=dataset_filename,
    output:
        rds=f"data/processed/{dataset}_preproc.Rds",
    log:
        "log/preprocess_data.txt",
    benchmark:
        "benchmarks/preprocess_data.txt"
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
        R="workflow/scripts/train_ml.R",
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
        params=paramspace.instance,
        hyperparams=hyperparams,
    threads: ncores
    resources:
        mem_mb=MEM_PER_GB * 4,
    conda:
        "../envs/mikropml.yml"
    script:
        "../scripts/train_ml.R"

rule test_paramspace:
    input:
        csv=dataset_filename
    output:
        rds=f"tmp/{paramspace.wildcard_pattern}/test.Rds"
    params:
        params=paramspace.instance,
    log: f"log/{paramspace.wildcard_pattern}/test_paramspace.txt"
    script:
        "../scripts/test_paramspace.R"

rule agg_params:
    input:
        expand("tmp/{params}/test.Rds", params = paramspace.instance_patterns)

rule find_feature_importance:
    input:
        R="workflow/scripts/find_feature_importance.R",
        model=rules.run_ml.output.model,
        test=rules.run_ml.output.test,
    output:
        feat=f"results/{paramspace.wildcard_pattern}/feature_importance.csv",
    log:
        f"log/{paramspace.wildcard_pattern}/find_feature_importance.txt",
    params:
        outcome_colname=outcome_colname,
        method="{method}",
        seed="{seed}",
    threads: ncores
    resources:
        mem_mb=MEM_PER_GB * 1,
    conda:
        "../envs/mikropml.yml"
    script:
        "../scripts/find_feature_importance.R"
