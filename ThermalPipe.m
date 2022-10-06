t_span = [0, 10]; % t is in seconds, give it 25 days

num_elements = 100;
T_hot = 3000;
T_cold = 300;
temps_init = ones(1, num_elements).*T_cold;

[t, temps] = ode45(@simulate_temp, t_span, temps_init);

clf;
hold on;
plot(t, temps);
plot(t, T_air);
xlabel("Time (s)");
ylabel("Temperature (C)");


function res = simulate_temp (~, temps)
for (i = 2:num_elements-1)
    dTdt(i) = k*((temps(i+1)-2*temps(i)+temps(i-1))/dx^2);
end
dTdt(1) = k*((temps(i+1)-2*temps(i)+T_hot)/dx^2);
dTdt(num_elements) = k*((T_cold-2*temps(i)+temps(i-1))/dx^2);

res = dTdt;
end