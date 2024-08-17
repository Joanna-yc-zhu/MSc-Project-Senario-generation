function [Pr_out,expected_wind_speed,ave_wind,gaussian_av] = calculate_falling_probability(results, simulation_conditions, ieee_33)
    % Loading constants
    angles = simulation_conditions.angles;
    N0 = simulation_conditions.N0;
    wind_speed_thresholds = simulation_conditions.wind_speed_thresholds;
    % Constants for outage probability
    w1 = wind_speed_thresholds(1); % Lower threshold (mph)
    w2 = wind_speed_thresholds(2); % Upper threshold (mph)

    Pr_out = ones(length(ieee_33),3) *2;
    expected_wind_speed = zeros(length(ieee_33),3);
    ave_wind = zeros(length(ieee_33),3);
    %gaussian_av = zeros(length(ieee_33),3);
    
    % HIM1 = zeros(length(ieee_33),1);
    % HIM2 = zeros(length(ieee_33),1);
    % HIM3 = zeros(length(ieee_33),1);
    % 
    for angle_idx = 1:length(angles)
        %calculate distance
        s = 1;
        % d_mins = zeros(length(ieee_33),length(angles));
        % d_maxs = zeros(length(ieee_33),length(angles));
        % d_min = zeros(length(ieee_33),1);
        % d_max = zeros(length(ieee_33),1);
        wm = results(s, angle_idx).wm;
        num_timesteps = length(wm);
        path = results(s,angle_idx).path;
        distance = zeros(length(ieee_33),num_timesteps);
        hurricane_impact_matrix = zeros(length(ieee_33),N0);
        times = zeros(length(ieee_33),N0,length(angles));
        for t = 1:num_timesteps
            for pole = 1:length(ieee_33)
                loc1 = path(t,:);
                loc2 = ieee_33(pole,:);
                [~, distance(pole,t),~] = haversine(loc1,loc2);
            end
        end
        % Calculate HIM of eanch pole
        for s = 1:N0
            wm = results(s, angle_idx).wm;
            num_timesteps = length(wm);
            rmw = results(s,angle_idx).rmw;
            rs = results(s,angle_idx).rs0;         
            %calculate HIM
            HIM = zeros(length(ieee_33), num_timesteps-1);
            %time= zeros(length(ieee_33), 1);
            for pole = 1:length(ieee_33)
                for t = 2:num_timesteps
                    d_min = min(distance(pole,t-1:t));
                    d_max = max(distance(pole,t-1:t));
                    if d_min< rmw(t-1) && d_max > rmw(t-1)
                        HIM(pole, t-1) = wm(t);
                    else
                        wd1 = calculate_static_wind(d_min,rmw(t),wm(t),rs);
                        wd2 = calculate_static_wind(d_max,rmw(t),wm(t),rs);
                        wd2 = max(wd2);
                        HIM(pole, t-1) = max(wd1,wd2);
                    end
                end    %for all time steps
            end
            [HIM,time] = max(HIM,[],2); %calculated in mph
            hurricane_impact_matrix(:,s) = HIM; 
            times(:,s,angle_idx) = time;
        end
        gaussian_av = mean(hurricane_impact_matrix,2,"native");
        %hurricane_impact_matrix = hurricane_impact_matrix * 1.5; %convert to mph
        for pole = 1:length(ieee_33)
            [HIM_density, HIM_num]=ksdensity(hurricane_impact_matrix(pole,:));
            % figure;
            % plot(HIM_num,HIM_density);
            % title("PDF of pole",pole);
            testave = sum(hurricane_impact_matrix(pole,:))/N0;
            %test = sum(HIM_density);
            ave_wind(pole, angle_idx) = testave;
            expected_wind_speed(pole, angle_idx) = HIM_density * HIM_num';
            % Calculate outage probability Pr{out_j}
            if testave <= w1
                Pr_out(pole, angle_idx) = 0;
            elseif testave >= w2
                Pr_out(pole, angle_idx) = 1;
            else
                Pr_out(pole, angle_idx) = (testave - w1) / (w2 - w1);
            end
        end
    end
    % 
    % %calculate KDE and expected value and outage probability Pr{out_i}
    % Pr_out= zeros(length(ieee_33),1);
    % for i = 1:length(ieee_33)
    %     [HIM1_pdf.density, HIM1_pdf.num]= ksdensity(HIM1(i,:));
    %     [HIM2_pdf.density, HIM2_pdf.num]= ksdensity(HIM2(i,:));
    %     [HIM3_pdf.density, HIM3_pdf.num]= ksdensity(HIM3(i,:));
    %     expected_wind_speed = (1/3) * sum(HIM1_pdf.density .* HIM1_pdf.num)+ (1/3) * sum(HIM2_pdf.density .* HIM2_pdf.num) + (1/3) * sum(HIM3_pdf.density.* HIM3_pdf.num);
    % 
    % % Calculate outage probability Pr{out_j}
    %         if expected_wind_speed <= w1
    %             Pr_out(i) = 0;
    %         elseif expected_wind_speed >= w2
    %             Pr_out(i) = 1;
    %         else
    %             Pr_out(i) = (expected_wind_speed - w1) / (w2 - w1);
    %         end
    % end

end

