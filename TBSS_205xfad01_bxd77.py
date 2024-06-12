import tbss_utilities
import glob

# part for average (QSDR) volumes
contrast_list = ["fa", "ad"]
metric_type = 3
bandwidth = 1

experiment_list = ["ntgAVG_track_cerebellum_test_0",
                   "ntgAVG_track_cerebellum_test_1",
                   "ntgAVG_track_cerebellum_test_2",
                   "ntgAVG_track_brainstem_test"]

#group_list = ["Ntg", "tg"]

out_dir_base = "B:/ProjectSpace/hmm56/prototype_dsi_studio_TBSS/20.5xfad.01_AD_BxD77"

for experiment in experiment_list:
    out_dir = "{}/{}".format(out_dir_base, experiment)
    tract_file = glob.glob("{}/*.tt.gz".format(out_dir))
    tract_file = tract_file[0]
    tract_file = tract_file.replace("\\", "/")

    in_dir = "B:/20.5xfad.01/QSDR/BXD77/average_volumes/all_Ntg"
    tbss_utilities.whole_folder_export(in_dir, tract_file, out_dir, contrast_list, metric_type,  bandwidth)
    in_dir = "B:/20.5xfad.01/QSDR/BXD77/average_volumes/all_tg"
    tbss_utilities.whole_folder_export(in_dir, tract_file, out_dir, contrast_list, metric_type,  bandwidth)
