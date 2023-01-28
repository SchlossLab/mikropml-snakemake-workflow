import pandas as pd
from snakemake.utils import Paramspace

from .functions import *

config = {'dataset': 'otu_large', 
        'seed': list(range(2)),
        'ml_method': ['glmnet', 'rf']}
params = Paramspace(pd.DataFrame(config), param_sep = '-')

def test_pattern_tame_wildcard():
    assert pattern_tame_wildcard(params, 'seed') == 'dataset-{{dataset}}/seed-{seed}/ml_method-{{ml_method}}'
    assert pattern_tame_wildcard(params, 'dataset') == 'dataset-{dataset}/seed-{{seed}}/ml_method-{{ml_method}}'

def test_pattern_drop_wildcard():
    assert pattern_drop_wildcard(params, 'seed') == 'dataset-{dataset}/ml_method-{ml_method}'
    assert pattern_drop_wildcard(params, 'dataset') == 'seed-{seed}/ml_method-{ml_method}'
    assert pattern_drop_wildcard(params, 'ml_method') == 'dataset-{dataset}/seed-{seed}'

def test_instances_drop_wildcard():
    assert instances_drop_wildcard(params, 'seed') == ['dataset-otu_large/ml_method-glmnet', 'dataset-otu_large/ml_method-rf']
    assert instances_drop_wildcard(params, 'dataset') == ['seed-0/ml_method-glmnet', 'seed-1/ml_method-rf']
    assert instances_drop_wildcard(params, 'ml_method') == ['dataset-otu_large/seed-0', 'dataset-otu_large/seed-1']
