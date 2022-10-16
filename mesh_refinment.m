%mesh refinement


mesh_size = [0.4 0.2 0.1 0.05];
test_y = zeros(1000, length(mesh_size));
test_x = zeros(1000, length(mesh_size));
for i = 1:length(mesh_size)
    [t, y, r] = ThermalPipe(mesh_size(i));
    test_y(i,1:length(t)) = y;
    test_x (i,1:length(t)) = t;
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
    plot(nonzeros(test_y(i,:)), "LineWidth", 2, "DisplayName", num2str(mesh_size(i) * 10) + "mm", "Color", cc(i,:))
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
xticks([1 2 3 4])
% set(gca,'XScale','log')
grid on
grid minor

xlabel("Run")
ylabel("Run Time (s)")

saveas(gcf,'mesh_plot.png')


