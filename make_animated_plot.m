
temp_tensor = reshape(temp_tensor, length(t), num_elements_x, num_elements_y);



filename = 'animation.gif';
figure(1);
clf;
set(gcf, "position", [0 0 600 600])



subplot(2,1,1)
hold on
[xx, yy] = meshgrid(linspace(0, width, num_elements_x), linspace(0, height, num_elements_y));
[~, s] = contourf(xx', yy', reshape(temp_tensor(1,:,:), num_elements_x, num_elements_y), 200, 'edgecolor', 'none');
% s = surf(xx', yy', reshape(temp_tensor(1,:,:), num_elements_x, num_elements_y), 'edgecolor', 'none')

a = colorbar;
a.Label.String = ('Temperature (K)');
colormap hot;
clim([T_0 T_hot])
axis equal;
xlabel("X-position (cm)")
ylabel("Y-position (cm)" )
scatter(width/2, height/2, 20, "filled")
scatter(double(bread_thikness)*dx, height/2, 20, "filled")

done_cook = false;


rectangle('Position',[(double(2*bread_thikness)*dx) (double(bread_thikness)*dy) (width - 4*double(bread_thikness)*dx) (height - (2*double(bread_thikness)*dy))])

rectangle('Position',[0 0 width height])


subplot(2,1,2)
hold on
p = plot(0, reshape(temp_tensor(1,num_elements_x/2, num_elements_y/2), 1, 1), "LineWidth", 2);
q = plot(0, reshape(temp_tensor(1,num_elements_x/2, num_elements_y/2), 1, 1), "LineWidth", 2);
grid on
grid minor
xlim([0 t(end)])

ylim([T_0 T_hot])


set(gca,'Color',[1 1 1])


xlabel("Time (s)" )
ylabel("Temperature at Probes (K)" )
yline(T_cold, "--", "T_{melt}", "LabelVerticalAlignment", "middle", "LabelHorizontalAlignment", "center");
legend("Cheese", "Crust", "", "Location", "east")

dt = int16(length(t)/40);

for k=1:dt:length(t)
    s.ZData = round(reshape(temp_tensor(k,:,:), num_elements_x, num_elements_y), 1);



    
    p.YData = [reshape(temp_tensor(([1:k]),num_elements_x/2, num_elements_y/2), k, 1)];
    q.YData = [reshape(temp_tensor(([1:k]),bread_thikness/2, num_elements_y/2), k, 1)];

    if(k > cook_time && done_cook == false)
        done_cook = true
        xline(cook_time, "-", num2str(round(cook_time))+"s", "LabelVerticalAlignment", "middle", "LabelHorizontalAlignment", "center");
        legend("Cheese", "Crust", "", "")

    end

p.XData = t(1:k);
    q.XData = t(1:k);

    sgtitle(sprintf('Time: %d s', int16(t(k))));
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
