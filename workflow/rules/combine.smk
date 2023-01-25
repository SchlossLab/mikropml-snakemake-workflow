
rule combine_results:
    input:
        R="workflow/scripts/combine_results.R",
        csv=expand(
            "results/{params}/{{type}}.csv",
            params=paramspace.instance_patterns
        ),
    output:
        csv="results/{type}-results.csv",
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
        rds="results/hp_performance_results_{method}.Rds",
    log:
        "log/combine_hp_perf_{method}.txt",
    benchmark:
        "benchmarks/combine_hp_perf_{method}.txt"
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
            "benchmarks/{params}/run_ml.txt",
            params=paramspace.instance_patterns
        ),
    output:
        csv="results/benchmarks_results.csv",
    log:
        "log/combine_benchmarks.txt",
    conda:
        "../envs/mikropml.yml"
    script:
        "../scripts/combine_benchmarks.R"
