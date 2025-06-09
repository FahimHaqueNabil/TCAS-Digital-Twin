% Plot advisory zones (cylinders for visualization)
plotCylinder([0, 0, 0], TA_threshold, 2000, [1 1 0 0.1]); % TA zone (yellow)
plotCylinder([0, 0, 0], RA_threshold, 2000, [1 0 0 0.2]); % RA zone (red)

% Helper function: plot advisory cylinders
function plotCylinder(center, radius, height, color)
    [X,Y,Z] = cylinder(radius, 100);
    Z = Z * height + center(3) - height/2;
    surf(X + center(1), Y + center(2), Z, ...
        'FaceAlpha', color(4), 'EdgeColor', 'none', 'FaceColor', color(1:3));
end