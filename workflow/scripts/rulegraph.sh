#!/bin/bash
snakemake -n --rulegraph --configfile config/test.yml | dot -T png > figures/rulegraph.png