% --- Define Parameters ---
rho = 0.02; % Air density (kg/m^3)
n = 43.33; % Rotational speed (rev/s)
D = 1.210; % Propeller diameter (m)

% Define velocities (m/s)
V = [2, 4, 6, 8, 10];

% Define file names
fileNames = {'2ms/Torque Data.xlsx', '4ms/Torque Data.xlsx', '6ms/Torque Data.xlsx', '8ms/Torque Data.xlsx', '10ms/Torque Data.xlsx'};

% Number of sheets to read
numSheets = 11;

% Initialize array to store results
CQ_all = zeros(numSheets, length(fileNames));

% Define legend labels
legendLabels = { 'Conventional', ...
                 'Toroidal - 7.5', 'Toroidal - 10', 'Toroidal - 12.5', ...
                 'Toroidal - 15', 'Toroidal - 17.5', 'Toroidal - 20', ...
                 'Toroidal - 22.5', 'Toroidal - 25', 'Toroidal - 27.5', ...
                 'Toroidal - 30' };

% --- Compute Torque Coefficients ---
for sheetNum = 1:numSheets
    torque_max = zeros(1, length(fileNames)); % Reset for each sheet

    % Loop through each file
    for i = 1:length(fileNames)
        % Read torque data from the third column (assuming column C stores torque)
        torque_data = xlsread(fileNames{i}, sheetNum, 'B:B');

        % Compute absolute values
        torque_abs = abs(torque_data);

        % Compute maximum torque
        torque_max(i) = max(torque_abs);
    end

    % Compute the coefficient C_Q for the current sheet using max torque
    CQ_all(sheetNum, :) = torque_max ./ (rho * (n^2) * (D^5));
end

% --- Selection Process ---
% Initialize arrays for best and worst configurations
CQ_best = zeros(1, length(V)); % Best torque coefficient for each velocity
CQ_worst = zeros(1, length(V)); % Worst torque coefficient for each velocity
bestLabels = cell(1, length(V)); % Labels for best configurations
worstLabels = cell(1, length(V)); % Labels for worst configurations

% Loop through each velocity
for i = 1:length(V)
    % Exclude Conventional (Sheet 1), Toroidal 7.5 (Sheet 2), and Toroidal 25 (Sheet 9)
    CQ_values = CQ_all([3:8, 10:11], i); % Consider only valid toroidal configurations
    labels = legendLabels([3:8, 10:11]); % Corresponding labels

    % Determine the best (max) and worst (min) configurations
    [CQ_best(i), bestIdx] = max(CQ_values);
    [CQ_worst(i), worstIdx] = min(CQ_values);

    % Store labels for best and worst configurations
    bestLabels{i} = labels{bestIdx};
    worstLabels{i} = labels{worstIdx};
end

% --- Combined Bar Graph ---
figure;
% Combine data for Conventional, Worst, and Best configurations (order changed)
plotData = [CQ_all(1, :); CQ_worst; CQ_best]';

% Create grouped bar chart
b = bar(V, plotData, 'grouped'); 

% Customize chart properties
xticks(V);
xlabel('Velocity (m/s)', 'FontSize', 18, 'FontWeight', 'bold', 'FontName', 'Times New Roman');
ylabel('Torque Coefficient (C_Q)', 'FontSize', 18, 'FontWeight', 'bold', 'FontName', 'Times New Roman');
title('Torque Coefficient Comparison: Conventional, Worst, and Best Toroidal Configurations', ...
    'FontSize', 18, 'FontWeight', 'bold', 'FontName', 'Times New Roman');

% Customize tick labels and font
set(gca, 'FontSize', 18, 'FontName', 'Times New Roman');

% Add bar labels dynamically above the bars
hold on;
barOffset = [-0.3, 0, 0.3]; % Offsets for Conventional, Worst, and Best
labelOffset = 0.005; % Vertical offset above the bar
for i = 1:length(V)
    % Add labels for Conventional, Worst, and Best configurations
    text(V(i) + barOffset(1), CQ_all(1, i) + labelOffset, 'Conventional', ...
        'FontSize', 15, 'FontWeight', 'bold', 'FontName', 'Times New Roman', ...
        'Rotation', 90, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom');
    text(V(i) + barOffset(2), CQ_worst(i) + labelOffset, worstLabels{i}, ...
        'FontSize', 15, 'FontWeight', 'bold', 'FontName', 'Times New Roman', ...
        'Rotation', 90, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom');
    text(V(i) + barOffset(3), CQ_best(i) + labelOffset, bestLabels{i}, ...
        'FontSize', 15, 'FontWeight', 'bold', 'FontName', 'Times New Roman', ...
        'Rotation', 90, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom');
end
hold off;

% Display grid
grid on;

% Display computed values
disp('Velocities (m/s):');
disp(V);
disp('Conventional Torque Coefficients:');
disp(CQ_all(1, :));
disp('Worst Torque Coefficient C_Q for each velocity:');
disp(CQ_worst);
disp('Best Torque Coefficient C_Q for each velocity:');
disp(CQ_best);
