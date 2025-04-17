% --- Define Parameters ---
rho = 0.02; % Air density (kg/m^3)
n = 43.33; % Rotational speed (rev/s)
D = 1.210; % Propeller diameter (m)

% Define velocities (m/s)
V = [2, 4, 6, 8, 10];

% Define file names for torque and lift data
torqueFiles = {'2ms/Torque Data.xlsx', '4ms/Torque Data.xlsx', '6ms/Torque Data.xlsx', '8ms/Torque Data.xlsx', '10ms/Torque Data.xlsx'};
thrustFiles = {'2ms/Lift Data.xlsx', '4ms/Lift Data.xlsx', '6ms/Lift Data.xlsx', '8ms/Lift Data.xlsx', '10ms/Lift Data.xlsx'};

% Number of sheets to read
numSheets = 11;

% Initialize arrays to store results
CQ_all = zeros(numSheets, length(torqueFiles));
CP_all = zeros(numSheets, length(torqueFiles));
CT_all = zeros(numSheets, length(thrustFiles));
eta_all = zeros(numSheets, length(thrustFiles));

% Define legend labels
legendLabels = { 'Conventional', ...
                 'Toroidal - 7.5', 'Toroidal - 10', 'Toroidal - 12.5', ...
                 'Toroidal - 15', 'Toroidal - 17.5', 'Toroidal - 20', ...
                 'Toroidal - 22.5', 'Toroidal - 25', 'Toroidal - 27.5', ...
                 'Toroidal - 30' };

% --- Compute Propeller Efficiency ---
for sheetNum = 1:numSheets  
    torque_max = zeros(1, length(torqueFiles));
    thrust_max = zeros(1, length(thrustFiles));

    % Loop through each file (torque & thrust)
    for i = 1:length(torqueFiles)
        % Read torque data from torque files
        torque_data = xlsread(torqueFiles{i}, sheetNum, 'B:B');
        
        % Read lift data from thrust files
        thrust_data = xlsread(thrustFiles{i}, sheetNum, 'B:B'); 
        
        % Compute absolute values
        torque_abs = abs(torque_data);
        thrust_abs = abs(thrust_data);

        % Compute maximum values
        torque_max(i) = max(torque_abs);
        thrust_max(i) = max(thrust_abs);
    end

    % Compute Coefficients
    CQ_all(sheetNum, :) = torque_max ./ (rho * (n^2) * (D^5));
    CT_all(sheetNum, :) = thrust_max ./ (rho * (n^2) * (D^4));
    CP_all(sheetNum, :) = 2 * pi * CQ_all(sheetNum, :);

    % Compute Efficiency η
    eta_all(sheetNum, :) = (CT_all(sheetNum, :) .* (V ./ (n * D))) ./ CP_all(sheetNum, :);
end

% --- Selection Process ---
% Initialize arrays for best and worst configurations
eta_best = zeros(1, length(V)); % Best efficiency for each velocity
eta_worst = zeros(1, length(V)); % Worst efficiency for each velocity
bestLabels = cell(1, length(V)); % Labels for best configurations
worstLabels = cell(1, length(V)); % Labels for worst configurations

% Loop through each velocity
for i = 1:length(V)
    % Exclude Conventional (Sheet 1), Toroidal 7.5 (Sheet 2), and Toroidal 25 (Sheet 9)
    eta_values = eta_all([3:8, 10:11], i); % Consider only valid toroidal configurations
    labels = legendLabels([3:8, 10:11]); % Corresponding labels

    % Determine the best (max) and worst (min) configurations
    [eta_best(i), bestIdx] = max(eta_values);
    [eta_worst(i), worstIdx] = min(eta_values);

    % Store labels for best and worst configurations
    bestLabels{i} = labels{bestIdx};
    worstLabels{i} = labels{worstIdx};
end

% --- Combined Bar Graph ---
figure;
% Combine data for Conventional, Best, and Worst configurations (order: Conventional, Best, Worst)
plotData = [eta_all(1, :); eta_best; eta_worst]';

% Create grouped bar chart
b = bar(V, plotData, 'grouped'); 

% Customize chart properties
xticks(V);
xlabel('Velocity (m/s)', 'FontSize', 18, 'FontWeight', 'bold', 'FontName', 'Times New Roman');
ylabel('Propeller Efficiency, \eta', 'Interpreter', 'latex', 'FontSize', 18, 'FontWeight', 'bold', 'FontName', 'Times New Roman');
title('Propeller Efficiency Comparison: Conventional, Best, and Worst Toroidal Configurations', ...
    'FontSize', 18, 'FontWeight', 'bold', 'FontName', 'Times New Roman');

% Customize tick labels and font
set(gca, 'FontSize', 18, 'FontName', 'Times New Roman');

% Add bar labels dynamically above the bars
hold on;
barOffset = [-0.3, 0, 0.3]; % Offsets for Conventional, Best, and Worst
labelOffset = 0.005; % Vertical offset above the bar
for i = 1:length(V)
    % Add labels for Conventional, Best, and Worst configurations
    text(V(i) + barOffset(1), eta_all(1, i) + labelOffset, 'Conventional', ...
        'FontSize', 15, 'FontWeight', 'bold', 'FontName', 'Times New Roman', ...
        'Rotation', 90, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom');
    text(V(i) + barOffset(2), eta_best(i) + labelOffset, bestLabels{i}, ...
        'FontSize', 15, 'FontWeight', 'bold', 'FontName', 'Times New Roman', ...
        'Rotation', 90, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom');
    text(V(i) + barOffset(3), eta_worst(i) + labelOffset, worstLabels{i}, ...
        'FontSize', 15, 'FontWeight', 'bold', 'FontName', 'Times New Roman', ...
        'Rotation', 90, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom');
end
hold off;

% Display grid
grid on;

% Display computed values
disp('Velocities (m/s):');
disp(V);
disp('Conventional Propeller Efficiencies:');
disp(eta_all(1, :));
disp('Best Propeller Efficiency (η) for each velocity:');
disp(eta_best);
disp('Worst Propeller Efficiency (η) for each velocity:');
disp(eta_worst);
