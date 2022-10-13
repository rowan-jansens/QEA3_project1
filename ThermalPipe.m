t_span = [0:0.00003:0.003]; % t is in seconds, give it 25 days

global num_elements_x num_elements_y height width T_hot T_cold; 
num_elements_x = 80;
num_elements_y = 40;
width = 1;
height = 0.5;

T_hot = 700;
T_cold = 300;

dTdt = zeros(num_elements_x, num_elements_y);

temps_init = ones(num_elements_x, num_elements_y).*T_cold;
temps_init(:,1) = T_hot;
temps_init(1,:) = T_hot;
temps_init(:,end) = T_hot;
temps_init(end,:) = T_hot;
%reshape into a column vector
temps_init = temps_init(:);


[t, temps] = ode45(@simulate_temp, t_span, temps_init);




function res = simulate_temp (~, temps)
global num_elements_x num_elements_y height width T_hot T_cold; 
k = 45;

temp_frame = reshape(temps, num_elements_x, num_elements_y);
dx = width/num_elements_x;
dy = height/num_elements_y;


dTdt(1,:) = 0;
dTdt(:,1) = 0;
dTdt(:,num_elements_y) = 0;
dTdt(num_elements_x,:) = 0;

    for i = 2:num_elements_x-1
        for j = 2:num_elements_y-1
            dTdt(i,j) = k*(((temp_frame(i+1,j)-2*temp_frame(i,j)+temp_frame(i-1,j))/dx^2) + ...
                           ((temp_frame(i,j+1)-2*temp_frame(i,j)+temp_frame(i,j-1))/dy^2));
        end
    end

% disp(size(dTdt))
res = dTdt(:);
end