%% This code reads the given .csv file (from spikesAxion.m) and creates a .csv for extractBicuSham.csv
tic
clear; clc;
% Read file
data = readtable('/Users/yasserjalali/Desktop/neuralMetrics_BicucullineExperiment/combined_well_bursts.csv'); %%Adjust accordingly!

% Extract the well values from the table
well_values = data{:, 2:end};

% Get the number of rows and columns in the well values
[num_rows, num_cols] = size(well_values);

% Create a new table for the results
result = table();

% Initialize cell arrays for the columns
well_names = data.Properties.VariableNames(2:end);
well_averages = cell(num_rows * num_cols, 1);
number_of_spikes = cell(num_rows * num_cols, 1);

% Fill the columns in the new table
idx = 1;
for i = 1:num_cols
    for j = 1:num_rows
        well_averages{idx} = [well_names{i}];
        number_of_spikes{idx} = well_values{j, i};
        idx = idx + 1;
    end
end

% Add the columns to the new table
result.WellAverages = well_averages;
result.NumberOfSpikes = number_of_spikes;

% Save the results to a new .csv file
writetable(result, 'combined_bursts.csv');
toc
