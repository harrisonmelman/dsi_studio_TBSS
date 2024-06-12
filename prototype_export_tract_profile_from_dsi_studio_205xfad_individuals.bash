# load fib file into DSI Studio
# load tract file in
# run Tracts -> TractProfile ... ->
    # data sampling strategu = fiber orientation
    # quantitative index = QA (Al thinks that FA would be a much more interesting metric to look at, but dsi studio just shows a blank line there in the plot?)
    # save report data ...
        # save as...


# DEOCUEMNTATNION FROM DSI Studio
# Tract Functions
# Parameters	Description
# tract	Specify the tract file
# output	Use”–output=Tract.txt” to convert the trk file to another format or ROI (assigned output file as NIFTI file)
# export	Export additional information related to the fiber tracts
# Export tract density images

# Use --export=tdi to generate a track density image in the diffusion space. To output in x2, x3, x4 resolution, use tdi2, tdi3, tdi4 (also applied to the following commands).
# Use --export=tdi_color to generate a track color density image.
# Use --export=tdi_end to output only the endpoint.
# Export tract profile

# Use --export=stat to export tract statistics like along tract mean fa, adc, or morphology index such as volume, length, … etc.
# Use --export=report:dti_fa:0:1 to export the tract reports on “fa” values with a profile style at x-direction “0” and a bandwidth of “1”
# The profile style can be the following:

# 0: x-direction
# 1: y-direction
# 2: z-direction
# 3: along tracts
# 4: mean of each tract
# You can export multiple outputs separated by “,”. For example,
# --export=stat,tdi,tdi2 exports track statistics, tract density images (TDI), subvoxel TDI, along tract qa values, and along tract gfa values.

# example export Functions
# dsi_studio --action=ana --source=*.gqi.1.25.fib.gz --export=qa,iso,dti_fa,rd,ad

#dsi_studio="K:/CIVM_Apps/dsi_studio_64/dsi_studio_win_v2023-03-28/dsi_studio.exe";
#dsi_studio="//pwp-civm-ctx01/K/CIVM_Apps/dsi_studio_64/dsi_studio_win_v2023-03-28/dsi_studio.exe";
dsi_studio="K:/CIVM_Apps/dsi_studio_64/dsi_studio_win_v2024-04-11/dsi_studio.exe";

# load fib data
# export tract profile of QA metric, with sampling style 3="along tracts", and with bandwidth=1
#fib_file="B:/22.gaj.49/DMBA/Aligned-Data-RAS/Other/QSDR_fib/N58211NLSAM/nii4D_N58211NLSAM.odf.15um_mdt.qsdr.0.6.R96.fib.gz";
out_dir="B:/ProjectSpace/hmm56/prototype_dsi_studio_TBSS/five_regions_from_len/166_fr";
tract_file="${out_dir}/fr__fasciculus_retroflexus_left_0.4.tt.gz";

bandwidth=1;
sample_strategy=3;

strain_list="all_Ntg all_tg";

contrast_list="dti_fa ad md rd qa iso"
for strain in $strain_list; do
    input_dir="B:/20.5xfad.01/QSDR/BXD77/average_volumes/${strain}";
    for fib_file in $(ls ${input_dir}/nii4d*fib.gz); do
        fib_file=${fib_file%%@};
        fib_file=$(readlink $fib_file);
        runno=$(basename ${fib_file});
        runno=${runno%%.src*};
        runno=${runno##nii4d_};
        for contrast in $contrast_list; do
            out_prefix="${out_dir}/${runno}_${strain##all_}_${contrast}";
            ${dsi_studio} --action=ana --source=${fib_file} --tract=${tract_file} --export=report:${contrast}:${sample_strategy}:${bandwidth} --output=${out_prefix};
            #exit 1;
        done
    done
done


out_dir="B:/ProjectSpace/hmm56/prototype_dsi_studio_TBSS/five_regions_from_len/168_cst/bundle1";
tract_file="${out_dir}/cst__corticospinal_tract_left_0.7_bundle1.tt.gz";

bandwidth=1;
sample_strategy=3;

strain_list="all_Ntg all_tg";

contrast_list="dti_fa ad md rd qa iso"
for strain in $strain_list; do
    input_dir="B:/20.5xfad.01/QSDR/BXD77/average_volumes/${strain}";
    for fib_file in $(ls ${input_dir}/nii4d*fib.gz); do
        fib_file=${fib_file%%@};
        fib_file=$(readlink $fib_file);
        runno=$(basename ${fib_file});
        runno=${runno%%.src*};
        runno=${runno##nii4d_};
        for contrast in $contrast_list; do
            out_prefix="${out_dir}/${runno}_${strain##all_}_${contrast}";
            ${dsi_studio} --action=ana --source=${fib_file} --tract=${tract_file} --export=report:${contrast}:${sample_strategy}:${bandwidth} --output=${out_prefix};
            #exit 1;
        done
    done
done


out_dir="B:/ProjectSpace/hmm56/prototype_dsi_studio_TBSS/five_regions_from_len/168_cst/bundle2";
tract_file="${out_dir}/cst__corticospinal_tract_left_0.7_bundle2.tt.gz";

bandwidth=1;
sample_strategy=3;

strain_list="all_Ntg all_tg";

contrast_list="dti_fa ad md rd qa iso"
for strain in $strain_list; do
    input_dir="B:/20.5xfad.01/QSDR/BXD77/average_volumes/${strain}";
    for fib_file in $(ls ${input_dir}/nii4d*fib.gz); do
        fib_file=${fib_file%%@};
        fib_file=$(readlink $fib_file);
        runno=$(basename ${fib_file});
        runno=${runno%%.src*};
        runno=${runno##nii4d_};
        for contrast in $contrast_list; do
            out_prefix="${out_dir}/${runno}_${strain##all_}_${contrast}";
            ${dsi_studio} --action=ana --source=${fib_file} --tract=${tract_file} --export=report:${contrast}:${sample_strategy}:${bandwidth} --output=${out_prefix};
            #exit 1;
        done
    done
done


exit 1;
# old code
for x in N58211 N58646 N58656 N58981 N59007; do
    fib_file="B:/22.gaj.49/DMBA/Aligned-Data-RAS/Other/QSDR_fib/${x}NLSAM/nii4D_${x}*fib.gz";
    out_prefix="B:/ProjectSpace/hmm56/prototype_dsi_studio_TBSS/20.5xfad.01_AD_BxD77/threshold_0.6_experiment_0/${x}";
    ${dsi_studio} --action=ana --source=${fib_file} --tract=${tract_file} --export=report:${contrast}:${sample_strategy}:${bandwidth} --output=${out_prefix};
done


fib_file="B:/22.gaj.49/DMBA/Aligned-Data-RAS/Other/QSDR_fib/template_mean/template.mean.fib.gz";
out_prefix="B:/ProjectSpace/hmm56/prototype_dsi_studio_TBSS/DMBA_comparative/template_whole_brain_track/threshold_0.6_experiment_0/template";
${dsi_studio} --action=ana --source=${fib_file} --tract=${tract_file} --export=report:${contrast}:${sample_strategy}:${bandwidth} --output=$out_prefix;
