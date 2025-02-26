import os
import pathlib
import subprocess
import tempfile

smk_cmd = ('snakemake -c 2 '
        '-s ../../workflow/Snakefile '
        '--configfile ../config/test.yaml '
        '--use-conda --conda-frontend mamba '
        )

def compare_files(filename1, filename2):
    with open(filename1, 'r') as infile:
        f1 = infile.read()
    with open(filename2, 'r') as infile:
        f2 = infile.read()
    return f1 == f2

def test_snakemake():
    #curr_wd = os.getcwd()
    tmp_dir = pathlib.Path('tests/tmp')
    #os.mkdir(tmp_dir)
    #os.chdir(tmp_dir)
    #out = subprocess.run(smk_cmd, shell=True, text=True, check=True, capture_output=True)
    #os.chdir(curr_wd)
    results = ('results/otu-micro/performance_results.csv',)
    assertions = [compare_files(pathlib.Path('tests')/ 'snap'/ fname,
                                tmp_dir / fname) for fname in results]
    assert all(assertions)
