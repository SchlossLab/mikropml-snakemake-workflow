#!/bin/bash
snakemake -n --dag --configfile config/test.yml | dot -T png > figures/dag.png