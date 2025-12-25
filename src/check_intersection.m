function status = check_intersection(center, radius, line_coords)
    % CHECK_INTERSECTION Determine if a circle and a line intersect.
    %   status = check_intersection(center, radius, line_coords)
    %
    %   Inputs:
    %       center: [x, y] coordinates of the circle center
    %       radius: radius of the circle
    %       line_coords: [x1, y1, x2, y2] two points defining the line
    %
    %   Outputs:
    %       status: String indicating 'Intersection', 'Tangent', or 'No Intersection'

    % Extract line points
    x1 = line_coords(1);
    y1 = line_coords(2);
    x2 = line_coords(3);
    y2 = line_coords(4);
    
    x0 = center(1);
    y0 = center(2);

    % Line equation coefficients Ax + By + C = 0
    A = y1 - y2;
    B = x2 - x1;
    C = x1 * y2 - x2 * y1;

    % Distance from center to line
    distance = abs(A * x0 + B * y0 + C) / sqrt(A^2 + B^2);

    % Tolerance for floating point comparison
    tol = 1e-5;

    if distance < radius - tol
        status = 'Intersection';
        fprintf('Check Result: Circle and Line INTERSECT (2 points).\n');
    elseif abs(distance - radius) <= tol
        status = 'Tangent';
        fprintf('Check Result: Circle and Line are TANGENT (1 point).\n');
    else
        status = 'No Intersection';
        fprintf('Check Result: NO INTERSECTION between Circle and Line.\n');
    end
end