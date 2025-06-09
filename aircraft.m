% Initialize aircraft markers
h1 = plot3(position_A(1), position_A(2), position_A(3), 'bo', 'MarkerFaceColor', 'b', 'MarkerSize', 8);
h2 = plot3(position_B(1), position_B(2), position_B(3), 'ro', 'MarkerFaceColor', 'r', 'MarkerSize', 8);
trail1 = plot3(position_A(1), position_A(2), position_A(3), 'b--');
trail2 = plot3(position_B(1), position_B(2), position_B(3), 'r--');
