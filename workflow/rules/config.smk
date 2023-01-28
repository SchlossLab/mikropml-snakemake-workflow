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

hyperparams = config["hyperparams"] if "hyperparams" in config else None
find_feature_importance = config["find_feature_importance"] if "find_feature_importance" in config else None
