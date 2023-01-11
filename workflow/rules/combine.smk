
rule combine_results:
    input:
        csv=expand(
            "results/{{dataset}}/runs/{method}_{seed}_{{type}}.csv",
            method=ml_methods,
            seed=seeds,
        ),
    output:
        csv="results/{dataset}/{type}_results.csv",
    log:
        "log/{dataset}/combine_results_{type}.txt",
    benchmark:
        "benchmarks/{dataset}/combine_results_{type}.txt"
    conda:
        "../envs/mikropml.yml"
    script:
        "../scripts/combine_results.R"


rule combine_hp_performance:
    input:
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


rule mutate_benchmark:
    input:
        tsv="benchmarks/{dataset}/runs/run_ml.{method}_{seed}.txt",
    output:
        csv="results/{dataset}/runs/{method}_{seed}_benchmarks.csv",
    log:
        "log/{dataset}/mutate_benchmark.{method}_{seed}.txt",
    conda:
        "../envs/mikropml.yml"
    script:
        "../scripts/mutate_benchmark.R"
