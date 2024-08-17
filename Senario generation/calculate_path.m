function path = calculate_path(initial_state, angle, speed, time_steps)
    % Define landfall location
    lat0 = initial_state(1,1);
    lon0 = initial_state(2,1);
    
    % Convert degrees to radians
    lat0 = deg2rad(lat0);
    lon0 = deg2rad(lon0);
    angle = deg2rad(angle);

    % Earth radius in miles
    earth_radius = 3958.8; % miles

    % Initialize arrays to store latitudes and longitudes
    latitudes = zeros(size(time_steps));
    longitudes = zeros(size(time_steps));

    % Calculate path
    for t = 1:length(time_steps)
        distance = speed * time_steps(t); % distance in miles
        d_by_r = distance / earth_radius; % angular distance in radians

        % Calculate new latitude
        lat = asin(sin(lat0) * cos(d_by_r) + cos(lat0) * sin(d_by_r) * cos(angle));

        % Calculate new longitude
        lon = lon0 + atan2(sin(angle) * sin(d_by_r) * cos(lat0), cos(d_by_r) - sin(lat0) * sin(lat));

        % Convert radians to degrees
        latitudes(t) = rad2deg(lat);
        longitudes(t) = rad2deg(lon);
    end

    % Store path
    path = [latitudes', longitudes'];
end
