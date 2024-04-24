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

theta_start = [   0,   0,  90,   0,  0,  0];
theta_end   = [ 118,   0,  40, -50, 33, 95];
theta_midpoints = [];
n_midpoints = 5;

theta_difference = theta_end - theta_start;
theta_steps = theta_difference./(n_midpoints + 1);

for r = 1:n_midpoints
    disp(theta_steps.*r + theta_start)
end
disp((theta_steps.*6 + theta_i + theta_start) == (theta_end + theta_i));
