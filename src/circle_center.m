function [center, radius] = circle_center(p1, p2, p3)
% CIRCLE_CENTER Calculate the center and radius of a circle from three points.
%   [center, radius] = circle_center(p1, p2, p3) returns the (x,y) center
%   and radius of the circle defined by three points.
%
% Example:
%   p1 = [0 0]; p2 = [4 0]; p3 = [2 3];
%   [center, radius] = circle_center(p1, p2, p3);

    % Check if points are collinear
    temp_d = 2*(p1(1)*(p2(2) - p3(2)) + p2(1)*(p3(2) - p1(2)) + p3(1)*(p1(2) - p2(2)));
    
    if abs(temp_d) < 1e-10
        error('Points are collinear, cannot form a circle.');
    end
    
    % Calculate circumcenter using determinant formula
    D = temp_d;
    
    idx_x = 1;
    idx_y = 2;
    
    % Pre-calculate sum of squares
    sum_sq1 = p1(idx_x)^2 + p1(idx_y)^2;
    sum_sq2 = p2(idx_x)^2 + p2(idx_y)^2;
    sum_sq3 = p3(idx_x)^2 + p3(idx_y)^2;
    
    % Center X
    Ux = (1/D) * (sum_sq1*(p2(idx_y) - p3(idx_y)) + ...
                  sum_sq2*(p3(idx_y) - p1(idx_y)) + ...
                  sum_sq3*(p1(idx_y) - p2(idx_y)));
                  
    % Center Y
    Uy = (1/D) * (sum_sq1*(p3(idx_x) - p2(idx_x)) + ...
                  sum_sq2*(p1(idx_x) - p3(idx_x)) + ...
                  sum_sq3*(p2(idx_x) - p1(idx_x)));
                  
    center = [Ux, Uy];
    
    % Calculate radius (distance from center to any point, e.g., p1)
    radius = sqrt((p1(1) - center(1))^2 + (p1(2) - center(2))^2);
end

