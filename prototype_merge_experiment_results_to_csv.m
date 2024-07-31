
% exploring the DSI Studio tract profile functionality
% exported the tract profile data into
    % B:\ProjectSpace\hmm56\prototype_dsi_studio_TBSS\DMBA_comparative\template_whole_brain_track\threshold_0.6_experiment_0
    % here, tracking was performed on DMBA template.mean.fib.gz
        % whole brain tracking
        % other parameters
    % then a small tract through X region was selected, This is a very
    % strong WM bundle
        % this was exported and loaded in to all 5 template fib files
        % N58211, N58646, N58656, N58981, N59007
        % and the tract profile was saved along this fiber bundle for each
% in DSI Studio, the only visualization provided is a simple plot, one
% specimen at a time.
% here, I seek to improve that by plotting the tract profile for each
% individual and the template in the same plot.
% I can also include confidence intervals

% understanding the tract profile output file:
% tab separated value txt file
% first column for both rowss is "headers", just the name of the track file
% profile was pulled from
% first row is index, 0...99
% second row is [values 0...99] "CI" [confidence interval lower bounds
% 0...99] "CI" [confidence interval upper bounds 0...99]
% unsure if the bundle is always broken up into 100 bands, or if it depends
% on length

%% 20.5xfad.01 bxd77 testing
% using tract profiles extracted from INDIVIDUALS (in DMBA/QSDR space)
% read data from file
% use nexttile
% this is used to indicate which report reader function to use.
% cli and giu-exported reports have different formatting
cli_export = 1;
contrast_list = {'ad', 'fa', 'iso', 'md', 'qa', 'rd'};
contrast_list = {'ad', 'fa'};
project_code = '20.5xfad.01';
identifier = 'BXD77';
ntg_runno_list = {'N59130NLSAM', 'N59132NLSAM', 'N60042NLSAM', 'N60141NLSAM', 'N60155NLSAM', 'N60165NLSAM', 'N60171NLSAM', 'N60206NLSAM', 'N60215NLSAM'};
tg_runno_list = {'N59128NLSAM', 'N59134NLSAM', 'N60044NLSAM', 'N60047NLSAM', 'N60076NLSAM', 'N60135NLSAM', 'N60143NLSAM', 'N60145NLSAM', 'N60147NLSAM', 'N60149NLSAM', 'N60151NLSAM', 'N60153NLSAM', 'N60208NLSAM', 'N60213NLSAM'};

in_dir_base = 'B:\ProjectSpace\hmm56\prototype_dsi_studio_TBSS\BADEA_vulnerable_networks_in_models_of_ad_risk';
out_dir_base = 'B:\ProjectSpace\hmm56\prototype_dsi_studio_TBSS';

% TODO: smart organization of this (or of my data)
% currently, I have 3 "levels" of organization
    % OUTER -- this set of experiments is focused on a broader question.
        % Like "badea papers" or "five_regions_from_len" or "QSDR_vs_native"
    % experiment -- Specifies what RCCF ROIs and QA threshold used for
        % tracking
    % bundles -- If it makes sense, subdivide the tractography generated
        % from the ROI into distinct bundles to analyze separately. This makes
        % sense if there are multiple branching bundles going through the ROI
