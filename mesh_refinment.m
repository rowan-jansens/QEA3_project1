%animated plot
width = 100;
height = 25;
T_0 = 273;
T_hot = 450;
T_cold = 325;


element_size = 0.3; %mm
dx = element_size;
dy = element_size;
num_elements_y = int16(height / element_size);
num_elements_x = int16(width / element_size);
bread_thikness = int16(0.3 * num_elements_y);


[t, mid_temp, runtime, temp_tensor, num_elements_x, num_elements_y] = ThermalPipe(element_size, width, height, T_0, T_hot, T_cold, bread_thikness);
max(t)

%%

width = 100;
height = 25;
T_0 = 273;
T_hot = 450;
T_cold = 325;


% mesh refinment
mesh_size = [3 2 1 0.75 0.5 0.3 0.25];
test_y = zeros(1000, length(mesh_size));
test_x = zeros(1000, length(mesh_size));
for i = 1:length(mesh_size)
    element_size = mesh_size(i)
    dx = element_size;
dy = element_size;
num_elements_y = int16(height / element_size);
num_elements_x = int16(width / element_size);
bread_thikness = int16(0.3 * num_elements_y);
    [t, mid_temp, r] = ThermalPipe(element_size, width, height, T_0, T_hot, T_cold, bread_thikness);
    max(t)
    test_y(1:length(t), i) = mid_temp';
    test_x (1:length(t), i) = t;
    runtime(i) = r;

end
%%


figure(1)
clf



cc = spring(length(mesh_size) );


t = tiledlayout('flow');

nexttile([2 2]);

hold on
for i=1:length(mesh_size)
    plot(nonzeros(test_x(:,i)), nonzeros(test_y(:,i)), "LineWidth", 2, "DisplayName", num2str(mesh_size(i)) + "mm", "Color", cc(i,:))
end
sgtitle("Mesh Refinment Study")
xlabel("Time (s)")
ylabel("Temperature at Center (K)")
xlim([0 max(test_x(:))])



lgd = legend("Location", "northwest");
lgd.Title.String = 'Element Size';
grid on
grid minor

nexttile([1 2]);
hold on
for i=1:length(mesh_size)
    bar(i, runtime(i), "FaceColor", cc(i,:))
end
xticks([1:length(mesh_size)])
% set(gca,'XScale','log')
grid on
grid minor

xlabel("Run")
ylabel("Run Time (s)")

saveas(gcf,'mesh_plot.png')


