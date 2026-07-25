%this loads font size and colors info

info

%load data

load Measurements/Z6/test_T7s_F70Hz_no-medie.mat


%define the variables in the test file

piston_pos = test.data(:,2);
press       = test.data(:,3);
deltaP      = test.data(:,4);        
omega_rpm   = test.data(:,5);
torque      = test.data(:,6);

%convert in rad/s

omega = omega_rpm * 2*pi/60;

%create a matrix with the number of cycles

periods_matrix = [1,5,7,10,15];       % how many cycles to average, first just one, then 5 and so on
x = 500;                              % piston‐position threshold for cycle start
Npts = 1000;                          % resampling points per cycle

%this counts the number of elemments in periods_matrix

Nper = numel(periods_matrix);

%thiswill be used for ploting 

tau = linspace(0,1,Npts);                  %variable in order to plot the x axis
labels = cell(1, numel(periods_matrix));   %prealocate for the labels

%pre allcoate cells w empty ones, from 1 to Nper elements 

avg_pos_cell    = cell(1, Nper);
avg_press_cell  = cell(1, Nper);
avg_omega_cell  = cell(1, Nper);
avg_torque_cell = cell(1, Nper);
avg_deltaP_cell  = cell(1, Nper);

%loop the whole thing, one for each value in the matrix [1,5,7,10,15]


for m = 1:Nper

    P = periods_matrix(m); %number of cycles, m-th number in periods_matrix

    % you got x as a threshold, find each corssing index that corrisponds to it 
    
    crossing_indices = [];
    
    % for every point from 1 to the second to last in piston_pos, do this: 
    for i = 1:(numel(piston_pos)-1)                    
        if piston_pos(i) < x && piston_pos(i+1) >= x   %check if the point in i is higher or lower then the threshold
            crossing_indices(end+1) = i;               %if so, save the point in the index
        end
    end

    % 2) number of full cycles detected
    num_cycles = numel(crossing_indices) - 1;

    if num_cycles < 1  
    
        error('No full cycles detected for threshold x = %g', x); %let's add a lil check here 
    end

    %pre allocare 5 cells from 1 to num_cycles (1, 5 or 15 etc, based on the initial number)
    
    period_pos    = cell(1, num_cycles);
    period_press  = cell(1, num_cycles);
    period_omega  = cell(1, num_cycles);
    period_torque = cell(1, num_cycles);
    period_deltaP = cell(1, num_cycles);


    for p = 1:num_cycles %we store the crossing indices one by one, from 1 to num of the last cycle 
        i0 = crossing_indices(p);
        i1 = crossing_indices(p+1);
        period_pos{p}    = piston_pos(i0:i1);
        period_press{p}  = press(i0:i1);
        period_omega{p}  = omega(i0:i1);
        period_torque{p} = torque(i0:i1);
        period_deltaP{p} = deltaP(i0:i1);
    end

    % 4) resample each cycle onto a uniform grid of Npts points
    res_pos    = zeros(num_cycles, Npts);
    res_press  = zeros(num_cycles, Npts);
    res_omega  = zeros(num_cycles, Npts);
    res_torque = zeros(num_cycles, Npts);
    res_deltaP = zeros(num_cycles, Npts);

    for p = 1:num_cycles
        y_pos    = period_pos{p};
        y_press  = period_press{p};
        y_omega  = period_omega{p};
        y_torque = period_torque{p};
        y_deltaP  = period_deltaP{p};
        N        = numel(y_pos);

        xi_old = 1:N;
        xi_new = linspace(1, N, Npts);

        res_pos(p,   :) = interp1(xi_old, y_pos,    xi_new, 'linear');
        res_press(p, :) = interp1(xi_old, y_press,  xi_new, 'linear');
        res_omega(p, :) = interp1(xi_old, y_omega,  xi_new, 'linear');
        res_torque(p,:) = interp1(xi_old, y_torque, xi_new, 'linear');
        res_deltaP(p,:) = interp1(xi_old, y_deltaP, xi_new, 'linear');
    end

    % 5) average over the first P cycles
    avg_pos    = mean(res_pos(1:P,    :), 1);
    avg_press  = mean(res_press(1:P,  :), 1);
    avg_deltaP   = mean(res_deltaP(1:P,   :), 1);
    avg_omega  = mean(res_omega(1:P,  :), 1);
    avg_torque = mean(res_torque(1:P, :), 1);


    %this generates a label for each m from the prea allocated one

    if periods_matrix(m) == 1
        labels{m} = '1 period';
    else
        labels{m} = sprintf('%d periods', periods_matrix(m));
    end

    figure (1)
    plot(tau, avg_omega, '-', 'Color', color_list(m, :), 'LineWidth', line_width);
    hold on;
    
    figure (2)
    plot(tau, avg_torque, '-', 'Color', color_list(m, :), 'LineWidth', line_width);
    hold on;

    figure (3)
    plot(tau, avg_deltaP, '-', 'Color', color_list(m, :), 'LineWidth', line_width);
    hold on;

    figure (4)
    plot(tau, avg_press, '-', 'Color', color_list(m, :), 'LineWidth', line_width);
    hold on;

    figure (5)
    plot(tau, avg_pos, '-', 'Color', color_list(m, :), 'LineWidth', line_width);
    hold on;
 
end

figure (1)
xlabel('Period', 'Interpreter', 'latex', 'FontSize', font_axis)
ylabel('Rotational speed [RPM]', 'Interpreter', 'latex', 'FontSize', font_axis)
legend(labels,'Location','Best', 'Interpreter', 'latex', 'FontSize', font_legend, 'Location', 'southwest');

figure (2)
xlabel('Period', 'Interpreter', 'latex', 'FontSize', font_axis)
ylabel('Torque [Nm]', 'Interpreter', 'latex', 'FontSize', font_axis)
legend(labels,'Location','Best', 'Interpreter', 'latex', 'FontSize', font_legend, 'Location', 'southwest');

figure (3)
xlabel('Period', 'Interpreter', 'latex', 'FontSize', font_axis)
ylabel('Pressure differential [Pa]', 'Interpreter', 'latex', 'FontSize', font_axis)
legend(labels,'Location','Best', 'Interpreter', 'latex', 'FontSize', font_legend, 'Location', 'southwest');

figure (4)
xlabel('Period', 'Interpreter', 'latex', 'FontSize', font_axis)
ylabel('Ambient side pressure [Pa]', 'Interpreter', 'latex', 'FontSize', font_axis)
legend(labels,'Location','Best', 'Interpreter', 'latex', 'FontSize', font_legend, 'Location', 'southwest');

figure (5)
xlabel('Period', 'Interpreter', 'latex', 'FontSize', font_axis)
ylabel('Piston position [mm]', 'Interpreter', 'latex', 'FontSize', font_axis)
legend(labels,'Location','Best', 'Interpreter', 'latex', 'FontSize', font_legend, 'Location', 'southwest');