tic
clear; clc;

%% This code iterates over a folder containing neuralMetrics data and extracts the number of spikes for each well 
%% and stores the results in a separate .csv.
folder = input('Enter the folder path containing the _neuralMetrics.csv files: ', 's');

% Iterate over all the files with the ending "_neuralMetrics.csv"
files = dir(fullfile(folder, '*_neuralMetrics.csv'));

all_dates = {};
all_well_averages = {};
all_num_spikes = {};

% Iterate over all files
for k = 1:numel(files)
    file_path = fullfile(folder, files(k).name);
    
    % Extract date from filename
    [~, name, ~] = fileparts(files(k).name);
    file_date = extractDate(name);
    all_dates{end+1} = file_date;
    
    % Open the file for reading
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

    % Split the well line into its components using semicolons
    wells_values = strsplit(well_line, ';', 'CollapseDelimiters', false);

    % Remove the first cell 'Well Averages'
    wells_values = wells_values(2:end);

    % Split the spike line into its components using semicolons
    spikes_values = strsplit(spike_line, ';', 'CollapseDelimiters', false);

    % Remove the first cell 'Number of Spikes'
    spikes_values = spikes_values(2:end);

    % Add the data to the corresponding cell arrays
    all_well_averages{end+1} = wells_values;
    all_num_spikes{end+1} = spikes_values;
end

% Generate the filename for the result file
output_file = fullfile(folder, 'combined_well_spikes.csv');

% Write the data to a CSV file
writeToCSV(output_file, all_dates, all_well_averages, all_num_spikes);

disp('Combined well and spikes data saved successfully.');
toc

function date_str = extractDate(filename)
    % Extracts date in the format DDMMYYYY from the filename --> Format is
    % same for all files!
    date_str = regexp(filename, '\d{8}', 'match', 'once');
end

function writeToCSV(output_file, all_dates, all_well_averages, all_num_spikes)
    % Write data to CSV file
    fid = fopen(output_file, 'w');

    % Write headers
    fprintf(fid, 'Date,Well Averages,Number of Spikes\n');

    % Write data
    num_files = numel(all_dates);
    for i = 1:num_files
        date = all_dates{i};
        well_averages = all_well_averages{i};
        num_spikes = all_num_spikes{i};

        % Determine the maximum number of entries for this file
        max_entries = max(numel(well_averages), numel(num_spikes));

        % Write data to CSV
        for j = 1:max_entries
            if j <= numel(well_averages)
                well_average = well_averages{j};
            else
                well_average = '';
            end
            if j <= numel(num_spikes)
                num_spike = num_spikes{j};
            else
                num_spike = '';
            end
            fprintf(fid, '%s,%s,%s\n', date, well_average, num_spike);
        end
    end

    fclose(fid);
end
