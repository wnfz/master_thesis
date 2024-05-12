%% Normalizing and writing data to .csv
% This code reads neural spike data from the .csv file (generated with spikesAxion.m), normalizes it based on
% the first value of each well, and writes the normalized data to separate
% .csv file for Bicuculline (Bicu) and Sham conditions.

tic
clear; clc;

% Load data
input_filename = '/Users/yasserjalali/Desktop/neuralMetrics_BicucullineExperiment/combined_well_spikes.csv'; % Adjust accordingly!

% Read data from the CSV file
data_table = readtable(input_filename);

% Extract relevant columns
wells = data_table.WellAverages;
values = data_table.NumberOfSpikes;

% Wells for Bicuculline and Sham control
bicu_wells = {'A1', 'A4', 'A6'};
sham_wells = {'A2', 'A3', 'A5'};

% Give timepoints
timepoints = {'Baseline', '5 min', '10 min', '15 min', '20 min', '25 min', '30 min', '35 min'};

% Initialize result tables for Bicu and Sham
bicu_cell = cell(length(bicu_wells) * length(timepoints), 2);
sham_cell = cell(length(sham_wells) * length(timepoints), 2);

% Write data for Bicu
for i = 1:length(bicu_wells)
    % Index of current well
    well_index = find(strcmp(wells, bicu_wells{i}));
    
    % Normalize data to the first value of the current well
    first_value = values(well_index(1));
    normalized_values = values(well_index) / first_value;
    
    % Write normalized data to the result table for Bicu
    for j = 1:length(timepoints)
        timepoint_index = (i - 1) * length(timepoints) + j;
        bicu_cell{timepoint_index, 1} = timepoints{j};
        bicu_cell{timepoint_index, 2} = normalized_values(j); % Use the normalized value
    end
end

% Write data for Sham
for i = 1:length(sham_wells)
    % Index of current well
    well_index = find(strcmp(wells, sham_wells{i}));
    
    % Normalize data to the first value of the current well
    first_value = values(well_index(1));
    normalized_values = values(well_index) / first_value;
    
    % Write normalized data to the result table for Sham
    for j = 1:length(timepoints)
        timepoint_index = (i - 1) * length(timepoints) + j;
        sham_cell{timepoint_index, 1} = timepoints{j};
        sham_cell{timepoint_index, 2} = normalized_values(j); % Use the normalized value
    end
end

% Write results to .csv files 
write_to_csv('bicu.csv', bicu_cell);
write_to_csv('sham.csv', sham_cell);

function write_to_csv(filename, cell_data)
    fid = fopen(filename, 'w');
    [rows, ~] = size(cell_data);
    for i = 1:rows
        fprintf(fid, '%s,%f\n', cell_data{i, :});
    end
    fclose(fid);
end
