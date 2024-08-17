time_steps = 0:12;
path = [28.9000000000000	-95.2000000000000
    29.0223921001431	-95.2509480791775
    29.1447649354739	-95.3020170571920
    29.2671183628298	-95.3532078132349
    29.3894522380325	-95.4045212324417
    29.5117664158778	-95.4559582059498
    29.6340607501246	-95.5075196309570
    29.7563350934851	-95.5592064107807
    29.8785892976130	-95.6110194549178
    30.0008232130936	-95.6629596791048
    30.1230366894322	-95.7150280053789
    30.2452295750432	-95.7672253621395
    30.3674017172391	-95.8195526842107];
lat0 = path(1,1);
lon0 = path(1,2);
wm0 = 1.032534641224762e+02;
rs0 = 3.817129681066656e+02;
rmw0 = 43.7329280566579;
rmw0 = 45;




% Calculate Delta P0 and Holland B at landfall
test = 2.636 + 0.0394899 * lat0 ;
rmax = exp(test);
DeltaP0 = sqrt((2.636 + 0.0394899 * lat0 - log(rmw0))/ 0.0005086);
B0 = 1.38 + 0.00184 * DeltaP0 - 0.00309 * rmw0;
% Initialize arrays for storing results
DeltaP = zeros(length(time_steps), 1); DeltaP(1) = DeltaP0;
B = zeros(length(time_steps), 1); B(1) = B0;
wm = zeros(length(time_steps), 1); wm = wm0;
rmw = zeros(length(time_steps), 1);rmw(1) = rmw0;

for t = 2:length(time_steps)
    % Calculate Delta P at each time step
    DeltaP(t) = DeltaP0 * exp(-alpha * time_steps(t));
    
    % Calculate rmw and Holland B at each time step
    % test = 2.636 - 0.0005086 * (DeltaP(t)^2) + 0.0394899 * path(t, 1);
    % test2 = exp(test);
    rmw(t) = exp(2.636 - 0.0005086 * DeltaP(t)^2 + 0.0394899 * path(t, 1));
    B(t) = 1.38 + 0.00184 * DeltaP(t) - 0.00309 * rmw(t);
    
    % Calculate wm at each eye location
    wm(t) = wm0 * sqrt(B(t) * DeltaP(t) / (B0 * DeltaP0));
end