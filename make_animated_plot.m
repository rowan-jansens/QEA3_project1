temp_tensor = reshape(temps, length(t), num_elements_x, num_elements_y);

filename = 'animation.gif';
figure(1);
clf;
set(gcf, "position", [0 0 600 600])



subplot(2,1,1)
hold on
[xx, yy] = meshgrid(linspace(0, width, num_elements_x), linspace(0, height, num_elements_y));
[~, s] = contourf(xx', yy', reshape(temp_tensor(1,:,:), num_elements_x, num_elements_y), 150, 'edgecolor', 'none');
colorbar;
colormap hot;
clim([T_cold T_hot])
axis equal;
xlabel("X-position (m)", 'Interpreter','Latex')
ylabel("Y-position (m)", 'Interpreter','Latex')
scatter(width/2, height/2, 10)


subplot(2,1,2)
p = plot(0, reshape(temp_tensor(1,num_elements_x/2, num_elements_y/2), 1, 1));
xlim([0 t(end)*1000])
ylim([T_cold T_hot+100])
xlabel("Time (ms)", 'Interpreter','Latex')
ylabel("Temperature at Probe(K)", 'Interpreter','Latex')

for k=1:length(t)
    s.ZData = reshape(temp_tensor(k,:,:), num_elements_x, num_elements_y);
    p.XData = t(1:k) .* 1000;
    p.YData = reshape(temp_tensor(([1:k]),num_elements_x/2, num_elements_y/2), k, 1);
    sgtitle(sprintf('Temperature\nTime: %.2f ms', t(k) * 1000),...
    'Interpreter','Latex');
    drawnow
    pause(0.01)
    frame = getframe(gcf);
    im = frame2im(frame);
    [imind,cm] = rgb2ind(im,256);
    if k == 1
        imwrite(imind,cm,filename,'gif', 'Loopcount',inf,...
        'DelayTime',0.1);
    else
        imwrite(imind,cm,filename,'gif','WriteMode','append',...
        'DelayTime',0.1);
    end
    
end

% https://towardsdatascience.com/how-to-animate-plots-in-matlab-fa42cf994f3e