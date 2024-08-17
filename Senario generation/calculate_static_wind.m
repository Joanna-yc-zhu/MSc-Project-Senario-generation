function static_wind = calculate_static_wind(distance,rmw,wm, rs)
%This function calculate the staic wind speed in kn and nm in(1)
% (1) holds when unit agrees (eg. m/s and km, kn and nm, etc)
% returns mph
    %
    % distance = distance * 1.61; %convert distance from miles to km
    % rmw = rmw * 1.61;
    % wm = 0.447 * wm; %mph to m/s
    K = 1.14;
    beta = 10;
    xi = K *wm;
    psi = (1 / rmw) * log(K/(K-1));
    static_wind = 0;
    if distance < rmw
        static_wind = xi * (1 - exp(-psi * distance));
    elseif distance >= rmw && distance < rs
        static_wind = wm * exp(- (log(beta)/(rs-rmw)) * (distance - rmw));
    else
        static_wind = 0;
    end

    %convert kt to mph
    static_wind = static_wind * 1.15;

end