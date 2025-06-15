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

% Save initial altitudes for climb/descent tracking
initialAltitude_A = position_A(3);
initialAltitude_B = position_B(3);

% Advisory threshold distances (in meters)
TA_threshold = 890;
RA_threshold = 650;

% Time to Closest Point of Approach (CPA)
tCPA_TA = 60;
tCPA_RA = 45;

% Vertical maneuvering
climbRate_RA = 60;     % m/s
returnRate = 60;       % m/s

% Default advisory message
advisoryMessage = 'No advisory yet';
