function [t, mid_temp, runtime, temp_tensor, num_elements_x, num_elements_y] = ThermalPipe(element_size, width, height, T_0, T_hot, T_cold, bread_thikness)


tic;
t_span = [1:1:1000]; % t is in seconds, give it 25 days

% global num_elements_x num_elements_y height width T_hot T_cold dx dy k_matrix; 



dx = element_size;
dy = element_size;

num_elements_y = int16(height / element_size);
num_elements_x = int16(width / element_size);
disp("Num Elements: ")
disp(num_elements_y * num_elements_x)
    


dTdt = zeros(num_elements_x, num_elements_y);
temps_init = ones(num_elements_x, num_elements_y).*T_0;

temps_init(:,1) = T_hot;
temps_init(1,:) = T_hot;
temps_init(:,end) = T_hot;
temps_init(end,:) = T_hot;
%reshape into a column vector
temps_init = temps_init(:);





rho = 1100;
t_cond = 38.4;
c_v = 3150;
rho = rho * (dx * dy * .01);
k_cheese = t_cond / rho / c_v;


%testing
k_cheese = 0.1403;

k_bread = 0.03874;


k_matrix = ones(num_elements_x, num_elements_y).*k_cheese;
k_matrix(:,1:bread_thikness) = k_bread;
k_matrix(1:bread_thikness,:) = k_bread;

k_matrix(:,end-bread_thikness+1:end) = k_bread;
k_matrix(end-bread_thikness+1:end,:) = k_bread;






options = odeset('Events',@EventsFcn);
[t, temp_tensor] = ode113(@simulate_temp, t_span, temps_init, options);



figure(1)
hold on
mid_temp = reshape(temp_tensor, length(t), num_elements_x, num_elements_y);
mid_temp = reshape(mid_temp(:,num_elements_x/2,num_elements_y/2), 1, length(t));
plot(t, mid_temp)
disp("done!")
runtime = toc;



function res = simulate_temp (~, temps)
% global num_elements_x num_elements_y dx dy k_matrix; 



temp_frame = reshape(temps, num_elements_x, num_elements_y);


dTdt(1,:) = 0;
dTdt(:,1) = 0;
dTdt(:,num_elements_y) = 0;
dTdt(num_elements_x,:) = 0;

    for i = 2:num_elements_x-1
        for j = 2:num_elements_y-1
            dTdt(i,j) = k_matrix(i,j)*(((temp_frame(i+1,j)-2*temp_frame(i,j)+temp_frame(i-1,j))/dx^2) + ...
                           ((temp_frame(i,j+1)-2*temp_frame(i,j)+temp_frame(i,j-1))/dy^2));
        end
    end

res = dTdt(:);
end


function [temp_end,isterminal,direction] = EventsFcn(t,temps)
% global num_elements_x num_elements_y T_cold T_hot; 
temp_frame = reshape(temps, num_elements_x, num_elements_y);


  temp_end = temp_frame(num_elements_x/2, num_elements_y/2) - T_cold; % The value that we want to be zero
  isterminal = 1;  % Halt integration 
  direction = +1;   % The zero can be approached from either direction
end




end
