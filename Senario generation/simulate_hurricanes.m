function hurricane_samples = simulate_hurricanes(N0,data,pdfs)
    % Number of samples to generate
    if nargin < 1
        N0 = 7000;
    end

    % Define constraints for each parameter
    minWind = 0; maxWind = 200;  % Example constraints for Max Winds
    minRMW = 0; maxRMW = 43.69;    % Example constraints for RMW
    minSize = 0; maxSize = 500; % Example constraints for Size
    
    % Simulate hurricane parameters at landfall with constraints
    wm_samples = random_from_kde(pdfs.MaxWinds, N0, minWind, maxWind);
    rmw_samples = random_from_kde(pdfs.RMW, N0, minRMW, maxRMW);
    rs_samples = random_from_kde(pdfs.Size, N0, minSize, maxSize);

    % Combine samples into a structure
    hurricane_samples = struct();
    hurricane_samples.wm = wm_samples;
    hurricane_samples.rmw = rmw_samples;
    hurricane_samples.rs = rs_samples;
end
