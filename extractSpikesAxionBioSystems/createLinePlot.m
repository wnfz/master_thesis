%% This code creates line plots with square points of all wells over time, with the number of spikes normalized to the baseline on y-axis 
%% and time in minutes on second x-axis
tic
clc; clear;
% Ask for the input file path
input = input('Enter the file path: ', 's');

% Load your data from the input .csv file
data_table = readtable(input);

% Entferne die letzte Zeile
data_table = data_table(1:end-1, :);

% Extract well averages and number of spikes
well_averages = data_table{:, 'WellAverages'}; % Assuming the column name is 'WellAverages'
number_of_spikes = data_table{:, 'NumberOfSpikes'}; % Assuming the column name is 'NumberOfSpikes'

% Normalisiere die Anzahl der Spikes auf die Werte des ersten Tages
number_of_spikes_normalized = number_of_spikes ./ number_of_spikes(1);

% Plot the line graph with square points
figure;
scatter(1:numel(number_of_spikes_normalized), number_of_spikes_normalized, 'Marker', 's', 'MarkerFaceColor', 'k', 'MarkerEdgeColor', 'k', 'SizeData', 200); % Rechteckige Punkte
hold on;
plot(1:numel(number_of_spikes_normalized), number_of_spikes_normalized, 'k', 'LineWidth', 3); % Dicke Linie

% Set x-axis ticks and labels to display "Well Averages" without cursive font
xticks(1:numel(number_of_spikes_normalized));
xticklabels(well_averages);
xtickangle(90); % Drehen Sie die Beschriftungen um 90 Grad

% Ändern Sie die Schriftart und -größe für x- und y-Achsenbeschriftungen
set(gca, 'FontName', 'Arial', 'FontSize', 20);

% Add labels and title
xlabel('Wells', 'FontSize', 24);
ylabel('Normalized number of spikes', 'FontSize', 24);

% Add a second x-axis
ax1 = gca;
ax2 = axes('Position',ax1.Position,'XAxisLocation','top','Color','none');
ax2.XLim = ax1.XLim; % Setze die Grenzen der zweiten Achse auf die der ersten Achse

% Find positions of 'A6' and 'A3' in the well_averages
a6_indices = find(strcmp(well_averages, 'A6'));
a3_indices = find(strcmp(well_averages, 'A3'));

% Set the positions of the ticks and labels on the second x-axis
ax2.XTick = a6_indices;
ax2.XTickLabel = repmat(" ", 1, length(a6_indices));  % Empty labels over 'A6'

% Add time text over 'A3'
time_labels = {'Baseline','5 min','10 min','15 min','20 min','25 min','30 min','35 min'};
for i = 1:length(a3_indices)
    text(a3_indices(i), ax2.YLim(2), time_labels{i}, 'HorizontalAlignment', ...
        'center', 'VerticalAlignment', 'bottom', 'FontSize', 20);
end

% Remove the y-axis on the second plot
ax2.YAxis.Visible = 'off';

% Show the plot
hold off;

toc
