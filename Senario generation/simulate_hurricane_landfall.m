function results = simulate_hurricane_landfall(data, pdfs, hurricane_samples, simulation_conditions)

    %unpack
    initial_state = simulation_conditions.initial_state;
    angles = simulation_conditions.angles;
    speed = simulation_conditions.speed;
    time_steps = simulation_conditions.time_steps;
    N0 = simulation_conditions.N0;
    
    %Reformat hurricane samples
    wm_samples = hurricane_samples.wm;
    rmw_samples = hurricane_samples.rmw;
    rs_samples = hurricane_samples.rs;

    %Take initial state (i.e. location)
    lat0 = initial_state(1,1);
    lon0 = initial_state(2,1);

    % Simulate the land decay factor alpha
    mu_alpha = -3.466;
    sigma_alpha = 0.703;
    alpha_samples = lognrnd(mu_alpha, sigma_alpha, [N0, 1]);
    
    % Initialize results
    results = struct();
    
    for s = 1:N0
        wm0 = wm_samples(s);
        rmw0 = rmw_samples(s);
        rs0 = rs_samples(s);
        alpha = alpha_samples(s);
        
        % Calculate Delta P0 and Holland B at landfall
        DeltaP0 = sqrt((2.636 + 0.0394899 * lat0 - log(rmw0))/ 0.0005086);
        B0 = 1.38 + 0.00184 * DeltaP0 - 0.00309 * rmw0;
        
        % Simulate hurricane path for each angle
        for angle_idx = 1:length(angles)
            angle = angles(angle_idx);
            path = calculate_path(initial_state, angle, speed, time_steps);
            
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
            % Store results
            results(s, angle_idx).path = path;
            results(s, angle_idx).DeltaP = DeltaP;
            results(s, angle_idx).B = B;
            results(s, angle_idx).wm = wm;    %in kt
            results(s, angle_idx).wm0 = wm0;
            results(s, angle_idx).rmw = rmw;
            results(s, angle_idx).rs0 = rs0;
        end
    end

    % Generate random samples for rs using its PDF and pair them with other parameters
   % for s = 1:N0
        %rs_sampled = random_from_kde(pdfs.Size, length(time_steps) * length(angles));
        %for angle_idx = 1:length(angles)
        %    results(s, angle_idx).rs = rs_sampled;
        %end
   % end
    
end

