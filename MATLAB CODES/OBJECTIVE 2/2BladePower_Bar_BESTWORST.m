% --- Define Parameters ---
rho = 0.02; % Air density (kg/m^3)
n = 43.33; % Rotational speed (rev/s)
D = 1.210; % Propeller diameter (m)

% Define velocities (m/s)
V = [2, 4, 6, 8, 10];

% Compute Advance Ratio (J)
J = V ./ (n * D);

% Define file names
fileNames = {'2ms/Torque Data.xlsx', '4ms/Torque Data.xlsx', '6ms/Torque Data.xlsx', '8ms/Torque Data.xlsx', '10ms/Torque Data.xlsx'};

% Number of sheets to read
numSheets = 11;

% Initialize arrays to store results
CQ_all = zeros(numSheets, length(fileNames));
CP_all = zeros(numSheets, length(fileNames));  % Storage for Power Coefficient

% Define legend labels
legendLabels = { 'Conventional', ...
                 'Toroidal - 7.5', 'Toroidal - 10', 'Toroidal - 12.5', ...
                 'Toroidal - 15', 'Toroidal - 17.5', 'Toroidal - 20', ...
                 'Toroidal - 22.5', 'Toroidal - 25', 'Toroidal - 27.5', ...
                 'Toroidal - 30' };

% --- Compute Power Coefficients ---
for sheetNum = 1:numSheets
    torque_max = zeros(1, length(fileNames)); % Reset for each sheet

    % Loop through each file
    for i = 1:length(fileNames)
        % Read torque data from column B (assuming column B stores torque)
        torque_data = xlsread(fileNames{i}, sheetNum, 'B:B');

        % Compute absolute values
        torque_abs = abs(torque_data);

        % Compute maximum torque
        torque_max(i) = max(torque_abs);
    end

    % Compute the coefficient C_Q for the current sheet using max torque
    CQ_all(sheetNum, :) = torque_max ./ (rho * (n^2) * (D^5));

    % Compute the Power Coefficient C_P using C_P = 2 * pi * C_Q
    CP_all(sheetNum, :) = 2 * pi * CQ_all(sheetNum, :);
end

% --- Selection Process ---
% Initialize arrays for best and worst configurations
CP_best = zeros(1, length(V)); % Best power coefficient for each velocity
CP_worst = zeros(1, length(V)); % Worst power coefficient for each velocity
bestLabels = cell(1, length(V)); % Labels for best configurations
worstLabels = cell(1, length(V)); % Labels for worst configurations

% Loop through each velocity
for i = 1:length(V)
    % Exclude Conventional (Sheet 1), Toroidal 7.5 (Sheet 2), and Toroidal 25 (Sheet 9)
    CP_values = CP_all([3:8, 10:11], i); % Consider only valid toroidal configurations
    labels = legendLabels([3:8, 10:11]); % Corresponding labels

    % Determine the best (max) and worst (min) configurations
    [CP_best(i), bestIdx] = max(CP_values);
    [CP_worst(i), worstIdx] = min(CP_values);

    % Store labels for best and worst configurations
    bestLabels{i} = labels{bestIdx};
    worstLabels{i} = labels{worstIdx};
end

% --- Combined Bar Graph ---
figure;
% Combine data for Conventional, Worst, and Best configurations (order: Worst second, Best third)
plotData = [CP_all(1, :); CP_worst; CP_best]';

% Create grouped bar chart
b = bar(V, plotData, 'grouped'); 

% Customize chart properties
xticks(V);
xlabel('Velocity (m/s)', 'FontSize', 18, 'FontWeight', 'bold', 'FontName', 'Times New Roman');
ylabel('Power Coefficient (C_P)', 'FontSize', 18, 'FontWeight', 'bold', 'FontName', 'Times New Roman');
title('Power Coefficient Comparison: Conventional, Worst, and Best Toroidal Configurations', ...
    'FontSize', 18, 'FontWeight', 'bold', 'FontName', 'Times New Roman');

% Customize tick labels and font
set(gca, 'FontSize', 18, 'FontName', 'Times New Roman');

% Add bar labels dynamically above the bars
hold on;
barOffset = [-0.3, 0, 0.3]; % Offsets for Conventional, Worst, and Best
labelOffset = 0.005; % Vertical offset above the bar
for i = 1:length(V)
    % Add labels for Conventional, Worst, and Best configurations
    text(V(i) + barOffset(1), CP_all(1, i) + labelOffset, 'Conventional', ...
        'FontSize', 15, 'FontWeight', 'bold', 'FontName', 'Times New Roman', ...
        'Rotation', 90, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom');
    text(V(i) + barOffset(2), CP_worst(i) + labelOffset, worstLabels{i}, ...
        'FontSize', 15, 'FontWeight', 'bold', 'FontName', 'Times New Roman', ...
        'Rotation', 90, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom');
    text(V(i) + barOffset(3), CP_best(i) + labelOffset, bestLabels{i}, ...
        'FontSize', 15, 'FontWeight', 'bold', 'FontName', 'Times New Roman', ...
        'Rotation', 90, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom');
end
hold off;

% Display grid
grid on;

% Display computed values
disp('Velocities (m/s):');
disp(V);
disp('Conventional Power Coefficients:');
disp(CP_all(1, :));
disp('Worst Power Coefficient C_P for each velocity:');
disp(CP_worst);
disp('Best Power Coefficient C_P for each velocity:');
disp(CP_best);
