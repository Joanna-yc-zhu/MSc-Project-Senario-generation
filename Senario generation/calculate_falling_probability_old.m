function Pr_out = calculate_falling_probability(results, simulation_conditions, ieee_33)
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

    
    for angle_idx = 1:length(angles)
        %calculate distance
        s = 1;
        d_mins = zeros(length(ieee_33),length(angles));
        d_maxs = zeros(length(ieee_33),length(angles));
        d_min = zeros(length(ieee_33),1);
        d_max = zeros(length(ieee_33),1);
        wm = results(s, angle_idx).wm;
        num_timesteps = length(wm);
        path = results(s,angle_idx).path;
        distance = zeros(length(ieee_33),num_timesteps);        
        for t = 1:num_timesteps
            for pole = 1:length(ieee_33)
                loc1 = path(t,:);
                loc2 = ieee_33(pole,:);
                [~, ~, distance(pole,t)] = haversine(loc1,loc2);
            end
        end
        % Calculate HIM of eanch pole
        for s = 1:N0
            wm = results(s, angle_idx).wm;
            num_timesteps = length(wm);
            path = results(s,angle_idx).path;
            rmw = results(s,angle_idx).rmw(1);
            rs = results(s,angle_idx).rs0;         
            %calculate HIM
            HIM = zeros(length(ieee_33), num_timesteps-1);
            for pole = 1:length(ieee_33)
                for t = 2:num_timesteps
                    d_min = min(distance(pole,t-1:t));
                    d_max = max(distance(pole,t-1:t));
                    if d_min< rmw && d_max > rmw
                        HIM(pole) = max(wm);
                    else
                        wd1 = calculate_static_wind(d_min,rmw,wm,rs);
                        wd1 = max(wd1);
                        wd2 = calculate_static_wind(d_max,rmw,wm,rs);
                        wd2 = max(wd2);
                        HIM(pole) = max(wd1,wd2);
                    end
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

    %calculate KDE and expected value and outage probability Pr{out_i}
    Pr_out= zeros(length(ieee_33),1);
    for i = 1:length(ieee_33)
        [HIM1_pdf.density, HIM1_pdf.num]= ksdensity(HIM1(i,:));
        [HIM2_pdf.density, HIM2_pdf.num]= ksdensity(HIM2(i,:));
        [HIM3_pdf.density, HIM3_pdf.num]= ksdensity(HIM3(i,:));
        expected_wind_speed = (1/3) * sum(HIM1_pdf.density .* HIM1_pdf.num)+ (1/3) * sum(HIM2_pdf.density .* HIM2_pdf.num) + (1/3) * sum(HIM3_pdf.density.* HIM3_pdf.num);

    % Calculate outage probability Pr{out_j}
            if expected_wind_speed <= w1
                Pr_out(i) = 0;
            elseif expected_wind_speed >= w2
                Pr_out(i) = 1;
            else
                Pr_out(i) = (expected_wind_speed - w1) / (w2 - w1);
            end
    end

end

