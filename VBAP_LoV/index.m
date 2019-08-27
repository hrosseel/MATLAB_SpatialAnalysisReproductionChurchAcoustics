% Author: hrosseel
% Requires VBAP toolbox
clc;
clear;

%% Load the cartesian coordinates of the loudspeaker array.
load('loudspeakers_cart_human.mat');
[azimuth, elevation, radius] = cart2sph(loudspeakers_cart(:,1), loudspeakers_cart(:,2), loudspeakers_cart(:,3));
clear loudspeakers_cart;

%% Calculate the triangulation and plot it.

ls_dirs = [rad2deg(azimuth) rad2deg(elevation)];
[ls_groups, layout] = findLsTriplets(ls_dirs, 1, 100); % Max aperature : 100 degrees

% Calculate the inverse matrices for loudspeaker triplets in every panning direction

inverseMatrix = invertLsMtx(ls_dirs, ls_groups);

% Calculate the 3D gains for every direction
azi_res = 2;
ele_res = 5;
[elev, azi] = meshgrid(-90:ele_res:90, 0:azi_res:360);
src_dirs3D = [azi(:) elev(:)];
gains3D = vbap(src_dirs3D, ls_groups, inverseMatrix);

%% Plot everything

% Triangulation
figure;
subplot(121);
plotTriangulation(layout);
title('VBAP - Triangulation on loudspeaker locations');

% Panning gains
[nAzi, nElev] = size(azi);
[X,Y,Z] = sph2cart(deg2rad(azi), deg2rad(elev), 1);
subplot(122);
for nl = 1: size(ls_dirs,1)
    gains_grid_nl = reshape(gains3D(:,nl), nAzi, nElev);
    surf(gains_grid_nl .* X, gains_grid_nl .* Y, gains_grid_nl .* Z, gains_grid_nl);
end
