% function [cams, cam_centers] = reconstruct_stereo_cameras(E, K1, K2, data); 
%
% Method:   Calculate the first and second camera matrix. 
%           The second camera matrix is unique up to scale. 
%           The essential matrix and 
%           the internal camera matrices are known. Furthermore one 
%           point is needed in order solve the ambiguity in the 
%           second camera matrix.
%
%           Requires that the number of cameras is C=2.
%
% Input:    E is a 3x3 essential matrix with the singular values (a,a,0).
%
%           K is a 3x3xC array storing the internal calibration matrix for
%           each camera.
%
%           points2d is a 3xC matrix, storing an image point for each camera.
%
% Output:   cams is a 3x4x2 array, where cams(:,:,1) is the first and 
%           cams(:,:,2) is the second camera matrix.
%
%           cam_centers is a 4x2 array, where (:,1) is the first and (:,2) 
%           the second camera center.
%

function [cams, cam_centers] = reconstruct_stereo_cameras( E, K, points2d )

%------------------------------
% TODO: FILL IN THIS PART

[U, ~, V] = svd(E);
t = V(:, end);
cam_centers = zeros(4, 2);
cam_centers(:, 1) = [0 0 0 1]';
cam_centers(:, 2) = [-t; 1];

W = [0 -1 0; 1 0 0; 0 0 1];
R_1 = U * W * V';
R_2 = U * W' * V';
if (det(R_1) == -1) R_1 = R_1 * -1; end
if (det(R_2) == -1) R_2 = R_2 * -1; end

cams = zeros(3, 4, 2);
cam_b_candidate = zeros(3, 4, 4);
cams(:, :, 1) = K(:, :, 1) * [eye(3) zeros(3, 1)];
cam_b_candidate(:, :, 1) = K(:, :, 2) * R_1 * [eye(3) t];
cam_b_candidate(:, :, 2) = K(:, :, 2) * R_1 * [eye(3) -t];
cam_b_candidate(:, :, 3) = K(:, :, 2) * R_2 * [eye(3) t];
cam_b_candidate(:, :, 4) = K(:, :, 2) * R_2 * [eye(3) -t];

points = zeros(4, 4);
foo = zeros(3, 4, 2); % a three-dimensional matrix for reconstructing 3d points
foo(:, :, 1) = cams(:, :, 1);
for i = 1 : 4
    foo(:, :, 2) = cam_b_candidate(:, :, i);
    bar = reconstruct_point_cloud( foo, points2d(:, 1, :) );
    bar(:, 1) = bar(:, 1) ./ bar(4, 1);
    points(:, i) = bar(:, 1);
end

foo = zeros(3, 4);
foo(:, 1) = R_1 * [eye(3) t] * points(:, 1);
foo(:, 2) = R_1 * [eye(3) -t] * points(:, 2);
foo(:, 3) = R_2 * [eye(3) t] * points(:, 3);
foo(:, 4) = R_2 * [eye(3) -t] * points(:, 4);

for i = 1 : 4
    if (sign(foo(3, i)) == sign(points(3, i)))
        cams(:, :, 2) = cam_b_candidate(:, :, i);
        break
    end
end