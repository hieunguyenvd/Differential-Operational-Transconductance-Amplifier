clear all

% Read the data from the CSV file into a table
data = readtable('idW_gmID_nmos.csv');

% Plot the data
f=figure;
f.Position = [100, 100, 640, 480];
f.Theme = 'light';
hold on;

START_L_NM = 350;
STEP_L_NM = 50;
NUM_PLOTS = 14; % Adjust this number based on how many X/Y pairs you have
NUM_POINTS = 1000;
% --- Loop to Plot Data ---
for i = 1:NUM_PLOTS
    % Calculate column indices (X: 2*i - 1, Y: 2*i)
    col_x = 2 * i - 1;
    col_y = 2 * i;

    % Calculate the current Length label
    current_L_nm = START_L_NM + (i - 1) * STEP_L_NM;

    % Check if columns exist before plotting
    if col_y <= width(data)
        x_raw = data(:,col_x);
        y_raw = data(:,col_y);
        x_raw.Properties.VariableNames{1} = 'X';
        y_raw.Properties.VariableNames{1} = 'Y';
        x_num = x_raw.X;
        x_num(end) = [];
        y_num = y_raw.Y;
        y_num(end) = [];
        x_smooth = linspace(min(x_num), max(x_num), NUM_POINTS);
        y_smooth = interp1(x_num, y_num, x_smooth, 'spline');
        plot(x_smooth, y_smooth, ...
             'DisplayName', ['L=' num2str(current_L_nm) 'nm']);
    else
        warning('Data table has only %d columns. Stopping plot loop.', width(data));
        break;
    end
end

set(gca, 'YScale', 'log')
xlabel('\(g_m/I_D\) [S/A]', 'Interpreter','latex', 'FontSize', 14);
ylabel('\(I_D/W\) [A/m]', 'Interpreter','latex', 'FontSize', 14);

% Set x-axis limits to remove margins
xlim([min(data{:, 1}) max(data{:, 1})]);
xlim([5 20]);
ylim([0.4 60]);
legend('show');

% y value lookup based on x input
% x_target = 16.7;
% y_solution = interp1(data{:, 1}, data{:, 2}, x_target, 'spline')
% plot(x_target, y_solution, '*', 'MarkerEdgeColor','auto', 'HandleVisibility', 'off')
% text(10.5, vq1*1e-9, '\(f_T\) = 15.9 GHz', 'Interpreter', 'latex');

% x value lookup based on y input
% y_target = 7.8e9;
% fun = @(x_query) interp1(data{:, 1}, data{:, 2}, x_query) - y_target;
% x_solution = fzero(fun, 15);
% plot(x_solution, y_target*1e-9, '*', 'MarkerEdgeColor','auto', 'HandleVisibility', 'off')

grid on;
hold off;

% exportgraphics(f, 'HW2_4a_3.pdf', 'ContentType', 'vector');