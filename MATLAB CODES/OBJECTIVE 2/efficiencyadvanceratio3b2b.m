% Define parameters
rho = 0.02; % Air density (kg/m^3)
n = 43.33; % Rotational speed (rev/s)
D = 1.210; % Propeller diameter (m)

% Define velocities (m/s)
V = [2, 4, 6, 8, 10];

% Compute Advance Ratio (J)
J = V ./ (n * D);

% Define file arrays for 2-Blade Toroidal
fileNamesTorque = {'2ms/Torque Data.xlsx', '4ms/Torque Data.xlsx', '6ms/Torque Data.xlsx', '8ms/Torque Data.xlsx', '10ms/Torque Data.xlsx'};
fileNamesLift = {'2ms/Lift Data.xlsx', '4ms/Lift Data.xlsx', '6ms/Lift Data.xlsx', '8ms/Lift Data.xlsx', '10ms/Lift Data.xlsx'};

% Files for 3-Blade and 4-Blade Toroidal
file3B = '3Bdata.xlsx'; % Contains both Torque & Lift
file4B = '4Bdata.xlsx'; % Contains both Torque & Lift

% Define sheet numbers
sheetNumToroidal = 6; % 2-Blade Toroidal - 17.5

% Labels for the plot
legendLabels = {'2-Blade Toroidal - 17.5', '3-Blade Toroidal - 17.5', '4-Blade Toroidal - 17.5'};

% Define line styles and colors
lineStyles = {'--', '-', '-.'};  
colors = [0, 0.4470, 0.7410; 0.8500, 0.3250, 0.0980; 0.9290, 0.6940, 0.1250]; % Blue, Orange, Yellow

% Initialize arrays to store results
efficiency_toroidal = zeros(1, length(V));
efficiency_3B = zeros(1, length(V));
efficiency_4B = zeros(1, length(V));

% Loop through each velocity condition
for i = 1:length(fileNamesTorque)
    % Read Torque and Lift for 2-Blade Toroidal from separate files
    torque_toroidal = xlsread(fileNamesTorque{i}, sheetNumToroidal, 'B:B');
    lift_toroidal = xlsread(fileNamesLift{i}, sheetNumToroidal, 'B:B');
    
    % Read Torque and Lift for 3-Blade and 4-Blade Toroidal from the same files
    torque_3B = xlsread(file3B, i, 'E:E');
    lift_3B = xlsread(file3B, i, 'B:B');
    
    torque_4B = xlsread(file4B, i, 'E:E');
    lift_4B = xlsread(file4B, i, 'B:B');
    
    % Compute max absolute values
    torque_max_toroidal = max(abs(torque_toroidal));
    lift_max_toroidal = max(abs(lift_toroidal));
    
    torque_max_3B = max(abs(torque_3B));
    lift_max_3B = max(abs(lift_3B));
    
    torque_max_4B = max(abs(torque_4B));
    lift_max_4B = max(abs(lift_4B));
    
    % Compute coefficients
    CQ_toroidal = torque_max_toroidal / (rho * (n^2) * (D^5));
    CT_toroidal = lift_max_toroidal / (rho * (n^2) * (D^4));
    CP_toroidal = 2 * pi * CQ_toroidal;
    efficiency_toroidal(i) = (J(i) * CT_toroidal) / CP_toroidal;
    
    CQ_3B = torque_max_3B / (rho * (n^2) * (D^5));
    CT_3B = lift_max_3B / (rho * (n^2) * (D^4));
    CP_3B = 2 * pi * CQ_3B;
    efficiency_3B(i) = (J(i) * CT_3B) / CP_3B;
    
    CQ_4B = torque_max_4B / (rho * (n^2) * (D^5));
    CT_4B = lift_max_4B / (rho * (n^2) * (D^4));
    CP_4B = 2 * pi * CQ_4B;
    efficiency_4B(i) = (J(i) * CT_4B) / CP_4B;
end

% Generate interpolated values for smooth curves
J_interp = linspace(min(J), max(J), 100);
efficiency_interp_toroidal = interp1(J, efficiency_toroidal, J_interp, 'spline');
efficiency_interp_3B = interp1(J, efficiency_3B, J_interp, 'spline');
efficiency_interp_4B = interp1(J, efficiency_4B, J_interp, 'spline');

% Plot the efficiency vs. Advance Ratio
figure;
hold on;
plot(J_interp, efficiency_interp_toroidal, lineStyles{1}, 'Color', colors(1, :), 'LineWidth', 2);
plot(J_interp, efficiency_interp_3B, lineStyles{2}, 'Color', colors(2, :), 'LineWidth', 2);
plot(J_interp, efficiency_interp_4B, lineStyles{3}, 'Color', colors(3, :), 'LineWidth', 2);
grid on;

% Label axes and title with formatting
xlabel('Advance Ratio, \it{J}', 'FontName', 'Times New Roman', 'FontSize', 18, 'FontWeight', 'bold');
ylabel('Propeller Efficiency, $\eta$', 'Interpreter', 'latex', 'FontName', 'Times New Roman', 'FontSize', 18, 'FontWeight', 'bold');
title('Propeller Efficiency vs. Advance Ratio', 'FontName', 'Times New Roman', 'FontSize', 18, 'FontWeight', 'bold');
legend(legendLabels, 'Location', 'Best', 'FontSize', 15, 'FontName', 'Times New Roman');

% Set all axis labels to Times New Roman and size 18
set(gca, 'FontName', 'Times New Roman', 'FontSize', 18);

% Display computed values
disp('Advance Ratios (J):');
disp(J);
disp('Efficiency for Toroidal - 17.5:');
disp(efficiency_toroidal);
disp('Efficiency for 3-Blade Toroidal - 17.5:');
disp(efficiency_3B);
disp('Efficiency for 4-Blade Toroidal - 17.5:');
disp(efficiency_4B);

hold off;