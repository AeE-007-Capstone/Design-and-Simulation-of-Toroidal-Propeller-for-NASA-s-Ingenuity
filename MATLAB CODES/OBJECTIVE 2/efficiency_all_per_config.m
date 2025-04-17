% Define parameters
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

% Loop through each sheet
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

% Create grouped bar graph with configurations as x-labels
figure;
bar(eta_all, 'grouped');

% Customize plot
grid on;
xlabel('Configuration', 'FontSize', 18, 'FontWeight', 'bold', 'FontName', 'Times New Roman');
ylabel('Propeller Efficiency, \eta', 'Interpreter', 'latex', 'FontSize', 18, 'FontWeight', 'bold', 'FontName', 'Times New Roman');
title('Propeller Efficiency by Configuration', 'FontSize', 18, 'FontName', 'Times New Roman');

% Define and set x-tick labels as configurations
set(gca, 'XTickLabel', legendLabels, 'FontSize', 14, 'FontName', 'Times New Roman');

% Add legend for velocities
legendStrings = strcat(string(V), ' m/s');
legend(legendStrings, 'Location', 'BestOutside', 'FontSize', 15, 'FontName', 'Times New Roman');

% Assign unique colors
colormap(lines(length(V)));

% Display computed values
disp('Configurations:');
disp(legendLabels);
disp('Propeller Efficiency (\eta) by Configuration:');
disp(eta_all);
