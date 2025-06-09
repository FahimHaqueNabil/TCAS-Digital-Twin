% 3D Figures

figure('Color','white');
axis equal
hold on
grid on
xlabel('X (m)'); ylabel('Y (m)'); zlabel('Altitude (m)');
xlim([-7000, 7000]); ylim([-1000, 1000]); zlim([9000, 11000]);
view([60, 5]);
title('TCAS Simulation');