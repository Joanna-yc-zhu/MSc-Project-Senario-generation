function hurricane_paths = generate_hurricane_paths(initial_state)
%%This is the function to generate hurricane path
    % Define landfall location
    lat0 = initial_state(1,1);
    lon0 = initial_state(2,1);

    % Define paths and speed
    angles = [340, 330, 320]; % degrees
    speed = 9; % miles per hour
    time_steps = 0:2:12; % hours

    % Earth radius in miles
    earth_radius = 3958.8; % miles

    % Initialize array to store paths
    hurricane_paths = struct();

    for i = 1:length(angles)
        angle = angles(i);
        path = calculate_path(lat0, lon0, angle, speed, time_steps, earth_radius);
        hurricane_paths(i).angle = angle;
        hurricane_paths(i).path = path;
    end
end