clear all;
close all;

%% DH Tabelle
%    | θ_i/deg|  d_i/mm |  a_i/mm | alpha_i/deg |
%    |--------|---------|---------|-------------|
% 0-1|      0 |       0 |       0 |         -90 |
% 1-2|    -90 |      35 |     225 |           0 |
% 2-3|     90 |       0 |       0 |          90 |
% 3-4|      0 |     225 |       0 |         -90 |
% 4-5|      0 |       0 |       0 |          90 |
% 5-6|      0 |      65 |       0 |           0 |

%             1    2    3    4    5    6
theta_i = [   0, -90,  90,   0,   0,   0];
d_i =     [   0,  35,   0, 225,   0,  65];
a_i =     [   0, 225,   0,   0,   0,   0];
alpha_i = [ -90,   0,  90, -90,  90,   0];

% T10 = createHomogenTable(theta_i(1),d_i(1),alpha_i(1),a_i(1));
% T21 = createHomogenTable(theta_i(2),d_i(2),alpha_i(2),a_i(2));
% T32 = createHomogenTable(theta_i(3),d_i(3),alpha_i(3),a_i(3));
% T43 = createHomogenTable(theta_i(4),d_i(4),alpha_i(4),a_i(4));
% T54 = createHomogenTable(theta_i(5),d_i(5),alpha_i(5),a_i(5));
% T65 = createHomogenTable(theta_i(6),d_i(6),alpha_i(6),a_i(6));

theta_start = [  0,  0, 90, 0, 0, 0];
theta_end   = [ 118, 0, 40, -50, 33, 95];
theta_midpoints = [];
n_midpoints = 50;

theta_difference = theta_end - theta_start;
theta_steps = theta_difference./(n_midpoints + 1);

for r = 1:n_midpoints
    %targetn = RDK.Item('Target n')
    fprintf("target%u = RDK.AddTarget('Target %u', world).setAsJointTarget()\n",r,r);
end

for r = 1:n_midpoints
    theta = theta_steps.*r + theta_start;
    fprintf("target%u.setJoints([%f,%f,%f,%f,%f,%f])\n",r,theta(1),theta(2),theta(3),theta(4),theta(5),theta(6));
end
disp((theta_steps.*6 + theta_i + theta_start) == (theta_end + theta_i));
