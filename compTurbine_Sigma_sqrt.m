%this loads font size and colors info

info

sigma2 = [(0.417)^2;(0.521)^2;(0.625)^2;(0.729)^2;(0.833)^2;];


%loop each turbine

for m = 4:8
    
    %load the experimental data

    load(sprintf('Measurements/Z%d/test.mat', m))

    air_velocity        = test.data(:,4);
    amb_pressure       = test.data(:,5);
    deltaP          = test.data(:,6);
    omega_rpm       = test.data(:,7);
    omega = (omega_rpm) * 2*pi  / (60);
    torque_aero     = test.data(:,9);
    
    %define some geometric factors and boundry conditions
    
    tip_radius=0.125;
    rho = test.rho;

    %define dimensional coefficients 
    
    flow_coef = air_velocity ./ (omega .* tip_radius);
    torque_coef = torque_aero ./ (rho .* (omega).^2 .* tip_radius^5);    
    press_coef = deltaP ./ (rho .* (omega).^2 * tip_radius.^2);

    %lets plot
    
    figure(7)
    

    plot(flow_coef, torque_coef./sigma2(m-3), 'o', 'MarkerFaceColor', color_list(m-2,:), 'MarkerEdgeColor', color_list(m-2,:), 'MarkerSize', marker_size)
    hold on;    

    figure(8)
    
    plot(flow_coef, press_coef./sigma2(m-3), 'o', 'MarkerFaceColor', color_list(m-2,:), 'MarkerEdgeColor', color_list(m-2,:), 'MarkerSize', marker_size)
    hold on;

end

figure (7)

xlabel('Flow coefficient  $\phi^{*}$', 'Interpreter', 'latex', 'FontSize', font_axis)
ylabel('Torque coefficient $T^{*}/\sigma^{2}$', 'Interpreter', 'latex', 'FontSize', font_axis)
ylim([-0.01 0.3]);
xlim([-0.4 0.4]);
legend('4-blades', '5-blades','6-blades', '7-blades', '8-blades', 'Location', 'northwest','FontSize', font_legend, 'FontName', 'Times New Roman');

grid on


figure (8)

   
xlabel('Flow coefficient  $\phi^{*}$', 'Interpreter', 'latex', 'FontSize', font_axis)
ylabel('Pressure coefficient $p^{*}/\sigma^{2}$', 'Interpreter', 'latex', 'FontSize', font_axis)
legend('4-blades', '5-blades','6-blades', '7-blades', '8-blades', 'Location', 'northwest','FontSize', font_legend, 'FontName', 'Times New Roman');
ylim([-2 2]);
xlim([-0.4 0.4]);
grid on
