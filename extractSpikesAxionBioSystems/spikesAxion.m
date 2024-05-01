tic
clear; clc;

%% This code iterates over a folder containing neuralMetrics data and extracts the number of spikes for each well 
%% and stores the results in a separate .csv (same code will work for number of bursts, synchrony etc., 
%% line 38 just needs to be adjusted.)

% Prompt asking for folder containing all neuralMetrics data
folder = input('Enter the folder path containing the _neuralMetrics.csv files: ', 's');

% Initialise well names (for header later)
well_names = {};

% Iterate over all the files with the ending "_neuralMetrics.csv"
files = dir(fullfile(folder, '*_neuralMetrics.csv'));

all_dates = {};
all_num_spikes = {};

% Iterate over all files
for k = 1:numel(files)
    file_path = fullfile(folder, files(k).name);
    
    % Extract date from filename
    [~, name, ~] = fileparts(files(k).name);
    file_date = extractDate(name);
    all_dates{end+1} = file_date;

    fid = fopen(file_path, 'r');
    well_line = '';
    spike_line = '';

    % Search for the rows containing the line 'Well Averages' and 'Number of Spikes'
    while ~feof(fid)
        line = fgetl(fid);
        if contains(line, 'Well Averages')
            well_line = line;
        end
        if contains(line, '    Number of Spikes;')
            spike_line = line;
        end
    end
    fclose(fid);

    % Split the well line into its components 
    wells_values = strsplit(well_line, ';', 'CollapseDelimiters', false);

    % Remove the first cell 'Well Averages'
    wells_values = wells_values(2:end);

    % Store the well names, according to needs
    if isempty(well_names)
        well_names = wells_values(1:6); % Store only the first six well names
    end
    
    % Split the spike line into its components 
    spikes_values = strsplit(spike_line, ';', 'CollapseDelimiters', false);

    % Remove the first cell 'Number of Spikes'
    spikes_values = spikes_values(2:end);

    % Add the data to the corresponding cell arrays
    all_num_spikes{end+1} = spikes_values(1:6); % Store only the first six spike values
end

% Generate the filename for the result file
output_file = fullfile(folder, 'combined_well_spikes.csv');

% Write the data to a CSV file
writeToCSV(output_file, all_dates, all_num_spikes, well_names);

toc

function date_str = extractDate(filename)
    % Extracts date in the format DDMMYYYY from the filename --> Format is
    % same for all files!
    date_str = regexp(filename, '\d{8}', 'match', 'once');
end

function writeToCSV(output_file, all_dates, all_num_spikes, well_names)
    % Write data to CSV file
    fid = fopen(output_file, 'w');

    % Write header
    fprintf(fid, 'Date');
    for i = 1:numel(well_names)
        fprintf(fid, ',%s', well_names{i});
    end
    fprintf(fid, '\n');

    % Write data
    num_files = numel(all_dates);
    for i = 1:num_files
        date = all_dates{i};
        num_spikes = all_num_spikes{i};


        fprintf(fid, '%s', date);
        
        % Write number of spikes for each well
        for j = 1:numel(well_names)
            if j <= numel(num_spikes)
                fprintf(fid, ',%s', num_spikes{j});
            else
                fprintf(fid, ',');
            end
        end
        fprintf(fid, '\n');
    end

    fclose(fid);
end
