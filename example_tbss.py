
import tbss_utilities
import glob

# TBSS export parameters
metric_type = 3
bandwidth = 1

# user inputs
# name of the folder where the relevant trk file is
experiment_list = ["hippo_right_cortex_left"]
contrast_list = ["fa", "ad"]

#out_dir_base = "B:/ProjectSpace/hmm56/prototype_dsi_studio_TBSS/20.5xfad.01_AD_BxD77"
out_dir_base = "B:/ProjectSpace/hmm56/prototype_dsi_studio_TBSS/BADEA_vulnerable_networks_in_models_of_ad_risk"

for experiment in experiment_list:
    out_dir = "{}/{}".format(out_dir_base, experiment)
    tract_file = glob.glob("{}/*.tt.gz".format(out_dir))
    tract_file = tract_file[0]
    tract_file = tract_file.replace("\\", "/")

    in_dir = "B:/20.5xfad.01/QSDR/BXD77/average_volumes/all_Ntg"
    tbss_utilities.whole_folder_export(in_dir, tract_file, out_dir, contrast_list, metric_type,  bandwidth)
    in_dir = "B:/20.5xfad.01/QSDR/BXD77/average_volumes/all_tg"
    tbss_utilities.whole_folder_export(in_dir, tract_file, out_dir, contrast_list, metric_type,  bandwidth)
