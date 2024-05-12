%% This code creates synchrony metric line plots with error bars.
tic
clc; clear;
% Read data from .csv file
data = readtable('/Users/yasserjalali/Desktop/neuralMetrics/combined_well_spikes_synchrony.csv', 'ReadVariableNames', false); %% Change accordingly!
dates = data{:, 1};
all_dates_str = cellstr(num2str(dates, '%08d'));
synchrony_data = table2array(data(:, 2:end)); 

% Prompt for start date
start_date = input('Please enter the start date in "DDMMYYYY" format: ', 's');

% Calculate days in vitro for each date
days_in_vitro = days(datetime(all_dates_str, 'InputFormat', 'ddMMyyyy') - datetime(start_date, 'InputFormat', 'ddMMyyyy'));

% Compute mean and SEM for each day in vitro
unique_days = unique(days_in_vitro);
mean_spikes = zeros(length(unique_days), 1);
sem_spikes = zeros(length(unique_days), 1);

for i = 1:length(unique_days)
    day = unique_days(i);
    indices = days_in_vitro == day;
    spikes_group = data{indices, 2:end}; % Extract data for each day
    mean_spikes(i) = mean(spikes_group, 'all');
    sem_spikes(i) = std(spikes_group, 0, 'all') / sqrt(numel(spikes_group));
end

% Create points with error bars
figure;
hold on;
errorbar(unique_days, mean_spikes, sem_spikes, 'ko-', 'LineWidth', 1.6);
xlabel('Days of electrical activity', 'FontSize', 24, 'FontName', 'Arial');
ylabel('Area under normalized cross-correlation', 'FontSize', 24, 'FontName', 'Arial');
set(gca, 'FontSize', 24, 'FontName', 'Arial');

% Add vertical lines in light gray for all values on the y-axis
y_values = get(gca, 'YTick');
for y_val = y_values
    yline(y_val, 'Color', [0.8 0.8 0.8], 'LineStyle', '--');
end

hold off;

% Set x-axis as custom labels
xticks(unique_days);
toc
