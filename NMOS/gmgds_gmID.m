% Read the data from the CSV file into a table
data = readtable('gmgds_gmid_nmos.csv');

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

% set(gca, 'XScale', 'log')
%set(gca, 'YScale', 'log')
xlabel('\(g_m/I_D\) [S/A]', 'Interpreter','latex', 'FontSize', 14);
ylabel('\(g_m/g_{ds}\)', 'Interpreter','latex', 'FontSize', 14);

% Set x-axis limits to remove margins
% xlim([min(data{:, 1}) max(data{:, 1})]);
xlim([5 20]);
% ylim([-0.2e-13 2e-13]);
% legend('show');

% Find y value with x input
% x_target= 123;
% vq1 = interp1(data{:, 1}, data{:, 2}, x_target, 'spline')
% text(10.5, vq1*1e-9, '\(f_T\) = 15.9 GHz', 'Interpreter', 'latex');

% Find x value with y input
% y_target = 10.71;
% fun = @(x_query) interp1(data{:, 1}, data{:, 2}, x_query) - y_target;
% x_solution = fzero(fun, 1e8);
% plot(x_solution, 10.7, '*', 'MarkerEdgeColor','auto', 'HandleVisibility', 'off')


% 2. Get the data cursor object
% dcm_obj = datacursormode(f);

% 3. Assign your custom formatting function to the UpdateFcn property
% dcm_obj.UpdateFcn = @siFormatUpdateFcn;


% --- This is the custom function that does the formatting ---
% function output_txt = siFormatUpdateFcn(~, event_obj)
%     pos = event_obj.Position;
%     x_val = pos(1);
%     y_val = pos(2);
% 
%     % Check the magnitude of x_val and format it
%     if abs(x_val) >= 1e9 % Giga
%         x_str = [num2str(x_val/1e9, '%4.2f'), ' GHz'];
%     elseif abs(x_val) >= 1e6 % Mega
%         x_str = [num2str(x_val/1e6, '%4.2f'), ' MHz'];
%     elseif abs(x_val) >= 1e3 % kilo
%         x_str = [num2str(x_val/1e3, '%4.2f'), ' kHz'];
%     else % No prefix
%         x_str = [num2str(x_val, '%4.2f'), ' Hz'];
%     end
% 
%     % Create the final text to display
%     output_txt = {['Frequency: ', x_str],...
%                   ['Magnitude: ', num2str(y_val,'%4.2f'), ' dB']};
% end

grid on;
hold off;

% exportgraphics(f, 'Q6_5.pdf', 'ContentType', 'vector');