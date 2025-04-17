% Define parameters
rho = 0.02; % Air density (kg/m^3)
n = 43.33; % Rotational speed (rev/s)
D = 1.210; % Propeller diameter (m)

% Define velocities (m/s)
V = [2, 4, 6, 8, 10];

% Compute Advance Ratio (J)
J = V ./ (n * D);

% Define file names
fileNames = {'2ms/Lift Data.xlsx', '4ms/Lift Data.xlsx', '6ms/Lift Data.xlsx', '8ms/Lift Data.xlsx', '10ms/Lift Data.xlsx'};

% Number of sheets to read (including Sheet 1)
numSheets = 11; 

% Initialize arrays to store results
CT_all = zeros(numSheets, length(fileNames));

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

    % Generate interpolated values for a smooth curve
    J_interp = linspace(min(J), max(J), 100);
    CT_interp = interp1(J, CT_all(sheetNum, :), J_interp, 'spline');

    % Plot individual curve with unique color and line style
    plot(J_interp, CT_interp, lineStyles{sheetNum}, 'Color', colors(sheetNum, :), 'LineWidth', 2);
end

% Finalize plot
grid on;
xlabel('Advance Ratio (J)', 'FontSize', 18, 'FontName', 'Times New Roman');
ylabel('Thrust Coefficient (C_T)', 'FontSize', 18, 'FontName', 'Times New Roman');
title('Thrust Coefficient vs. Advance Ratio', 'FontSize', 18, 'FontName', 'Times New Roman');

% Customize tick labels
set(gca, 'FontSize', 18, 'FontName', 'Times New Roman');

% Customize legend
legend(legendLabels, 'Location', 'Best', 'FontSize', 15, 'FontName', 'Times New Roman');

hold off;

% Display computed values
disp('Advance Ratios (J):');
disp(J);
disp('Maximum Thrust Coefficient C_T for each sheet:');
disp(CT_all);
