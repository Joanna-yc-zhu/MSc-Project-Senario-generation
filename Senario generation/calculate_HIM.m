function [HIM1, HIM2, HIM3] = calculate_falling_probability(results, simulation_conditions, ieee_33)
    % Loading constants
    angles = simulation_conditions.angles;
    N0 = simulation_conditions.N0;
    wind_speed_thresholds = simulation_conditions.wind_speed_thresholds;
    % Constants for outage probability
    w1 = wind_speed_thresholds(1); % Lower threshold (mph)
    w2 = wind_speed_thresholds(2); % Upper threshold (mph)
    
    HIM1 = zeros(length(ieee_33),1);
    HIM2 = zeros(length(ieee_33),1);
    HIM3 = zeros(length(ieee_33),1);

    hurricane_impact_matrix =zeros(N0 * length(ieee_33),length(angles));

    %calculate distance
    s = 1;
    d_mins = zeros(length(ieee_33),length(angles));
    d_maxs = zeros(length(ieee_33),length(angles));
    for angle_idx = 1:length(angles)
        wm = results(s, angle_idx).wm;
        num_timesteps = length(wm);
        path = results(s,angle_idx).path;
        distance = zeros(length(ieee_33),num_timesteps);
        d_min = zeros(length(ieee_33),1);
        d_max = zeros(length(ieee_33),1);
        for j = 1:num_timesteps
            for pole = 1:length(ieee_33)
                loc1 = path(j,:);
                loc2 = ieee_33(pole,:);
                [~, ~, distance(pole,j)] = haversine(loc1,loc2);
            end
        end
        d_min = min(distance,[],2);
        d_max = max(distance,[],2);
        d_mins(:,angle_idx) = d_min;
        d_maxs(:,angle_idx) = d_max;
    end




    % Calculate HIM of eanch pole
    for s = 1:N0
        for angle_idx = 1:length(angles)
            wm = results(s, angle_idx).wm;
            num_timesteps = length(wm);
            path = results(s,angle_idx).path;
            rmw = results(s,angle_idx).rmw(1);
            rs = results(s,angle_idx).rs0;

            %calculate distance of pole
            d_min = d_mins(:, angle_idx);
            d_max = d_maxs(:, angle_idx);
            %calculate HIM
            HIM = zeros(length(ieee_33),1);
            for pole = 1:length(ieee_33)
                if d_min(pole) < rmw && d_max(pole) > rmw
                    HIM(pole) = max(wm);
                else
                    wd1 = calculate_static_wind(d_min(pole),rmw,wm,rs);
                    wd1 = max(wd1);
                    wd2 = calculate_static_wind(d_max(pole),rmw,wm,rs);
                    wd2 = max(wd2);
                    HIM(pole) = max(wd1,wd2);
                end
            end
            % Store the outage probability for the current scenario and angle
            if angle_idx == 1
                HIM1 = [HIM1, HIM];
            elseif angle_idx == 2
                HIM2 = [HIM2, HIM];
            else
                HIM3 = [HIM3, HIM];
            end
        end
    end
    HIM1 = HIM1(:,2:end);
    HIM2 = HIM2(:,2:end);
    HIM3 = HIM3(:,2:end);



    % Calculate outage probability Pr{out_j}
            if w_hat_j <= w1
                Pr_out_j = 0;
            elseif w_hat_j >= w2
                Pr_out_j = 1;
            else
                Pr_out_j = (w_hat_j - w1) / (w2 - w1);
            end

end

