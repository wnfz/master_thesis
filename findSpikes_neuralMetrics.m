%%%%%%% author: Wenus Nafez
%%%%%%% This code iterates over all _neuralMetrics files and saves
%%%%%%% the number of spikes for wells with LSD /without LSD (= control) in
%%%%%%% separate .csv files, puts both files in one folder
tic
clear; clc;
folder = '/Users/yasserjalali/Desktop/';

% List all files with the ending "_neuralMetrics.csv"
files = dir(fullfile(folder, '*_neuralMetrics.csv'));
wells_control = {'B1', 'C6', 'D3', 'D4', 'D5', 'D6'};
% Iterate over all files
for k = 1:numel(files)
    % Current file
    file_path = fullfile(folder, files(k).name);
    
    % Open the file for reading
    fid = fopen(file_path, 'r');
    number_of_spikes_line = '';
    found_line = '';

    % Search through the file line by line
    while ~feof(fid)
        line = fgetl(fid);
        if contains(line, 'Treatment/ID')
            % If "Treatment/ID" is found in the line, save it and exit the loop
            found_line = line;
            break;
        end
    end
    fclose(fid);

    % Split the line into its components using semicolons, treating empty values
    % as individual columns
    line_components = strsplit(found_line, ';', 'CollapseDelimiters', false);

    % Search for columns containing "LSD [10 mikroM]" and save their column numbers
    columns_with_lsd = [];
    for i = 1:numel(line_components)
        if contains(line_components{i}, 'LSD [10 mikroM]')
            columns_with_lsd = [columns_with_lsd, i];
        end
    end
    
    % Initialize a variable to store the line with "Number of Spikes"
    fid = fopen(file_path, 'r');
    % Search through the file line by line
    while ~feof(fid)
        line = fgetl(fid);
        if contains(line, '    Number of Spikes;')
            % If "Number of Spikes" is found in the line, save it and exit the loop
            number_of_spikes_line = line;
        end
        if contains(line, 'Well Averages')
            well_line = line;
        end
    end
    fclose(fid);
    % Initialize the list for control spikes
    control_spikes = [];

    % Search for the line with 'Well Averages'
    fid = fopen(file_path, 'r');
    while ~feof(fid)
        line = fgetl(fid);
        if contains(line, 'Well Averages')
            well_line = line;
            break;
        end
    end
    fclose(fid);

    % Split the line into its components using semicolons
    wells_values = strsplit(well_line, ';', 'CollapseDelimiters', false);

    % Remove the first cell 'Well Averages'
    wells_values = wells_values(2:end);
    number_of_spikes_values = strsplit(number_of_spikes_line, ';', 'CollapseDelimiters', false);

    % Iterate over wells in the control list
    for i = 1:numel(wells_control)
        well_index = find(strcmp(wells_control{i}, wells_values));
        well_value = number_of_spikes_values{well_index + 1};
        control_spikes = [control_spikes, str2double(well_value)];
    end

    % Split the line into its components using semicolons
    number_of_spikes_values = strsplit(number_of_spikes_line, ';');

    % Extract values only from the columns specified in columns_with_lsd
    spikes_lsd = str2double(number_of_spikes_values(columns_with_lsd));
    wells = strsplit(well_line, ';');
    wells_lsd = wells(columns_with_lsd);

    % Result list for LSD spikes
    result_list_lsd = cell(length(wells_lsd), 2);

    % Add "wells_lsd" to the first column and "spikes_lsd" to the second column
    result_list_lsd(:, 1) = wells_lsd;
    result_list_lsd(:, 2) = num2cell(spikes_lsd);

    % Result list for control spikes
    result_list_control = cell(length(wells_control), 2);
    result_list_control(:, 1) = wells_control;
    result_list_control(:, 2) = num2cell(control_spikes);

    % Generate the filename for the result file
    [~, name, ~] = fileparts(file_path);
    output_folder = fullfile(folder, [name, '_Axion_spikes']);
    
    % Create the folder if it does not exist
    if ~exist(output_folder, 'dir')
        mkdir(output_folder);
    end

    % Save spike data for LSD data
    output_file_lsd = fullfile(output_folder, [name, '_lsdspikes.csv']);
    writecell(result_list_lsd, output_file_lsd);

    % Save spike data for control data
    output_file_control = fullfile(output_folder, [name, '_controlspikes.csv']);
    writecell(result_list_control, output_file_control);
end
toc
