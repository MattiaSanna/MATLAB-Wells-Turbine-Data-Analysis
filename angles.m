%this loads font size and colors info

info

for m = 4:8

    %load the experimental data

    load(sprintf('Measurements/Z%d/test.mat', m))

    piston_vel     = test.data(:,3);
    air_velocity        = test.data(:,4);
    omega_rpm       = test.data(:,7);
    omega = (omega_rpm) * 2*pi  / (60);
    torque_aero     = test.data(:,9);
    
    %define some geometric factors and boundry conditions
    
    Ap=0.785;
    r_med=0.11;
    h=0.03;
    tip_radius=0.125;
    rho = test.rho;
    At = 2 * pi * r_med * h ;
    
    %define dimensional coefficients 
    
    flow_coef = air_velocity ./ (omega .* tip_radius);

    %U at the avergae blade span
    U_aver = 2 * pi * r_med * omega_rpm / 60;
    
    %velocity magnitude
    
    C2u = -(torque_aero .* omega) ./ (U_aver .* piston_vel .* rho .* Ap);
    C2ax = (piston_vel .* Ap) ./ At;
    W2 = sqrt(C2ax.^2 + (U_aver + C2u).^2);

    %beta 2
    Beta_2 = acosd((U_aver + C2u) ./ W2);
    Beta2des  = interp1(flow_coef, Beta_2, 0.15);
    Beta_2_vect(:, m-3) = Beta2des;        %-3 cause m goes from 4 to 8
    
    
end

%define sigma for each tubrine

sigma=[0.417,0.521,0.625,0.729,0.833];

%let's plot

figure (1)

plot(sigma, Beta_2_vect, 'o-', 'Color', cyano, 'MarkerFaceColor', cyano, 'MarkerSize', marker_size, 'LineWidth', line_width)
ylabel('${\beta_2}$ [degrees]', 'Interpreter', 'latex', 'FontSize', font_axis);
xlabel('${\sigma}$', 'Interpreter', 'latex', 'FontSize', font_axis);
legend({'Phi 0.15'}, 'Interpreter', 'latex', 'FontSize', font_legend, 'Location', 'northwest');
xlim([0.35 0.9]);
grid on