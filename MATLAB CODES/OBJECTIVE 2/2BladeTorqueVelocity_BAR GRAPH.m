% Define parameters
rho = 0.02; % Air density (kg/m^3)
n = 43.33; % Rotational speed (rev/s)
D = 1.210; % Propeller diameter (m)

% Define velocities (m/s)
V = [2, 4, 6, 8, 10];

% Define file names
fileNames = {'2ms/Torque Data.xlsx', '4ms/Torque Data.xlsx', '6ms/Torque Data.xlsx', '8ms/Torque Data.xlsx', '10ms/Torque Data.xlsx'};

% Number of sheets to read (including Sheet 1)
numSheets = 11;

% Initialize array to store results
CQ_all = zeros(numSheets, length(fileNames));

% Define legend labels
legendLabels = { 'Conventional', ...
                 'Toroidal - 7.5', 'Toroidal - 10', 'Toroidal - 12.5', ...
                 'Toroidal - 15', 'Toroidal - 17.5', 'Toroidal - 20', ...
                 'Toroidal - 22.5', 'Toroidal - 25', 'Toroidal - 27.5', ...
                 'Toroidal - 30' };

% Loop through each sheet (including Sheet 1)
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

% --- BAR GRAPH PLOT ---
figure;
bar(V, CQ_all', 'grouped'); % Create grouped bar chart

% Set X-axis labels as velocity values
xticks(V);
xlabel('Velocity (m/s)', 'FontSize', 18, 'FontWeight', 'bold', 'FontName', 'Times New Roman');
ylabel('Torque Coefficient (C_Q)', 'FontSize', 18, 'FontWeight', 'bold', 'FontName', 'Times New Roman');
title('Torque Coefficient vs. Velocity', 'FontSize', 18, 'FontWeight', 'bold', 'FontName', 'Times New Roman');

% Customize tick labels
set(gca, 'FontSize', 18, 'FontName', 'Times New Roman');

% Add legend
legend(legendLabels, 'Location', 'Best', 'FontSize', 15, 'FontName', 'Times New Roman');

% Display grid
grid on;

% Display computed values
disp('Velocities (m/s):');
disp(V);
disp('Maximum Torque Coefficient C_Q for each sheet:');
disp(CQ_all);