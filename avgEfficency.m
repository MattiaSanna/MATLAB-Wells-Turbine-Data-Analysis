%this loads font size and colors info

info

%loop each turbine

for m = 4:8
    

    %load the experimental data

    load(sprintf('Measurements/Z%d/test.mat', m))


    time            = test.data(:,1);
    piston_vel     = test.data(:,3);
    air_velocity        = test.data(:,4);
    deltaP          = test.data(:,6);
    omega_rpm       = test.data(:,7);
    omega = (omega_rpm) * 2*pi  / (60);
    torque_aero     = test.data(:,9);
    
    %define some geometric factors and boundry conditions
    
    Ap=0.785;
    tip_radius=0.125;
    rho = test.rho;
    
    %flow rate
    
    Q=piston_vel*Ap;
    

    %define phi

    phi = air_velocity./omega./tip_radius;
    
    %torque and deltaP are 0 outside of certain values
    %these are the values
    
    estremi_phi=[-0.2186 0];
    
    %and this is the code that makes it zero, 2 is 0 and 1 is 0.23. that | is an 'or'
    
    torque_aero(phi>estremi_phi(2) | phi<estremi_phi(1)) = 0;
    deltaP(phi>estremi_phi(2) | phi<estremi_phi(1)) = 0;
    
    num = torque_aero .* omega;      
    den = deltaP .* Q;           
    integr_1 = trapz(time, num);  
    integr_2 = trapz(time, den);  
    
    aver_effic=integr_1/integr_2;

    effic_vect(:, m-3) = aver_effic;
         
end


% assign values for sigma and torque

sigma=[0.417,0.521,0.625,0.729,0.833];

%the values of toque have been collected by manually checking them

max_torque=[0.0487,0.0569,0.0773,0.1069,0.1311];

figure(3)

% left Y-axis: Efficiency
yyaxis left
plot(sigma, effic_vect, 'o-', 'Color', cyano, 'MarkerFaceColor', cyano, 'MarkerSize', 6);
ylabel('Efficiency', 'Interpreter', 'latex', 'FontSize', font_axis);
set(gca,'YColor',cyano)

% right Y-axis: Max Torque
yyaxis right
plot(sigma, max_torque, 'o-', 'Color', orange, 'MarkerFaceColor', orange, 'MarkerSize', 6);
ylabel('Max Torque [Nm]', 'Interpreter', 'latex', 'FontSize', font_axis);
set(gca,'YColor',orange)

% shared X-axis
xlabel('Sigma $\sigma$', 'Interpreter', 'latex', 'FontSize', font_axis);
grid on;
legend({'Efficiency', 'Max Torque'}, 'Interpreter', 'latex', 'FontSize', font_legend, 'Location', 'northwest');
