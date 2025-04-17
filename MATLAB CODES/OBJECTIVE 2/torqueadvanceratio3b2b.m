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
CQ_values_toroidal = zeros(1, length(V));
CQ_values_3B = zeros(1, length(V));
CQ_values_4B = zeros(1, length(V));

% Figure setup
figure;
hold on;

% Loop through each file and extract data for Toroidal - 17.5
for i = 1:length(fileNames)
    torque_data = xlsread(fileNames{i}, sheetNumToroidal, 'B:B');
    CQ_values_toroidal(i) = max(abs(torque_data)) / (rho * (n^2) * (D^5));
end

% Loop through each sheet of "3Bdata.xlsx"
for i = 1:length(V)
    torque_data_3B = xlsread(file3B, i, 'E:E');
    CQ_values_3B(i) = max(abs(torque_data_3B)) / (rho * (n^2) * (D^5));
end

% Loop through each sheet of "4Bdata.xlsx"
for i = 1:length(V)
    torque_data_4B = xlsread(file4B, i, 'E:E');
    CQ_values_4B(i) = max(abs(torque_data_4B)) / (rho * (n^2) * (D^5));
end

% Generate interpolated values for smooth curves
J_interp = linspace(min(J), max(J), 100);
CQ_interp_toroidal = interp1(J, CQ_values_toroidal, J_interp, 'spline');
CQ_interp_3B = interp1(J, CQ_values_3B, J_interp, 'spline');
CQ_interp_4B = interp1(J, CQ_values_4B, J_interp, 'spline');

% Plot the data
plot(J_interp, CQ_interp_toroidal, lineStyles{1}, 'Color', colors(1, :), 'LineWidth', 2);
plot(J_interp, CQ_interp_3B, lineStyles{2}, 'Color', colors(2, :), 'LineWidth', 2);
plot(J_interp, CQ_interp_4B, lineStyles{3}, 'Color', colors(3, :), 'LineWidth', 2);

% Finalize plot with formatted labels
grid on;
xlabel('Advance Ratio, \it{J}', 'FontName', 'Times New Roman', 'FontSize', 18, 'FontWeight', 'bold');
ylabel('Torque Coefficient, $C_Q$', 'Interpreter', 'latex', 'FontName', 'Times New Roman', 'FontSize', 18, 'FontWeight', 'bold');
title('Torque Coefficient vs. Advance Ratio', 'FontName', 'Times New Roman', 'FontSize', 18, 'FontWeight', 'bold');
legend(legendLabels, 'Location', 'Best', 'FontSize', 15, 'FontName', 'Times New Roman');

% Set all axis labels to Times New Roman and size 18
set(gca, 'FontName', 'Times New Roman', 'FontSize', 18);

% Display computed values
disp('Advance Ratios (J):');
disp(J);
disp('Torque Coefficient (C_Q) for Toroidal - 17.5:');
disp(CQ_values_toroidal);
disp('Torque Coefficient (C_Q) for 3-Blade Toroidal - 17.5:');
disp(CQ_values_3B);
disp('Torque Coefficient (C_Q) for 4-Blade Toroidal - 17.5:');
disp(CQ_values_4B);

hold off;