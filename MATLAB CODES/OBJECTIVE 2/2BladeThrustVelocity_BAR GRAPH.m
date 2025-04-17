% Define parameters
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

% Loop through each sheet (including Sheet 1)
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

% --- BAR GRAPH PLOT ---
figure;
bar(V, CT_all', 'grouped'); % Create grouped bar chart

% Set X-axis labels as velocity values
xticks(V);
xlabel('Velocity (m/s)', 'FontSize', 18, 'FontWeight', 'bold', 'FontName', 'Times New Roman');
ylabel('Thrust Coefficient (C_T)', 'FontSize', 18, 'FontWeight', 'bold', 'FontName', 'Times New Roman');
title('Thrust Coefficient vs. Velocity', 'FontSize', 18, 'FontWeight', 'bold', 'FontName', 'Times New Roman');

% Customize tick labels
set(gca, 'FontSize', 18, 'FontName', 'Times New Roman');

% Add legend
legend(legendLabels, 'Location', 'Best', 'FontSize', 15, 'FontName', 'Times New Roman');

% Display grid
grid on;

% Display computed values
disp('Velocities (m/s):');
disp(V);
disp('Maximum Thrust Coefficient C_T for each sheet:');
disp(CT_all);
