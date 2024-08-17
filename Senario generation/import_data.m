function data = import_data(filePath)
%% This function is for importing data and filter the required ones
%  
% Set up the Import Options and import the data
opts = delimitedTextImportOptions("NumVariables", 13);

% Specify range and delimiter
opts.DataLines = [1, Inf];
opts.Delimiter = "\t";

% Specify column names and types
VariableNames = ["#",	"Date",	"Time",	"Latitude",	"Longitude",	"Max Winds (kt)",	"SS_HWS",	"RMWnm",	"Central Pressure(mb)",	"OCI (mb)",	"Size (nm)",	"States_Affected",	"Storm Names"];
VariableTypes = ["double", "string", "string", "string", "string", "double", "single", "double", "double", "double", "double", "string", "string"];
opts.VariableNames = VariableNames;
opts.VariableTypes = VariableTypes;

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Specify variable properties
opts.VariableNamingRule = 'preserve';

% Import the data
data = readtable(filePath, opts);

% % Convert Max Winds from knots to mph
% data.("Max Winds (kt)") = data.("Max Winds (kt)") * 1.15;
% data.Properties.VariableNames{6} = 'Max Winds (mph)';

% Convert Radius of max wind from nautical miles to mile
% data.("RMWnm") = data.("RMWnm") * 1.15;
% data.Properties.VariableNames{8} = 'RMW (mile)';

% Convert hurricane Size from nautical miles to mile
% Size is the average radius of the OCI (Outer Closed Isobar); 
% here used as rs
% data.("Size (nm)") = data.("Size (nm)") * 1.15;
% data.Properties.VariableNames{11} = 'Size (mile)';


% Filter out rows where "SS_HWS" is below 3
filteredData = data(data.SS_HWS >= 3, :);

% Further filter rows where "States_Affected" contains "TX"
filteredData = filteredData(contains(filteredData.States_Affected, 'TX'), :);
data = filteredData;
end