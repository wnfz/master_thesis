%% Create bar charts with error bars with Mean of spikes and Standard Error of the Mean (SEM)
%% for each day in vitro depicted.
tic
clc; clear;
% Prompt for start date
start_date = input('Please enter the start date in "DDMMYYYY" format: ', 's');

% Read data
data = readtable('/Users/yasserjalali/Desktop/neuralMetrics/combined_well_spikes_all.csv'); % Change accordingly!

% Extract date from the first column of the file
all_dates = data{:, 1};

% Convert date to 'ddMMyyyy' format
all_dates_str = cellstr(num2str(all_dates, '%08d'));

% Calculate days in vitro for each date
days_in_vitro = days(datetime(all_dates_str, 'InputFormat', 'ddMMyyyy') - datetime(start_date, 'InputFormat', 'ddMMyyyy'));

% Compute mean and SEM for each day in vitro
unique_days = unique(days_in_vitro);
mean_spikes = zeros(length(unique_days), 1);
sem_spikes = zeros(length(unique_days), 1);

% Normalize data relative to the first day
first_day_spikes = data{days_in_vitro == unique_days(1), 2:end};
normalized_data = data{:, 2:end} ./ mean(first_day_spikes, 'all');

for i = 1:length(unique_days)
    day = unique_days(i);
    indices = days_in_vitro == day;
    spikesGroup = normalized_data(indices, :); % Extract normalized data for each day
    mean_spikes(i) = mean(spikesGroup, 'all');
    sem_spikes(i) = std(spikesGroup, 0, 'all') / sqrt(numel(spikesGroup));
end

% Create bar chart with error bars
figure;
bar(unique_days, mean_spikes, 'FaceColor', [0.7 0.7 0.7], 'LineWidth', 1);

hold on;

errorbar(unique_days, mean_spikes, sem_spikes, 'k', 'LineStyle', 'none','LineWidth', 1);
xlabel('Days of electrical activity', 'FontSize', 24, 'FontName', 'Arial');
ylabel('Normalized number of spikes', 'FontSize', 24, 'FontName', 'Arial');
set(gca, 'FontSize', 24, 'FontName', 'Arial');


% Add two slanted lines on x-axis with ample gap between values
x_values = get(gca, 'XTick');
x_diff = diff(x_values);
threshold = 3; % Change this value as per requirement
for i = 1:length(x_values)-1
    if x_diff(i) > threshold
        x_pos = mean(x_values(i:i+1));
        y_range = ylim;
        y_pos = y_range(1);
        text(x_pos, y_pos, '||', 'Color', [0.5 0 0], 'HorizontalAlignment', 'center', 'FontSize', 18, 'FontWeight', 'bold', 'Rotation', 135);
    end
end

% Draw background lines
backgroundLines(unique_days, get(gca, 'YTick'));

hold off;
% Change order of graphic elements to move dashed lines to the bottom
uistack(findobj(gca, 'Type', 'line', '-and', 'LineStyle', '--'), 'bottom');

% Save figure as PNG
saveas(gcf, 'bar_chart_spikes.png');

function backgroundLines(x_values, y_values)
    hold on;
    for y_val = y_values
        plot([x_values(1), x_values(end)], [y_val, y_val], '--', 'Color', [0.8 0.8 0.8]); % Draw horizontal lines
    end
    hold off;
end
toc
