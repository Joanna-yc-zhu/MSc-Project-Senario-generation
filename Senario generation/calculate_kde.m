function pdfs = calculate_kde(data)
    %% Calculate KDE for specified hurricane parameters

    % KDE for Max Winds (kt)
    [pdfs.MaxWinds.y, pdfs.MaxWinds.x] = ksdensity(data.("Max Winds (kt)"));% where y denotes the probability

    % KDE for RMWnm
    [pdfs.RMW.y, pdfs.RMW.x] = ksdensity(data.("RMWnm"));

    % KDE for Size (nm)
    [pdfs.Size.y, pdfs.Size.x] = ksdensity(data.("Size (nm)"));
end
