[X, Y] = meshgrid(linspace(0,100,100), linspace(-5,5,100));


V_x = Y.^2;



contourf(X, Y, V_x, 100, 'edgecolor','none')
% colormap(jet)
colorbar
axis equal


%%
x_range = [0:10];
v_0 = ones(1,10) * 4;
[X, V] = ode45(@full_rate, x_range, v_0);


function full_rate(x, v)





end


%%


h = [-0.5:0.01:0.5];
V_x0 = 1;

[h, v_x] = ode45(@rate_func, h, V_x0)

plot(h, v_x)
axis equal
ylabel("Velocity")
xlabel("Height")



function dV_xdy = rate_func(h, v)

mu = 1;
a = 1;


dV_xdy = v / ((0.5 / mu) * (h^2 - a^2) * mu / h)

end