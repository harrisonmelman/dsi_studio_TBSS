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
contrast_list = {'ad', 'qa', 'dti_fa'};
contrast = 'md';
in_dir = 'B:\ProjectSpace\hmm56\prototype_dsi_studio_TBSS\20.5xfad.01_AD_BxD77\0.6_region_0_individuals';
figure; hold on;

ntg_runno_list = {'N59130NLSAM', 'N59132NLSAM', 'N60042NLSAM', 'N60141NLSAM', 'N60155NLSAM', 'N60165NLSAM', 'N60171NLSAM', 'N60206NLSAM', 'N60215NLSAM'};
tg_runno_list = {'N59128NLSAM', 'N59134NLSAM', 'N60044NLSAM', 'N60047NLSAM', 'N60076NLSAM', 'N60135NLSAM', 'N60143NLSAM', 'N60145NLSAM', 'N60147NLSAM', 'N60149NLSAM', 'N60151NLSAM', 'N60153NLSAM', 'N60208NLSAM', 'N60213NLSAM'};
runnos = {'all_ntg', 'all_tg'};
color = {'k', 'g', 'b', 'c', 'm', 'r'};
%color = {'k', 'r', 'r', 'r', 'r', 'r'};

% loop through and plot all NTG in red
% then loop through plot all TG in green

% THIS should be a function 'plot one group??'
% ntg plotting
color = 'k';
legend_title = 'ntg';
grouptag = 'Ntg';
runnos = ntg_runno_list;
for i=1:length(runnos)
    % auto-exported filename ex: N60044NLSAM_tg_qa.report.qa.3.1.txt
    in_file = strcat(in_dir, '\', runnos{i}, '_', grouptag, '_', contrast, '.report.', contrast, '.3.1.txt');
    [x, y, y_CI_min, y_CI_max] = extract_values_and_CI_from_dsi_studio_tract_profile_report_4row(in_file);
    if i==1
        % if it is the first one, then populate the legend (all ntg same color, all tg same color, so only need one legend per group)
        plot_one_profile(x, y, color, legend_title);
    else
        plot_one_profile(x, y, color);
    end
end




% tg plotting
color='r';
legend_title = 'tg';
grouptag = 'tg';
runnos = tg_runno_list;
for i=1:length(runnos)
    in_file = strcat(in_dir, '\', runnos{i}, '_', grouptag, '_', contrast, '.report.', contrast, '.3.1.txt');
    [x, y, y_CI_min, y_CI_max] = extract_values_and_CI_from_dsi_studio_tract_profile_report_4row(in_file);
    if i==1
        plot_one_profile(x, y, color, legend_title);
    else
        plot_one_profile(x, y, color);
    end
end

title(contrast);
hold off;

%% functions

% this function used for 
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
        disp('ADDING A LEGEND');
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
