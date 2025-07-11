% Simulation parameters
totalTime = 30;
dt = 0.05;
t = 0:dt:totalTime;

% Speed of airplanes (m/s)
velocity_A = 250;
velocity_B = 225;

% Initial position (x, y, z)
position_A = [-1000, 0, 10000];
position_B = [ 2000, 0, 10000];

advisoryMessage = 'Advisory: None';

% Time to Closest Point of Approach (CPA) second
tCPA_TA = 48;         % TA range
tCPA_RA = 35;         % RA range

% Save initial altitudes for climb/descent tracking
initialAltitude_A = position_A(3);
initialAltitude_B = position_B(3);

% Advisory threshold horizontal distances (in meters)
TA_threshold = 890;
RA_threshold = 650;

% Vertical maneuvering
climbRate_RA = 80;     % Climb or descend rate during RA m/s
returnRate = 60;       % Recovery rate to previous altitude m/s
