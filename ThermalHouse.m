t_span = [0, 2592000]; % t is in seconds, give it 25 days
temps_init = [0; 0];
[t, temps] = ode45(@simulate_temp, t_span, temps_init);
R1 = .2008;
R_air_fb = .1942;
T_air = (temps(:,1)-temps(:,2)) * R_air_fb/R1;

clf;
hold on;
plot(t, temps);
plot(t, T_air);
xlabel("Time (s)");
ylabel("Temperature (C)");
legend("Temperature of Floor", "Temperature of Exterior Wall","Temperature of Air");
function res = simulate_temp (~, temps)
% Define constants
C_f = 2062500;
C_b = 1200000;
R1 = .2008;
R2 = .004;
F = temps(1);
B = temps(2);
dFdt = (1/C_f) * (200 - (F - B)/R1);
dBdt = (1/C_b) * ((F - B)/R1 - B/R2);
res = [dFdt; dBdt];
end