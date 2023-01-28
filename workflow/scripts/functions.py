import re

def pattern_tame_wildcard(paramspace, wildcard):
    ''' Tame a wildcard in a pattern by doubling up curly braces on all other wildcards. This is useful for filling in values with expand().

    :param paramspace: a paramspace
    :type paramspace: class:`snakemake.utils.Paramspace` 
    :param wildcard: a wildcard in the paramspace
    :type wildcard: str

    :return: wildcard pattern from paramspace without the wildcard
    :rtype: str
    '''
    return re.sub(f"{{((?!{wildcard})[a-zA-Z_0-9]*)}}", "{{\\1}}", paramspace.wildcard_pattern)

def pattern_drop_wildcard(paramspace, wildcard):
    """ Remove a wildcard from the wildcard pattern

    :param paramspace: a paramspace
    :type paramspace: class:`snakemake.utils.Paramspace` 
    :param wildcard: a wildcard in the paramspace
    :type wildcard: str

    :return: wildcard pattern from paramspace without the wildcard
    :rtype: str
    """
    return re.sub(f"/{{0,1}}{wildcard}{paramspace.param_sep}{{{wildcard}}}", "", paramspace.wildcard_pattern).strip('/')

def instances_drop_wildcard(paramspace, wildcard):
    ''' Remove a wildcard from instance patterns
    
    :param paramspace: a paramspace
    :type paramspace: class:`snakemake.utils.Paramspace` 
    :param wildcard: a wildcard in the paramspace
    :type wildcard: str

    :return: list of instance patterns from paramspace without the wildcard
    :rtype: list
    '''
    return [re.sub(f"/{{0,1}}{wildcard}{paramspace.param_sep}[a-zA-Z_0-9]*", "", i).strip("/") for i in paramspace.instance_patterns]
