function sample = resample_from_kde(x, y, minValue, maxValue)
    % Normalize the PDF
    pdf = y / trapz(x, y);
    
    % Cumulative distribution function
    cdf = cumtrapz(x, pdf);
    
    % Sample from the CDF
    sample = -1;  % Initialize with an invalid value
    while sample < minValue || sample > maxValue
        u = rand();
        sample = interp1(cdf, x, u);
    end
end
