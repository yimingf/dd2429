% function [error_average, error_max] = check_reprojection_error(data, cam, model)
%
% Method:   Evaluates average and maximum error 
%           between the reprojected image points (cam*model) and the 
%           given image points (data), i.e. data = cam * model 
%
%           We define the error as the Euclidean distance in 2D.
%
%           Requires that the number of cameras is C=2.
%           Let N be the number of points.
%
% Input:    points2d is a 3xNxC array, storing all image points.
%
%           cameras is a 3x4xC array, where cams(:,:,1) is the first and 
%           cameras(:,:,2) is the second camera matrix.
%
%           point3d 4xN matrix of all 3d points.
%       
% Output:   
%           The average error (error_average) and maximum error (error_max)
%      

function [error_average, error_max] = check_reprojection_error( points2d, cameras, points3d )

%------------------------------
% TODO: FILL IN THIS 

[~, N, ~] = size(points2d);
points_rep = zeros(2, N*2);
points_rep(:, 1:N) = homogeneous_to_cartesian(cameras(:, :, 1) * points3d);
points_rep(:, N+1:2*N) = homogeneous_to_cartesian(cameras(:, :, 2) * points3d);
diff = points_rep - reshape(points2d(1:2, :, :), [2 N*2]);
diff = diag(sqrt(diff' * diff));
error_average = mean(diff);
error_max = max(diff);