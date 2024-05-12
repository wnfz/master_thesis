%% This code plots bar charts wih error bars for Bicuculline (Bicu) and Sham conditions.

tic
clc; clear;

% Load data from the created .csv files (extractBicuSham.m) for Bicu and Sham control data
bicu_data = readtable('/Users/yasserjalali/Desktop/bicu.csv');
sham_data = readtable('/Users/yasserjalali/Desktop/sham.csv');

% Grouping data based on the first entry in the first column
[bicu_groups, bicu_indices] = findgroups(bicu_data.Var1);
[sham_groups, sham_indices] = findgroups(sham_data.Var1);

% Computing mean and standard error of the mean for Bicu data
bicu_means = splitapply(@mean, bicu_data.Var2, bicu_groups);
bicu_sem = splitapply(@sem, bicu_data.Var2, bicu_groups);

% Computing mean and standard error of the mean for Sham data
sham_means = splitapply(@mean, sham_data.Var2, sham_groups);
sham_sem = splitapply(@sem, sham_data.Var2, sham_groups);

% Timepoints for the x-axis
timepoints = {'Baseline', '5 min', '10 min', '15 min', '20 min', '25 min', '30 min', '35 min'};

% Setting bar width (to avoid overlapping of bars)
bar_width = 0.4;

% Calculating positions for Bicu and Sham bars
bicu_positions = 1:length(timepoints);
sham_positions = bicu_positions + bar_width + 0.05;

% Extracting unique values from the first column and arranging them in the correct order
unique_timepoints = unique(bicu_data.Var1);
ordered_timepoints = {'Baseline', '5 min', '10 min', '15 min', '20 min', '25 min', '30 min', '35 min'};
[~, order] = ismember(ordered_timepoints, unique_timepoints);
ordered_timepoints = unique_timepoints(order(order > 0));

% Creating the bar plot
figure;
hold on;

% Setting font size and font type
set(gca, 'FontSize', 24, 'FontName', 'Arial');

% Plotting bars for Bicu data
hBicu = bar(bicu_positions, bicu_means(order), bar_width, 'FaceColor', [0.94 0.94 0.94], 'EdgeColor', 'k', 'LineWidth', 1.5);
errorbar(bicu_positions, bicu_means(order), bicu_sem(order), 'k.', 'LineWidth', 1);

% Plotting bars for Sham data
hSham = bar(sham_positions, sham_means(order), bar_width, 'FaceColor', [0.7 0.7 0.7], 'EdgeColor', 'k', 'LineWidth', 1.5);
errorbar(sham_positions, sham_means(order), sham_sem(order), 'k.', 'LineWidth', 1);

xticks(bicu_positions + bar_width/2);
xticklabels(ordered_timepoints);
xlabel('Time');
ylabel('Normalized number of spikes');
legend([hBicu, hSham], 'Bicuculline', 'Sham');
grid on;

hold off;

toc
