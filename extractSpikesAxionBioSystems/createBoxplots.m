%% Read the CSV file (generated with spikesAxion.m) and create boxplots
tic
clear; clc;

% Prompt for the location of the data file
data_file_path = input('Please enter the path to the data file: ', 's');

data = readtable(data_file_path);

% Prompt for the start date
start_date = input('Please enter the start date in the format (DDMMYYYY): ', 's');

% Extract the date from the first column of the file
all_dates = data{:, 1};

% Convert the date to the format 'ddMMyyyy'
all_dates_str = cellstr(num2str(all_dates, '%08d'));

% Calculate days in vitro for each date (=days of experiment - start day in
% vitro)
days_in_vitro = days(datetime(all_dates_str, 'InputFormat', 'ddMMyyyy') - datetime(start_date, 'InputFormat', 'ddMMyyyy'));

% Create a table with the calculated days in vitro
data.DaysInVitro = days_in_vitro;

% Remove the 'DaysInVitro' column from the boxplot_data
boxplot_data = data{:, 2:end-1}; % Remove the first and last column

% Transpose the boxplot_data
boxplot_data_transposed = boxplot_data';

% Plot boxplots for each day in vitro in black color
boxplot(boxplot_data_transposed, 'Labels', cellstr(num2str(unique(days_in_vitro))), 'Colors', 'k')

% Add labels to the axes
xlabel('Days in vitro')
ylabel('Number of spikes')
% Save figure as .pdf file (change accordingly)
saveas(gcf, 'boxplots_numSpikes.pdf')

% Close figure
close(gcf)

toc
