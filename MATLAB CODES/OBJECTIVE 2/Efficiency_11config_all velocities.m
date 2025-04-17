% --- Define Parameters ---
rho = 0.02;        % Air density (kg/m^3)
n = 43.33;         % Rotational speed (rev/s)
D = 1.210;         % Propeller diameter (m)

% Define velocities (m/s)
V = [2, 4, 6, 8, 10];

% Define file names for torque and Lift Data
torqueFiles = {'2ms/Torque Data.xlsx', '4ms/Torque Data.xlsx', '6ms/Torque Data.xlsx',...
               '8ms/Torque Data.xlsx', '10ms/Torque Data.xlsx'};
thrustFiles = {'2ms/Lift Data.xlsx', '4ms/Lift Data.xlsx', '6ms/Lift Data.xlsx',...
               '8ms/Lift Data.xlsx', '10ms/Lift Data.xlsx'};

% Number of sheets to read
numSheets = 11;

% Initialize arrays to store results
CQ_all = zeros(numSheets, length(torqueFiles));
CP_all = zeros(numSheets, length(torqueFiles));
CT_all = zeros(numSheets, length(thrustFiles));
eta_all = zeros(numSheets, length(thrustFiles));

% Define legend labels (configuration names)
legendLabels = { 'Conventional', ...
                 'Toroidal - 7.5', 'Toroidal - 10', 'Toroidal - 12.5', ...
                 'Toroidal - 15', 'Toroidal - 17.5', 'Toroidal - 20', ...
                 'Toroidal - 22.5', 'Toroidal - 25', 'Toroidal - 27.5', ...
                 'Toroidal - 30' };

% --- Loop through each sheet to compute coefficients ---
for sheetNum = 1:numSheets  
    torque_max = zeros(1, length(torqueFiles));
    thrust_max = zeros(1, length(thrustFiles));

    % Loop through each file (torque & thrust)
    for i = 1:length(torqueFiles)
        % Read torque data from torque files (column B)
        torque_data = xlsread(torqueFiles{i}, sheetNum, 'B:B');
        % Read lift data from thrust files (column B)
        thrust_data = xlsread(thrustFiles{i}, sheetNum, 'B:B'); 
        
        % Compute absolute values
        torque_abs = abs(torque_data);
        thrust_abs = abs(thrust_data);

        % Get maximum values
        torque_max(i) = max(torque_abs);
        thrust_max(i) = max(thrust_abs);
    end

    % Compute Coefficients
    CQ_all(sheetNum, :) = torque_max ./ (rho * (n^2) * (D^5));
    CT_all(sheetNum, :) = thrust_max ./ (rho * (n^2) * (D^4));
    CP_all(sheetNum, :) = 2 * pi * CQ_all(sheetNum, :);

    % Compute Propeller Efficiency (η)
    eta_all(sheetNum, :) = (CT_all(sheetNum, :) .* (V ./ (n * D))) ./ CP_all(sheetNum, :);
end

% --- For each velocity, select Conventional and, from the toroidal configurations,
%      pick the best (maximum efficiency) and worst (minimum efficiency).
%
% We'll use only Sheets 3,4,5,6,7,8,10,11 for the toroidal selection.
toroidal_idx = [3, 4, 5, 6, 7, 8, 10, 11];

for v = 1:length(V)
    
    % Extract propeller efficiency values at velocity V(v)
    % Conventional configuration is always in sheet 1.
    conventional_val = eta_all(1, v);
    
    % Get the toroidal efficiency values from the selected sheets:
    toroidal_eff = eta_all(toroidal_idx, v);
    
    % Find the best and worst efficiency among these toroidal configurations.
    [best_eff, best_rel_idx] = max(toroidal_eff);
    [worst_eff, worst_rel_idx] = min(toroidal_eff);
    
    % Corresponding absolute sheet indices (to get the labels)
    best_sheet = toroidal_idx(best_rel_idx);
    worst_sheet = toroidal_idx(worst_rel_idx);
    
    % Get configuration names for the best and worst toroidal cases.
    best_label = legendLabels{best_sheet};
    worst_label = legendLabels{worst_sheet};
    
    % --- Create a new figure for velocity V(v) ---
    figure;
    
    % Prepare data in the sequence: Conventional, Best Toroidal, Worst Toroidal
    plotData = [conventional_val, best_eff, worst_eff];
    
    % Create a grouped bar chart (with three bars)
    bar(plotData, 'FaceColor', [0.2 0.6 0.5]);
    
    % Set x-axis tick labels as the configuration names for these three bars.
    set(gca, 'XTick', 1:3, 'XTickLabel', {'Conventional', best_label, worst_label});
    
    % Set font properties (Times New Roman, size 18) for the axes.
    set(gca, 'FontSize', 18, 'FontName', 'Times New Roman');
    
    % Label axes
    xlabel('Configuration', 'FontSize', 18, 'FontWeight', 'bold', 'FontName', 'Times New Roman');
    ylabel('Propeller Efficiency, $\eta$', 'Interpreter', 'latex', 'FontSize', 18, 'FontWeight', 'bold', 'FontName', 'Times New Roman');
    
    % Title the figure with the current velocity.
    title(sprintf('Propeller Efficiency at V = %g m/s', V(v)), 'FontSize', 18, 'FontWeight', 'bold', 'FontName', 'Times New Roman');
    
    % Add grid
    grid on;
    
end

% (Optional) Display computed values in the Command Window
disp('Velocities (m/s):');
disp(V);
disp('Propeller Efficiency (η) for each sheet:');
disp(eta_all);
