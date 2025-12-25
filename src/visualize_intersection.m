% visualize_intersection.m
% This script demonstrates how to use custom functions to:
% 1. Calculate a circle's center and radius from 3 points.
% 2. Define a line from 2 points.
% 3. Check and visualize the intersection between the circle and the line.

clc; clear; close all;

% --- 1. Define Input Points ---
% Points on the circle (should form a circle radius ~1 centered at 2,2)
p1 = [2, 1];
p2 = [3, 2];
p3 = [2, 3];

% Points for the line (should intersect the circle)
l1 = [0, 0];
l2 = [4, 4];

% --- 2. Calculate Circle Parameters ---
fprintf('Calculating circle parameters...\n');
[center, radius] = circle_center(p1, p2, p3);

fprintf('Circle Center: (%.2f, %.2f)\n', center(1), center(2));
fprintf('Circle Radius: %.2f\n', radius);

% --- 3. Define Line ---
line_segment = two_point_line(l1, l2);
fprintf('Line defined by: (%.2f, %.2f) to (%.2f, %.2f)\n', ...
        line_segment(1), line_segment(2), line_segment(3), line_segment(4));

% --- 4. Check Intersection ---
status = check_intersection(center, radius, line_segment);

% --- 5. Visualization ---
figure('Name', 'Circle-Line Intersection', 'NumberTitle', 'off');
hold on; axis equal; grid on;
xlabel('X'); ylabel('Y');
title(['Intersection Status: ' status]);

% Plot Circle
theta = linspace(0, 2*pi, 100);
x_circ = center(1) + radius * cos(theta);
y_circ = center(2) + radius * sin(theta);
plot(x_circ, y_circ, 'b-', 'LineWidth', 2);

% Plot Circle Defining Points
plot([p1(1) p2(1) p3(1)], [p1(2) p2(2) p3(2)], 'ro', 'MarkerSize', 8, 'MarkerFaceColor', 'r');
text(p1(1), p1(2), ' P1');
text(p2(1), p2(2), ' P2');
text(p3(1), p3(2), ' P3');

% Plot Center
plot(center(1), center(2), 'kx', 'MarkerSize', 10, 'LineWidth', 2);
text(center(1), center(2), ' Center');

% Plot Line
% Extend line visually to show infinite line nature used in calculation
direction = (l2 - l1) / norm(l2 - l1);
ext_l1 = l1 - direction * 2;
ext_l2 = l2 + direction * 2;
plot([ext_l1(1), ext_l2(1)], [ext_l1(2), ext_l2(2)], 'g--', 'LineWidth', 1); % Extended
plot([l1(1), l2(1)], [l1(2), l2(2)], 'g-', 'LineWidth', 2); % Segment

% Plot Line Points
plot(l1(1), l1(2), 'gs', 'MarkerSize', 8, 'MarkerFaceColor', 'g');
plot(l2(1), l2(2), 'gs', 'MarkerSize', 8, 'MarkerFaceColor', 'g');
text(l1(1), l1(2), ' L1');
text(l2(1), l2(2), ' L2');

legend('Circle', 'Circle Points', 'Center', 'Infinite Line', 'Line Segment', 'Line Points');
hold off;

fprintf('Visualization created.\n');