%% EXAMPLE for when you do not have any sub-bundles
% experiment_list = {'hippo_right_cortex_left'};
% experiment = 'hippo_right_cortex_left';
% for i=1:length(experiment_list)
%     experiment = experiment_list{i};
%     in_dir = strcat('B:\ProjectSpace\hmm56\prototype_dsi_studio_TBSS\BADEA_vulnerable_networks_in_models_of_ad_risk\', experiment);
%     out_file = strcat('B:\ProjectSpace\hmm56\prototype_dsi_studio_TBSS\prototype_matlab_csv_export_', experiment, '.txt');
%     [column_names, data_csv] = make_multicontrast_csv(out_file, ntg_runno_list, 'Ntg_all', tg_runno_list, 'tg_all', contrast_list, in_dir, cli_export);
% end
%% EXAMPLE with sub-bundles
experiment_list = {'hippo_right_cortex_left', '159_optc_0.5'};
experiment = 'hippo_right_cortex_left';
for i=1:length(experiment_list)
    experiment = experiment_list{i};
    in_dir_exp = strcat(in_dir_base, '\', experiment);
    % returns a struct
    bundle_list = dir(strcat(in_dir_exp, '\', 'bundle*'));
    % TODO: only run this for loop IF we have at least one bundle
    % if no bundle folders detected, then fall back to the previous method
    if length(bundle_list) > 0
        for j=1:length(bundle_list)
            bundle = bundle_list(j).name;
            in_dir = strcat(in_dir_exp, '\', bundle);
            % ex 20.5xfad.01_BXD77_172_scp_0.5_bundle1_TBSS_export.txt
            out_file = strcat(out_dir_base, '\', project_code, '_', identifier, '_', experiment, '_', bundle, '_TBSS_export.txt');
            [column_names, data_csv] = make_multicontrast_csv(out_file, ntg_runno_list, 'Ntg_all', tg_runno_list, 'tg_all', contrast_list, in_dir, cli_export);
        end
    else
        in_dir = in_dir_exp;
        out_file = strcat(out_dir_base, '\', project_code, '_', identifier, '_', experiment, '_TBSS_export.txt');
        [column_names, data_csv] = make_multicontrast_csv(out_file, ntg_runno_list, 'Ntg_all', tg_runno_list, 'tg_all', contrast_list, in_dir, cli_export);
        
    end
end
%% functions

% loop through contrast list
% load data and create a master csv file with all runnos and all contrasts
% TBSS in dsi studio always gives us 100 timepoints/pseudovoxels
% each row is a pseudovoxel
% will contain columns for: $runno_$contrast_val,
% $runno_$contrast_CI_lower,
% $runno_$contrast_CI_upper, 
% group information (gene_status, age, sex, strain, etc)
function [column_names, data_csv] = make_multicontrast_csv(out_file, group1, group1_name, group2, group2_name, contrast_list, in_dir, cli_export)
    % estimate csv size for preallocation
    % 100 data points, plus columns for gene_status, runno, contrast
    % add more columns later for more refined groupings
    num_cols = 104;
    % TIMES 3 if you include the confidence intervals. keep off for test
    num_rows = 1 * (length(group1) + length(group2)) * length(contrast_list);
    % use a cell array to put both numerical and categorical data in
    data_csv = {};
    row_names = {};
    column_names = {'name', 'runno', 'contrast', 'group'};
    % TODO: fix this so that you don't copy and paste the for loop twice
    % for 2 groups...
    custom_name = 'QSDR_QSDR';
    for i=1:length(contrast_list)
        contrast = contrast_list{i};
        group_name = group1_name;
        runno_list = group1;
        for j=1:length(runno_list)
            runno = runno_list{j};
            % TODO: make finding input files a function in itself
            % AND AND be more consistnet with naming tract profile files
            %in_file = strcat(in_dir, '\', runno, '_', group_name, '_', contrast, '.report.', contrast, '.3.1.txt');
            in_file = strcat(in_dir, '\', runno, '.report.', contrast, '.3.1.txt');
            [~, y, y_CI_min, y_CI_max] = extract_values_and_CI_from_dsi_studio_tract_profile_report_4row(in_file);
            y = num2cell(y);
            y = [in_file, runno, contrast, group_name, y];
            %y = [in_file, runno, contrast, group_name, custom_name, y];
            % for testing, just the simple values
            %new_columns = {strcat(runno,'_',contrast,'_val'), strcat(runno,'_',contrast,'_CI_lower'), strcat(runno,'_',contrast,'_CI_upper')};
            new_rows = {strcat(runno,'_',contrast,'_val')};
            row_names = [row_names, new_rows];
            data_csv = [data_csv; y];
        end

        group_name = group2_name;
        runno_list = group2;
        for j=1:length(runno_list)
            runno = runno_list{j};
            in_file = strcat(in_dir, '\', runno, '.report.', contrast, '.3.1.txt');
            [x, y, y_CI_min, y_CI_max] = extract_values_and_CI_from_dsi_studio_tract_profile_report_4row(in_file);
            y = num2cell(y);
            y = [in_file, runno, contrast, group_name, y];
            %y = [in_file, runno, contrast, group_name, custom_name, y];
            new_rows = {strcat(runno,'_',contrast,'_val')};
            row_names = [row_names, new_rows];
            data_csv = [data_csv; y];
        end
    end

    % write cell array to file
    writecell(data_csv, out_file, 'Delimiter','tab');
end

% use this function if reports were manually exported fromdsi studio GUI
function [x, y, y_CI_min, y_CI_max] = extract_values_and_CI_from_dsi_studio_tract_profile_report(in_file)
    A = readtable(in_file, delimiter='\t');
    % first row is the indices, start at column 2 because 1st is a title
    % second row is the y values, then upper and lower CI's, split these up
    x = A(1,2:101);
    y = A(2,2:101);
    y_CI_min = A(2,103:202);
    y_CI_max = A(2,204:303);
    % convert all from table to array
    x = table2array(x);
    y = table2array(y);
    y_CI_min = table2array(y_CI_min);
    y_CI_max = table2array(y_CI_max);
    % convert all from row to column vectors
    % this was NOT NECESSARY
    %x = x';
    %y = y';
    %y_CI_min = y_CI_min';
    %y_CI_max = y_CI_max';
end

% use this function if reports were exported from the CLI
function [x, y, y_CI_min, y_CI_max] = extract_values_and_CI_from_dsi_studio_tract_profile_report_4row(in_file)
    A = readtable(in_file, delimiter='\t');
    % first row is the indices, start at column 2 because 1st is a title
    % second row is the y values, then upper and lower CI's, split these up
    x = A(1,2:101);
    y = A(2,2:101);
    %y_CI_min = A(2,103:202);
    %y_CI_max = A(2,204:303);
    y_CI_min = A(3,2:101);
    y_CI_max = A(4,2:101);
    % convert all from table to array
    x = table2array(x);
    y = table2array(y);
    y_CI_min = table2array(y_CI_min);
    y_CI_max = table2array(y_CI_max);
    % convert all from row to column vectors
    % this was NOT NECESSARY
    %x = x';
    %y = y';
    %y_CI_min = y_CI_min';
    %y_CI_max = y_CI_max';
end

