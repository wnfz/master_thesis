%% This code changes the settings for the raster plot generated using neuralMetrics Tool (save raster plot to .fig)
% % Change to correct .fig file
hfig = openfig('001.fig');

% Accessing the axes of the opened figure
hax = gca;

% Changing the font to Times New Roman
hax.FontName = 'Arial';

% Changing the font size of the axis labels
hax.FontSize = 24; % Replace 24 with the desired font size

% Changing the line width to 1
hLines = findall(hax, 'Type', 'Line'); % Find all lines in the axes
lineWidth = 1; % Line width
lineLengthFactor = 2; % Factor to extend the lines

for i = 1:numel(hLines)
    % Changing the line width
    hLines(i).LineWidth = lineWidth;
    
    % Getting the X and Y data of the line
    xData = hLines(i).XData;
    yData = hLines(i).YData;
    
    % Calculating the direction and length of the line
    dx = diff(xData);
    dy = diff(yData);
    direction = atan2(dy(end), dx(end)); % Direction of the line
    lineLength = sqrt((dx(end))^2 + (dy(end))^2); % Length of the line
    
    % Extending the line
    xEnd = xData(end) + lineLengthFactor * lineLength * cos(direction);
    yEnd = yData(end) + lineLengthFactor * lineLength * sin(direction);
    
    % Updating the line data
    xDataNew = [xData, xEnd];
    yDataNew = [yData, yEnd];
    hLines(i).XData = xDataNew;
    hLines(i).YData = yDataNew;
end

% Enabling secondary (minor) X tick marks
hax.XMinorTick = 'on';

% Ensuring the Y-axis is visible
hax.YColor = 'k'; % Set the Y-axis color to black

% Explicitly adding Y-axis label
ylabel(hax, 'Active Electrodes', 'FontSize', 24, 'FontName', 'Arial');

% Updating the figure
drawnow;
