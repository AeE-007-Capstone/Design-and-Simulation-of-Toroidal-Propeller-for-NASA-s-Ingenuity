% Specify the Excel file name
fileName = 'INTEGRATED SIMULATION DATA.xlsx'; % Replace with your actual file name

% Define sheet numbers and corresponding configuration legends
sheetNumbers = 1:9;
legends = {'C2C2', 'C2T2', 'C2T3', 'T2T2', 'T2C2', 'T2T3', 'T3T3', 'T3C2', 'T3T2'};

%% --- Lift Data from Column B ---
% Initialize vector for storing maximum lift data
maxValues = zeros(length(sheetNumbers), 1);

% Loop through each sheet, read lift data from column B, and compute the maximum of absolute values
for i = 1:length(sheetNumbers)
    % Read data from column B
    data = readmatrix(fileName, 'Sheet', sheetNumbers(i), 'Range', 'B:B');
    data = data(~isnan(data));  % Remove any NaN entries  
    absData = abs(data);        % Get absolute values
    maxValues(i) = max(absData);  % Calculate the maximum lift value
end

%% Figure 1: Bar graph for Maximum Thrust Data (in Newtons)
figure;
bar(maxValues, 'FaceColor', [0.2, 0.6, 0.5]);  % Display bar graph
set(gca, 'XTick', 1:numel(legends), 'XTickLabel', legends, 'FontSize', 15);
xlabel('Configuration Names', 'FontSize', 18);
ylabel('Thrust (N)', 'FontSize', 18);
title('Thrust Data by Configuration', 'FontSize', 18);
grid on;

%% Figure 2: Bar graph for Percentage Increase in Thrust Relative to C2C2
% Use the maximum thrust value from C2C2 (first element) as the reference value
referenceValue = maxValues(1);

% Compute the percentage increase relative to the reference
percentageIncrease = ((maxValues - referenceValue) / referenceValue) * 100;

% Create a new figure for the percentage increases
figure;
bar(percentageIncrease, 'FaceColor', [0.4, 0.6, 0.8]);
set(gca, 'XTick', 1:numel(legends), 'XTickLabel', legends, 'FontSize', 15);
xlabel('Configuration Names', 'FontSize', 18);
ylabel('Percentage Increase (%)', 'FontSize', 18);
title('Percentage Increase in Thrust Relative to C2C2', 'FontSize', 18);
grid on;

%% --- Define Device Weight (in Newtons) ---
weight = 6.71;  % The device weight is constant for all configurations

%% --- Thrust-to-Weight Ratio Calculation and Plotting ---
% Compute the Thrust-to-Weight (T/W) ratio for each configuration by dividing the  
% maximum thrust value (from Column B) by the device weight.
TToW_ratio = maxValues ./ weight;

% Create a new figure for the Thrust-to-Weight Ratio.
figure;
bar(TToW_ratio, 'FaceColor', [0.5, 0.7, 0.3]);  % Customize the bar color as desired.
set(gca, 'XTick', 1:numel(legends), 'XTickLabel', legends, 'FontSize', 15);
xlabel('Configuration Names', 'FontSize', 18);
ylabel('Thrust-to-Weight Ratio', 'FontSize', 18);
title('Thrust-to-Weight Ratio by Configuration', 'FontSize', 18);
grid on;
