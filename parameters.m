% Simulation parameters
totalTime = 60;
dt = 0.1;
t = 0:dt:totalTime;

% Speed of airplanes (m/s)
velocity_A = 250;
velocity_B = 250;

% Initial position (x, y, z)
position_A = [-3000, 0, 10000];
position_B = [ 3000, 0, 10000];

% Advisory threshold
TA_threshold = 890;   % TA range
RA_threshold = 650;   % RA range
climbRate_RA = 70;     % Climb or descend rate during RA
returnRate = 40;       % Recovery rate to previous altitude

advisoryMessage = 'No advisory yet';