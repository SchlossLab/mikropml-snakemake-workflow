
rule combine_results:
    input:
        R="workflow/scripts/combine_results.R",
        csv=expand(
            "results/{params}/{{type}}.csv",
            params=paramspace.instance_patterns
        ),
    output:
        csv="results/{type}_results.csv",
    log:
        "log/combine_results_{type}.txt",
    benchmark:
        "benchmarks/combine_results_{type}.txt"
    conda:
        "../envs/mikropml.yml"
    script:
        "../scripts/combine_results.R"


rule combine_hp_performance:
    input:
        R="workflow/scripts/combine_hp_perf.R",
        rds=expand("results/{{dataset}}/runs/{{method}}_{seed}_model.Rds", seed=seeds),
    output:
        rds="results/{dataset}/hp_performance_results_{method}.Rds",
    log:
        "log/{dataset}/combine_hp_perf_{method}.txt",
    benchmark:
        "benchmarks/{dataset}/combine_hp_perf_{method}.txt"
    resources:
        mem_mb=MEM_PER_GB * 16,
    conda:
        "../envs/mikropml.yml"
    script:
        "../scripts/combine_hp_perf.R"


rule combine_benchmarks:
    input:
        R="workflow/scripts/combine_benchmarks.R",
        tsv=expand(
            "benchmarks/{{dataset}}/runs/run_ml.{method}_{seed}.txt",
            method=ml_methods,
            seed=seeds,
        ),
    output:
        csv="results/{dataset}/benchmarks_results.csv",
    log:
        "log/{dataset}/combine_benchmarks.txt",
    conda:
        "../envs/mikropml.yml"
    script:
        "../scripts/combine_benchmarks.R"
