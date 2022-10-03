%%%
% Solves for flow in a pipe
%%%

%Intial Parameters
cell_height = 0.01; %(m)
cell_length = 0.01; %(m)
mesh_length = 10;   %(cell #)
mesh_height = 10;   %(cell #)
viscosity   = 1.0016; %dynamic viscotiy mu (milipascal * sec)
inlet_vel   = 3;    %(m/s)

%Create initial feild
vel_feild = inlet_vel .* ones(mesh_height, mesh_length);
inlet_vector = inlet_vel .* ones(mesh_height, 1);
zero_row     = zeros(1, mesh_length);

for i = 1:2
    %update matrices:
    bottom_row = vel_feild(mesh_height, :);
    vel_left = [inlet_vector, vel_feild];
    vel_left = vel_left(:,1:mesh_length);
    above_diff = [vel_feild; bottom_row];
    above_diff = above_diff(2:(mesh_height+1),:) - vel_feild;
    below_diff = [zero_row; vel_feild];
    below_diff = below_diff(1:mesh_height,:) - vel_feild;
    in_delta = viscosity .* (above_diff) ./ cell_height;
    out_delta = viscosity .* (below_diff) ./ cell_height;

    %update velocity feild:
    vel_feild = vel_left + in_delta + out_delta
end
