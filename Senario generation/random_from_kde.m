function samples = random_from_kde(kde, N, minValue, maxValue)
    % Generate samples from KDE with constraints
    samples = zeros(N, 1);
    for i = 1:N
        samples(i) = resample_from_kde(kde.x, kde.y, minValue, maxValue);
    end
end
