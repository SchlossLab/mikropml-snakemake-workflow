''' Extract variables from the configfile and set default values
'''
args = sys.argv
config_path = (
    args[args.index("--configfile") + 1]
    if "--configfile" in args
    else default_configfile
)

dataset = config["dataset"]
ncores = config["ncores"]
ml_methods = set_default(config, 'ml_method', 'glmnet')
kfold = set_default(config, 'kfold', 5)
outcome_colname = set_default(config, 'outcome_colname', None)
hyperparams = set_default(config, 'hyperparams', None)
find_feature_importance = set_default(config, 'find_feature_importance', False)

nseeds = set_default(config, 'nseeds', 1)
start_seed = 100
seeds = range(start_seed, start_seed + nseeds)
config['seed'] = list(seeds)

# parameter space based on configfile
paramspace = get_paramspace_from_config(config)
# wildcard pattern without seed. needed for rule `combine_hp_performance`
wildcard_no_seed = pattern_drop_wildcard(paramspace, 'seed')
# wildcard pattern with all wildcards _except_ seed having double curly braces for use by `expand()` in rule `combine_hp_performance`
wildcard_tame_seed = pattern_tame_wildcard(paramspace, 'seed')
