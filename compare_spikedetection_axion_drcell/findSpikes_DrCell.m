%%%%% The purpose of the code is to read the output folder TS_SWTEO from DrCell,
%%%%% extract well names from the file names, and output the sum of spikes across all 16
%%%%% electrodes in each file
tic
clear; clc;
% Path to the folder where the files are stored --> iterate over both Control and LSD file
% Prompt user for the path to the Control folder
folder_path_control = input('Enter the path to the Control folder (e.g., */Control_data/RAW/TS): ', 's');

% Prompt user for the path to the LSD folder
folder_path_lsd = input('Enter the path to the LSD folder (e.g., */LSD_data/RAW_LSD/TS): ', 's');

% Read all data ending with _RAW_TS.mat for Control
file_list_control = dir(fullfile(folder_path_control, '*_RAW_TS.mat'));

% Result list with well names and sum of spikes for each well for Control
result_list_control = cell(numel(file_list_control), 2);
%% For Control folder
% Iterate over all files in the Control folder
for i = 1:numel(file_list_control)
    file_name_control = fullfile(folder_path_control, file_list_control(i).name);

    load(file_name_control);
    file_parts_control = strsplit(file_list_control(i).name, '_');
    well_name_control = file_parts_control{end - 2};
    
    % Calculate the sum of temp.SPIKEZ.N
    spikes_sum_control = sum(temp.SPIKEZ.N);
    
    % Save well_name and sum in result_list_control
    result_list_control{i, 1} = well_name_control;
    result_list_control{i, 2} = spikes_sum_control;
end

output_file_control = fullfile(folder_path_control, 'result_list_DrCell_controlspikes.csv');
writecell(result_list_control, output_file_control);

% Read all data ending with _RAW_TS.mat for LSD
file_list_lsd = dir(fullfile(folder_path_lsd, '*_RAW_TS.mat'));

% Result list with well names and sum of spikes for each well for LSD
result_list_lsd = cell(numel(file_list_lsd), 2);
%% For LSD folder
% Iterate over all files in the LSD folder
for i = 1:numel(file_list_lsd)
    file_name_lsd = fullfile(folder_path_lsd, file_list_lsd(i).name);

    load(file_name_lsd);
    file_parts_lsd = strsplit(file_list_lsd(i).name, '_');
    well_name_lsd = file_parts_lsd{end - 2};
    
    % Calculate the sum of temp.SPIKEZ.N
    spikes_sum_lsd = sum(temp.SPIKEZ.N);
    
    % Save well_name and sum in result_list_lsd
    result_list_lsd{i, 1} = well_name_lsd;
    result_list_lsd{i, 2} = spikes_sum_lsd;
end

output_file_lsd = fullfile(folder_path_lsd, 'result_list_DrCell_lsdspikes.csv');
writecell(result_list_lsd, output_file_lsd);

toc
