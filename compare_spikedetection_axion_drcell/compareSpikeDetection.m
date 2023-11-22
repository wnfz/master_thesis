%%%%% This code takes the spikes found with the Axion Biosystems and
%%%%% compares the number to DrCell graphically (!!! Change for Control or
%%%%% LSD)
tic
clc; clear;

% Prompt for the experiment date
date_of_experiment = input('Enter the experiment date in the format DDMMYYYY: ', 's');

% Prompt user to specify if it is a Control or LSD file
file_type = input('Enter the file type (Control or LSD): ', 's');

% Prompt user for the path to the neuralMetrics_AxionData folder
folder_path_1 = input('Enter the path to the neuralMetrics_AxionData folder: ', 's');

% Prompt user for the path to the TS_Control or TS_LSD folder
folder_path_2 = input('Enter the path to the TS or TS_SWTEO folder: ', 's');

% Check, if folders exist and written correctly, else break
if ~isfolder(folder_path_1) || ~isfolder(folder_path_2)
    disp('Folders do not exist. Aborting.');
    return;
end

% Search for file extensions
file_extension_1 = ['_' lower(file_type) 'spikes.csv'];
file_extension_2 = ['_DrCell_' lower(file_type) 'spikes.csv'];

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

% Add labels and legend, well name on x-axis and Number of spikes on y-axis
xlabel('Well');
ylabel('Number of spikes');
title(file_type); % Use specified file type in the title
legend('show');
grid on;

% Create an output folder in the same path as neuralMetrics_AxionData
output_folder = fullfile(fileparts(folder_path_1), [date_of_experiment '_TS']); % Change if SWTTEO algorithm was used to _TS_SWTEO
%output_folder = fullfile(fileparts(folder_path_1), [date_of_experiment '_TS_SWTEO']);
if ~exist(output_folder, 'dir')
    mkdir(output_folder);
end
% Save the chart as a PDF file in the output folder
output_file = fullfile(output_folder, ['Comparison_Axion_DrCell_' upper(file_type) '.pdf']); 
saveas(gcf, output_file, 'pdf');
toc
