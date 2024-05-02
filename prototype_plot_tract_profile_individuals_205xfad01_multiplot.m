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
contrast_list = {'ad', 'qa', 'dti_fa'};
contrast = 'md';
in_dir = 'B:\ProjectSpace\hmm56\prototype_dsi_studio_TBSS\20.5xfad.01_AD_BxD77\0.6_region_0_individuals';

ntg_runno_list = {'N59130NLSAM', 'N59132NLSAM', 'N60042NLSAM', 'N60141NLSAM', 'N60155NLSAM', 'N60165NLSAM', 'N60171NLSAM', 'N60206NLSAM', 'N60215NLSAM'};
tg_runno_list = {'N59128NLSAM', 'N59134NLSAM', 'N60044NLSAM', 'N60047NLSAM', 'N60076NLSAM', 'N60135NLSAM', 'N60143NLSAM', 'N60145NLSAM', 'N60147NLSAM', 'N60149NLSAM', 'N60151NLSAM', 'N60153NLSAM', 'N60208NLSAM', 'N60213NLSAM'};
runnos = {'all_ntg', 'all_tg'};
color = {'k', 'g', 'b', 'c', 'm', 'r'};
%color = {'k', 'r', 'r', 'r', 'r', 'r'};

% loop through and plot all NTG in red
% then loop through plot all TG in green

make_multicontrast_figure(ntg_runno_list, 'ntg', tg_runno_list, 'tg', contrast_list, in_dir, cli_export);


%% functions

% loop through contrast list
% newtile and run plot_one_contrast_title for each
function make_multicontrast_figure(group1, group1_name, group2, group2_name, contrast_list, in_dir, cli_export)
    figure('name', '20.5xfad.01 ntg (black) vs tg (green)');
    hold on;
    for i=1:length(contrast_list)
        contrast = contrast_list{i};
        % this needs to be ran before the first tile is plotted
        nexttile;
        % and we need another layer of hold on/off for the TILE
        % the first set at beginning of this function only holds for the
        % outer figure, this one is for the sub figure
        hold on;
        plot_one_contrast_tile(group1, group1_name, group2, group2_name, contrast, in_dir, cli_export);
        hold off;
    end
    hold off;
end

% creates one figure tile, and plots both groups into it
function plot_one_contrast_tile(group1, group1_name, group2, group2_name, contrast, in_dir, cli_export)
    % ntg plotting
    color = 'k';
    group_name = 'Ntg';
    plot_one_group(group1, group1_name, contrast, color, group_name, in_dir, cli_export);

    % tg plotting
    color='r';
    % group_name is legend_title
    group_name = 'tg';
    plot_one_group(group2, group2_name, contrast, color, group_name, in_dir, cli_export);
    % set the title for this tile in the figure
    title(contrast);
end


% plots only one group into one figure tile (one contrast)
% this is half of one "tile"
function plot_one_group(runno_list, legend_title, contrast, color, group_name, in_dir, cli_export)
    for i=1:length(runno_list)
        runno = runno_list{i};
        % TODO: take this specific pattern matching OUT of a deep function
        in_file = strcat(in_dir, '\', runno, '_', group_name, '_', contrast, '.report.', contrast, '.3.1.txt');
        % TODO: move this check into the extract values function and squash
        % that into a single function
        if cli_export
            [x, y, y_CI_min, y_CI_max] = extract_values_and_CI_from_dsi_studio_tract_profile_report_4row(in_file);
        else
            [x, y, y_CI_min, y_CI_max] = extract_values_and_CI_from_dsi_studio_tract_profile_report(in_file);
        end
        if i==1
            plot_one_profile(x, y, color, legend_title);
        else
            plot_one_profile(x, y, color);
        end
    end
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

function plot_one_profile(x, y, color, legend_title)
    if nargin < 4
        legend_title=0;
    end
    value_format = strcat(color, '-');
    if legend_title
        % TODO: this does not work.
        % want to (only sometimes) add legend key for a plot
        % if I use the legend() function at the end it goes in order
        % but I plot all ntg, and then all tg, so I can't properly label
        % after the fact
        % and if i use it multiple times, then it overwrites what was on
        % there previously
        %disp('ADDING A LEGEND');
        plot(x,y,value_format, 'DisplayName', legend_title);
    else
        plot(x,y,value_format); 
    end
end

function plot_one_confidence_interval(x, y_CI_min, y_CI_max, color)
    % concat upper and lower bounds CI into a 2xn column vector
    % stolen from https://www.mathworks.com/help/matlab/creating_plots/line-plot-with-confidence-bounds.html
    x_CI = [x x(end:-1:1)];
    y_CI = [y_CI_min y_CI_max(end:-1:1)];
    p = fill(x_CI,y_CI,color);
    p.FaceAlpha = 0.1;
    p.FaceColor = color;
    %p.EdgeColor = 'none';
    p.EdgeColor = color;
end
