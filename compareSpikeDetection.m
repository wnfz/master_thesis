%%%%% author: Wenus Nafez
%%%%% This code takes the spikes found with the Axion Biosystems and
%%%%% compares the number to DrCell graphically (!!! Change for Control or
%%%%% LSD)
tic
clc; clear;

% Prompt for the experiment date
date_of_experiment = input('Enter the experiment date in the format DDMMYYYY: ', 's');
%% Load neuralMetrics_AxionData file for experiment date and TS_Control or TS_LSD folder
folder_path_1 = '/Users/yasserjalali/Desktop/Rat neurons 19092023(011)_neuralMetrics_AxionData';
folder_path_2 = '/Users/yasserjalali/Desktop/1909_TS_SWTEO_Control';

% Search for file extensions
%% Change to Control or LSD as needed
file_extension_1 = '_controlspikes.csv';
%file_extension_1 = '_lsdspikes.csv';
file_extension_2 = '_DrCell_controlspikes.csv';
%file_extension_2 = '_DrCell_lsdspikes.csv';
% Find file in the first folder
file_name_1 = dir(fullfile(folder_path_1, ['*' file_extension_1]));

% Find file in the second folder
file_name_2 = dir(fullfile(folder_path_2, ['*' file_extension_2]));


% Read both files
data_1 = readtable(fullfile(folder_path_1, file_name_1.name));
data_2 = readtable(fullfile(folder_path_2, file_name_2.name));

% Extract columns for the line chart
x_axis = data_1{:, 1}; % Convert cells to numerical values
y_axis_1 = data_1{:, 2};
y_axis_2 = data_2{:, 2};

% Plot the data with numerical values on the x-axis
figure;
plot(y_axis_1, 'o-', 'LineWidth', 2, 'DisplayName', 'Axion Biosystems', 'Color', [0.8500, 0.3250, 0.0980]); % Orange
hold on;
plot(y_axis_2, 's-', 'LineWidth', 2, 'DisplayName', 'DrCell', 'Color', [0, 0.4470, 0.7410]); % Blue

% Use the words from x_axis as tick labels on the x-axis
xticks(1:numel(x_axis));
xticklabels(x_axis);

% Add labels and legend
xlabel('Well');
ylabel('Number of spikes');
title('Control'); %% Change to Control or LSD as needed
%title('LSD');   
legend('show');

grid on;

% Create an output folder based on the experiment date
%% Change, if SWTTEO algorithm was used in spike detection
%output_folder = fullfile('/Users/yasserjalali/Desktop', [date_of_experiment '_TS']);
output_folder = fullfile('/Users/yasserjalali/Desktop', [date_of_experiment '_TS_SWTEO']);
if ~exist(output_folder, 'dir')
    mkdir(output_folder);
end

% Save the chart as a PDF file in the output folder
%% Change to Control or LSD as needed
%output_file = fullfile(output_folder, 'Comparison_Axion_DrCell_Control.pdf');
output_file = fullfile(output_folder, 'Comparison_Axion_DrCell_LSD.pdf');
saveas(gcf, output_file, 'pdf');
toc
