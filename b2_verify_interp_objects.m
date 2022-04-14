%% main_interp_example
% eeshan bhatt
% ebhatt@whoi.edu
% 4/14/22
% example code for using griddedInterpolant

%% prep workspace
clear; clc; close all;
load interp_objects_output.mat

%% let's test a random (known) point
k1 = 2022; % <--- set index here!
fprintf('     raw: %3.5f \n scatter: %3.5f \n gridded: %3.5f \n', data.barium(k1),...
    Fscatter(data.lon(k1),data.lat(k1),data.depth(k1)),...
    Fgridded(data.lon(k1),data.lat(k1),data.depth(k1)));

%% let's make a profile using that known point

% set up parameters
k2.depth = [0:5:500];
k2.lon = repmat(data.lon(k1),size(k2.depth));
k2.lat = repmat(data.lat(k1),size(k2.depth));

% interpolate
Vq2 = Fgridded(k2.lon,k2.lat,k2.depth);

% figure
figure(1);
plot(Vq2,k2.depth)
xlabel('interpolated barium')
ylabel('depth [m]');
set(gca,'ydir','reverse');

%% let's make a contour plot at 100 m in depth for an arbitrary lat/lon grid

k3.x = [-60:20]; %degrees
k3.y = [-10:70]; %degrees
k3.z = [100]; %meters

[k3.lon,k3.lat,k3.depth] = ndgrid(k3.x,k3.y,k3.z);
Vq3 = Fgridded(k3.lon,k3.lat,k3.depth);

% set up figure w/ diff options (learning moment!)
figure('renderer','painters','position',[0 0 1200 1200]);
tiledlayout(2,2);

% warning
% pcolor does not show the last row and column of the matrix

nexttile();
imagesc(k3.x,k3.y,Vq3');
title('imagesc')
axis xy;

nexttile();
contourf(k3.lon,k3.lat,Vq3,20);
title('contourf');

nexttile();
imagesc(k3.x,k3.y,Vq3','AlphaData',~isnan(Vq3'));
title('imagesc with some options')
set(gca,'color',[0 0 0 0.8]);
axis xy
shading interp

nexttile();
h = pcolor(k3.lon,k3.lat,Vq3);
shading interp
title('pcolor');