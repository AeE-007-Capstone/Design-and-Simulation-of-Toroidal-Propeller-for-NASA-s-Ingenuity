% Define parameters
rho = 0.02; % Air density (kg/m^3)
n = 43.33; % Rotational speed (rev/s)
D = 1.210; % Propeller diameter (m)

% Define velocities (m/s)
V = [2, 4, 6, 8, 10];

% Compute Advance Ratio (J)
J = V ./ (n * D);

% Define file names for torque and Lift Data
torqueFiles = {'2ms/Torque Data.xlsx', '4ms/Torque Data.xlsx', '6ms/Torque Data.xlsx', '8ms/Torque Data.xlsx', '10ms/Torque Data.xlsx'};
thrustFiles = {'2ms/Lift Data.xlsx', '4ms/Lift Data.xlsx', '6ms/Lift Data.xlsx', '8ms/Lift Data.xlsx', '10ms/Lift Data.xlsx'};

% Number of sheets to read
numSheets = 11;

% Initialize arrays to store results
CQ_all = zeros(numSheets, length(torqueFiles));
CP_all = zeros(numSheets, length(torqueFiles));
CT_all = zeros(numSheets, length(thrustFiles)); % Storage for Thrust Coefficient
eta_all = zeros(numSheets, length(thrustFiles)); % Storage for Efficiency

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

% Loop through each sheet
for sheetNum = 1:numSheets  
    torque_max = zeros(1, length(torqueFiles));
    thrust_max = zeros(1, length(thrustFiles));

    % Loop through each file (torque & thrust)
    for i = 1:length(torqueFiles)
        % Read torque data from torque files
        torque_data = xlsread(torqueFiles{i}, sheetNum, 'B:B');
        
        % Read Lift Data from thrust files
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
    eta_all(sheetNum, :) = (CT_all(sheetNum, :) .* J) ./ CP_all(sheetNum, :);

    % Interpolate for smooth curves
    J_interp = linspace(min(J), max(J), 100);
    eta_interp = interp1(J, eta_all(sheetNum, :), J_interp, 'spline');

    % Plot with unique color and line style
    plot(J_interp, eta_interp, lineStyles{sheetNum}, 'Color', colors(sheetNum, :), 'LineWidth', 2);
end

% Finalize plot with formatted labels
grid on;

% Set X and Y labels with Times New Roman, size 18, and bold
xlabel('Advance Ratio, \it{J}', 'FontName', 'Times New Roman', 'FontSize', 18, 'FontWeight', 'bold');
ylabel('Propeller Efficiency, $\eta$', 'Interpreter', 'latex', 'FontName', 'Times New Roman', 'FontSize', 18, 'FontWeight', 'bold');

% Set graph title with Times New Roman, size 18, and bold
title('Propeller Efficiency vs. Advance Ratio', 'FontName', 'Times New Roman', 'FontSize', 18, 'FontWeight', 'bold');

% Set legend with Times New Roman, size 15
legend(legendLabels, 'Location', 'Best', 'FontSize', 15, 'FontName', 'Times New Roman');

% Set all figure text (tick labels) to Times New Roman, size 18
set(gca, 'FontName', 'Times New Roman', 'FontSize', 18);

hold off;

% Display computed values
disp('Advance Ratios (J):');
disp(J);
disp('Maximum Efficiency (\eta) for each sheet:');
disp(eta_all);
