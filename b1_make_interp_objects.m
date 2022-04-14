%% main_interp_example
% eeshan bhatt
% ebhatt@whoi.edu
% 4/14/22
% example code for using griddedInterpolant

%% prep workspace
clear; clc; close all;

%% load data file
load('WOA18_Full_Sat_Table_m6_simplified.mat')
data.lon = Full_sat_table_m6.Longitude_degreesE;
data.lat = Full_sat_table_m6.Latitude_degreesN;
data.depth = Full_sat_table_m6.Depth_m;
data.barium = Full_sat_table_m6.Ba_nmolkg_6;
clear Full_sat_table_m6;

%% just treat this data as "scattered" -- not optimal
tScatter = tic;
Fscatter = scatteredInterpolant(data.lon,data.lat,data.depth,data.barium);
fprintf('Total elapsed time to make the scatteredInterpolant is %3.2f seconds \n',toc(tScatter));

%% transform column vectors into gridded data
tGridded = tic;
% make unique vectors
unq.lon = unique(data.lon);
unq.lat = unique(data.lat);
unq.depth = unique(data.depth);

% make gridded vectors
[grid.lon,grid.lat,grid.depth] = ndgrid(unq.lon,unq.lat,unq.depth);

% initialize blank barium array
grid.barium = NaN(size(grid.lon));

for k = 1:numel(data.barium)
    
    % find where the kth datapoint exists in our grid
    indLon = data.lon(k) == unq.lon;
    indLat = data.lat(k) == unq.lat;
    indDepth = data.depth(k) == unq.depth;
    
    % fill in barium grid accordingly
   grid.barium(indLon,indLat,indDepth) = data.barium(k);
   
end

% now use gridded interpolant -- much more efficient!
Fgridded = griddedInterpolant(grid.lon,grid.lat,grid.depth,grid.barium);
fprintf('Total elapsed time to make the griddedInterpolant is %3.2f seconds \n',toc(tGridded));

%% clearvars
clearvars -except data Fgridded Fscatter

% check file size
disp('Check out the file sizes!');
whos;

save interp_objects_output