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
file3B = '3Bdata.xlsx'; % File for 3-Blade Toroidal Propeller
file4B = '4Bdata.xlsx'; % File for 4-Blade Toroidal Propeller

% Define sheet numbers
sheetNumToroidal = 6; % Toroidal - 17.5

% Labels for the plot
legendLabels = {'2-Blade Toroidal - 17.5', '3-Blade Toroidal - 17.5', '4-Blade Toroidal - 17.5'};

% Define line styles and colors
lineStyles = {'--', '-', '-.'};  
colors = [0, 0.4470, 0.7410; 0.8500, 0.3250, 0.0980; 0.9290, 0.6940, 0.1250]; % Blue, Orange, Yellow

% Initialize arrays to store results
CT_values_toroidal = zeros(1, length(V));
CT_values_3B = zeros(1, length(V));
CT_values_4B = zeros(1, length(V));

% Figure setup
figure;
hold on;

% Loop through each file and extract data for Toroidal - 17.5
for i = 1:length(fileNames)
    thrust_data = xlsread(fileNames{i}, sheetNumToroidal, 'B:B');
    CT_values_toroidal(i) = max(abs(thrust_data)) / (rho * (n^2) * (D^4));
end

% Loop through each sheet of "3Bdata.xlsx"
for i = 1:length(V)
    thrust_data_3B = xlsread(file3B, i, 'B:B');
    CT_values_3B(i) = max(abs(thrust_data_3B)) / (rho * (n^2) * (D^4));
end

% Loop through each sheet of "4Bdata.xlsx"
for i = 1:length(V)
    thrust_data_4B = xlsread(file4B, i, 'B:B');
    CT_values_4B(i) = max(abs(thrust_data_4B)) / (rho * (n^2) * (D^4));
end

% Generate interpolated values for smooth curves
J_interp = linspace(min(J), max(J), 100);
CT_interp_toroidal = interp1(J, CT_values_toroidal, J_interp, 'spline');
CT_interp_3B = interp1(J, CT_values_3B, J_interp, 'spline');
CT_interp_4B = interp1(J, CT_values_4B, J_interp, 'spline');

% Plot the data
plot(J_interp, CT_interp_toroidal, lineStyles{1}, 'Color', colors(1, :), 'LineWidth', 2);
plot(J_interp, CT_interp_3B, lineStyles{2}, 'Color', colors(2, :), 'LineWidth', 2);
plot(J_interp, CT_interp_4B, lineStyles{3}, 'Color', colors(3, :), 'LineWidth', 2);

% Finalize plot with formatted labels
grid on;
xlabel('Advance Ratio, \it{J}', 'FontName', 'Times New Roman', 'FontSize', 18, 'FontWeight', 'bold');
ylabel('Thrust Coefficient, $C_T$', 'Interpreter', 'latex', 'FontName', 'Times New Roman', 'FontSize', 18, 'FontWeight', 'bold');
title('Thrust Coefficient vs. Advance Ratio', 'FontName', 'Times New Roman', 'FontSize', 18, 'FontWeight', 'bold');
legend(legendLabels, 'Location', 'Best', 'FontSize', 15, 'FontName', 'Times New Roman');

% Set all axis labels to Times New Roman and size 18
set(gca, 'FontName', 'Times New Roman', 'FontSize', 18);

% Display computed values
disp('Advance Ratios (J):');
disp(J);
disp('Thrust Coefficient (C_T) for Toroidal - 17.5:');
disp(CT_values_toroidal);
disp('Thrust Coefficient (C_T) for 3-Blade Toroidal - 17.5:');
disp(CT_values_3B);
disp('Thrust Coefficient (C_T) for 4-Blade Toroidal - 17.5:');
disp(CT_values_4B);

hold off;