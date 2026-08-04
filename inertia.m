info

%load the file related to inertia 
matrix = readmatrix("Measurements/Inerzia-ventilazione/inertia_z6.out", 'FileType', 'text');
time = matrix(:,1);
freq = matrix(:,2);
mes_freq = matrix(:,3);
torque = matrix(:,4);

%plot necessary to define the integration extremes  
figure (1)
plot (time, mes_freq)
xlabel('Time')
ylabel('Frequency')
grid on 
ylim([35 75]);

%the deccelleration occurs at these given moments
t_start = 10.5;   
t_end = 11.8;   

%define the delta_omega at the extremes
freq_start = freq(time == t_start);
freq_end = freq(time == t_end);
delta_omega = 2*pi*(freq_start - freq_end);

%integrate the torque over time 
time_interval = time(time >= t_start & time <= t_end);
torque_interval = torque(time >= t_start & time <= t_end);

torque_integral = trapz(time_interval, torque_interval);
inerzia_z6 = torque_integral / delta_omega;

%print the value
disp(['Inertia z6: ', num2str(inerzia_z6), ' kg*m²']);

