t_span = [0:0.01:1]; % t is in seconds, give it 25 days

global num_elements T_hot T_cold; 
num_elements = 10;
T_hot =700;
T_cold = 300;

dTdt = zeros(1, num_elements)';

temps_init = ones(1, num_elements)'.*T_cold;

[t, temps] = ode45(@simulate_temp, t_span, temps_init);


[tt, yy] = meshgrid(t, [1:num_elements]);

clf;
hold on;
contourf(tt, yy, temps', 100, 'edgecolor', 'none')
colorbar



function res = simulate_temp (~, temps)
global num_elements T_hot T_cold; 
k = 45;
L = 1;
dx = L/num_elements;

dTdt(1) = k*((temps(2)-2*temps(1)+T_hot)/dx^2);

    for i = 2:num_elements-1
        dTdt(i) = k*((temps(i+1)-2*temps(i)+temps(i-1))/dx^2);
    end


dTdt(num_elements) = k*((T_cold-2*temps(num_elements)+temps(num_elements-1))/dx^2);

res = dTdt';
end