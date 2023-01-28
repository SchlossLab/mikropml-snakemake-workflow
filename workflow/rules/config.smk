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
ml_methods = config["ml_method"] if 'ml_method' in config else 'glmnet'
kfold = config["kfold"] if "kfold" in config else 5
outcome_colname = config["outcome_colname"] if "outcome_colname" in config else None

nseeds = config["nseeds"] if 'nseeds' in config else 1
start_seed = 100
seeds = range(start_seed, start_seed + nseeds)
config['seed'] = list(seeds)

hyperparams = config["hyperparams"] if "hyperparams" in config else None
find_feature_importance = config["find_feature_importance"] if "find_feature_importance" in config else None

# parameter space based on configfile
paramspace = get_paramspace_from_config(config)
# wildcard pattern without seed. needed for rule `combine_hp_performance`
wildcard_no_seed = pattern_drop_wildcard(paramspace, 'seed')
# wildcard pattern with all wildcards _except_ seed having double curly braces for use by `expand()` in rule `combine_hp_performance`
wildcard_tame_seed = pattern_tame_wildcard(paramspace, 'seed')