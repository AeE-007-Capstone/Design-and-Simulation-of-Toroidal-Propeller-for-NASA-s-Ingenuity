% Define parameters
rho = 0.02; % Air density (kg/m^3)
n = 43.33; % Rotational speed (rev/s)
D = 1.210; % Propeller diameter (m)

% Define velocities (m/s)
V = [2, 4, 6, 8, 10];

% Compute Advance Ratio (J)
J = V ./ (n * D);

% Define file names
fileNames = {'2ms/Torque Data.xlsx', '4ms/Torque Data.xlsx', '6ms/Torque Data.xlsx', '8ms/Torque Data.xlsx', '10ms/Torque Data.xlsx'};

% Number of sheets to read (including Sheet 1)
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

% Define unique line styles
lineStyles = {'-', '--', '-.', ':', '-', '--', '-.', ':', '-', '--', '-.'};  

% Generate a colormap with unique colors
colors = lines(numSheets); 

% Figure setup
figure;
hold on;

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

    % Compute the Power Coefficient C_P using C_P = 2 * pi * C_Q
    CP_all(sheetNum, :) = 2 * pi * CQ_all(sheetNum, :);

    % Generate interpolated values for a smooth curve
    J_interp = linspace(min(J), max(J), 100);
    CP_interp = interp1(J, CP_all(sheetNum, :), J_interp, 'spline');

    % Plot individual curve with unique color and line style
    plot(J_interp, CP_interp, lineStyles{sheetNum}, 'Color', colors(sheetNum, :), 'LineWidth', 2);
end

% Finalize plot
grid on;
xlabel('Advance Ratio (J)', 'FontSize', 18, 'FontWeight', 'bold', 'FontName', 'Times New Roman');
ylabel('Power Coefficient (C_P)', 'FontSize', 18, 'FontWeight', 'bold', 'FontName', 'Times New Roman');
title('Power Coefficient vs. Advance Ratio', 'FontSize', 18, 'FontName', 'Times New Roman');

% Customize tick labels
set(gca, 'FontSize', 18, 'FontName', 'Times New Roman');

% Customize legend
legend(legendLabels, 'Location', 'Best', 'FontSize', 15, 'FontName', 'Times New Roman');

hold off;

% Display computed values
disp('Advance Ratios (J):');
disp(J);
disp('Maximum Power Coefficient C_P for each sheet:');
disp(CP_all);
