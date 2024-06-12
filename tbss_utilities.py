# a collection of functions to be used in DSI Studio TBSS
# includes export tract profiles and plotting
# statistical analysis and more to come
import subprocess
import glob
import os
DSI_STUDIO = "K:/CIVM_Apps/dsi_studio_64/dsi_studio_win_v2024-04-11/dsi_studio.exe"


def export_tract_profiles(fib_file, tract_file, out_dir, contrast_list=None, metric_type=3, bandwidth=1):
    """Export the tract profile data to a .txt file.

    Keyword arguments:
    contrast_list -- list of contrasts to export statistics from (default ["ad", "fa"])
    metric_type -- 3 gives tract profile. 0, 1, or 2 gives the x, y, or z component data, respectively (default 3)
    bandwidth -- bandwidth of the tBSS sampling scheme. Only accepts whole numbers (default 1)
    """
    # why did I set my default contrast_list this way? as None and then set it in the body?
    # for safety from mutable default values:
    # https://stackoverflow.com/questions/18141652/python-function-with-default-list-argument
    if contrast_list is None:
        contrast_list = ["ad", "fa"]
    export_string = setup_export_argument(contrast_list, metric_type, bandwidth)
    # out_prefix="B:/ProjectSpace/hmm56/prototype_dsi_studio_TBSS/20.5xfad.01_AD_BxD77/0.6_region_0_individuals/${runno}_${strain##all_}_${contrast}";
    runno = get_runno_from_fib_file(fib_file)
    out_prefix = "{}/{}".format(out_dir, runno)
    cmd = "{} --action=ana --source={} --tract={} {} --output={}".format(DSI_STUDIO, fib_file, tract_file, export_string, out_prefix)
    print(cmd)
    subprocess.run(cmd)


def setup_export_argument(contrast_list, metric_type, bandwidth):
    #  --export=report:ad:3:1,report:qa:3:1
    s = ""
    for contrast in contrast_list:
        s = "{}report:{}:{}:{},".format(s, contrast, metric_type, bandwidth)
    # remove the final trailing comma
    s = s[:-1]
    s = "--export={}".format(s)
    return s


def whole_folder_export(dirname, tract_file, out_dir, contrast_list, metric_type, bandwidth):
    file_list = glob.glob("{}/*.fib.gz".format(dirname))
    for fib_file in file_list:
        fib_file = fib_file.replace("\\", "/")
        if fib_file.endswith("@"):
            # sometimes when we have a symlink, the ls command will att an @ to the end of it. clear it.
            fib_file = fib_file[:-1]
        try:
            # this throws an exception if fib_file is not a link (if it is a real file)
            fib_file = os.readlink(fib_file)
        except OSError:
            continue
        fib_file = fib_file.replace("\\", "/")
        export_tract_profiles(fib_file, tract_file, out_dir, contrast_list, metric_type, bandwidth)


def get_runno_from_fib_file(fib_file):
    """this likely only works for nii4d_${runno}.blahblahblah_blah
    but this SHOULD also work for the QSDR template, giving us 'template'
    """
    fib_file = os.path.basename(fib_file)
    runno = fib_file.split(".")
    runno = runno[0]
    runno = runno.split("_")
    # for template.mean, will be the first (only) entry. for nii4d_N12345NLSAM, it will be the second (last) entry
    runno = runno[-1]
    return runno


# TODO: this does not work
def glob_and_fix_slashes(pattern):
    a = glob.glob(pattern)
    for entry in a:
        entry.replace("\\", "/")
    return a
