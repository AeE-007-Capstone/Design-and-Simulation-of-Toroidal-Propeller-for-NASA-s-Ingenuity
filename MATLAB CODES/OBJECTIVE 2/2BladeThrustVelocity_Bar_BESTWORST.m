% --- Define Parameters ---
rho = 0.02; % Air density (kg/m^3)
n = 43.33; % Rotational speed (rev/s)
D = 1.210; % Propeller diameter (m)

% Define velocities (m/s)
V = [2, 4, 6, 8, 10];

% Define file names
fileNames = {'2ms/Lift Data.xlsx', '4ms/Lift Data.xlsx', '6ms/Lift Data.xlsx', '8ms/Lift Data.xlsx', '10ms/Lift Data.xlsx'};

% Number of sheets to read (including Sheet 1)
numSheets = 11;

% Initialize array to store results
CT_all = zeros(numSheets, length(fileNames));

% Define legend labels
legendLabels = { 'Conventional', ...
                 'Toroidal - 7.5', 'Toroidal - 10', 'Toroidal - 12.5', ...
                 'Toroidal - 15', 'Toroidal - 17.5', 'Toroidal - 20', ...
                 'Toroidal - 22.5', 'Toroidal - 25', 'Toroidal - 27.5', ...
                 'Toroidal - 30' };

% --- Compute Thrust Coefficients ---
for sheetNum = 1:numSheets
    thrust_max = zeros(1, length(fileNames)); % Reset for each sheet

    % Loop through each file
    for i = 1:length(fileNames)
        % Read data from the second column of the current sheet
        thrust_data = xlsread(fileNames{i}, sheetNum, 'B:B');

        % Compute absolute values
        thrust_abs = abs(thrust_data);

        % Compute maximum thrust
        thrust_max(i) = max(thrust_abs);
    end

    % Compute the coefficient C_T for the current sheet using max thrust
    CT_all(sheetNum, :) = thrust_max ./ (rho * (n^2) * (D^4));
end

% --- Selection Process ---
% Initialize arrays for best and worst configurations
CT_best = zeros(1, length(V)); % Best thrust coefficient for each velocity
CT_worst = zeros(1, length(V)); % Worst thrust coefficient for each velocity
bestLabels = cell(1, length(V)); % Labels for best configurations
worstLabels = cell(1, length(V)); % Labels for worst configurations

% Loop through each velocity
for i = 1:length(V)
    % Exclude Conventional (Sheet 1), Toroidal 7.5 (Sheet 2), and Toroidal 25 (Sheet 9)
    CT_values = CT_all([3:8, 10:11], i); % Consider only toroidal configurations
    labels = legendLabels([3:8, 10:11]); % Corresponding labels

    % Determine the best (max) and worst (min) configurations
    [CT_best(i), bestIdx] = max(CT_values);
    [CT_worst(i), worstIdx] = min(CT_values);

    % Store labels for best and worst configurations
    bestLabels{i} = labels{bestIdx};
    worstLabels{i} = labels{worstIdx};
end

% --- Combined Bar Graph ---
figure;
% Combine data for Conventional, Best, and Worst configurations
plotData = [CT_all(1, :); CT_best; CT_worst]';

% Create grouped bar chart
b = bar(V, plotData, 'grouped'); 

% Customize chart properties
xticks(V);
xlabel('Velocity (m/s)', 'FontSize', 18, 'FontWeight', 'bold', 'FontName', 'Times New Roman');
ylabel('Thrust Coefficient (C_T)', 'FontSize', 18, 'FontWeight', 'bold', 'FontName', 'Times New Roman');
title('Thrust Coefficient Comparison: Conventional, Best, and Worst Toroidal Configurations', ...
    'FontSize', 18, 'FontWeight', 'bold', 'FontName', 'Times New Roman');

% Customize tick labels and font
set(gca, 'FontSize', 18, 'FontName', 'Times New Roman');

% Add bar labels dynamically above the bars using positions from your example
hold on;
barOffset = [-0.3, 0, 0.3]; % Offsets for Conventional, Best, and Worst
labelOffset = 0.01; % Vertical offset above the bar
for i = 1:length(V)
    % Add labels for Conventional, Best, and Worst configurations
    text(V(i) + barOffset(1), CT_all(1, i) + labelOffset, 'Conventional', ...
        'FontSize', 15, 'FontWeight', 'bold', 'FontName', 'Times New Roman', ...
        'Rotation', 90, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom');
    text(V(i) + barOffset(2), CT_best(i) + labelOffset, bestLabels{i}, ...
        'FontSize', 15, 'FontWeight', 'bold', 'FontName', 'Times New Roman', ...
        'Rotation', 90, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom');
    text(V(i) + barOffset(3), CT_worst(i) + labelOffset, worstLabels{i}, ...
        'FontSize', 15, 'FontWeight', 'bold', 'FontName', 'Times New Roman', ...
        'Rotation', 90, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom');
end
hold off;

% Display grid
grid on;

% Display computed values
disp('Velocities (m/s):');
disp(V);
disp('Conventional Thrust Coefficients:');
disp(CT_all(1, :));
disp('Best Thrust Coefficient C_T for each velocity:');
disp(CT_best);
disp('Worst Thrust Coefficient C_T for each velocity:');
disp(CT_worst);
