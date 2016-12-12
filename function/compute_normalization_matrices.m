% Method:   compute all normalization matrices.  
%           It is: point_norm = norm_matrix * point. The norm_points 
%           have centroid 0 and average distance = sqrt(2))
% 
%           Let N be the number of points and C the number of cameras.
%
% Input:    points2d is a 3xNxC array. Stores un-normalized homogeneous
%           coordinates for points in 2D. The data may have NaN values.
%        
% Output:   norm_mat is a 3x3xC array. Stores the normalization matrices
%           for all cameras, i.e. norm_mat(:,:,c) is the normalization
%           matrix for camera c.

function norm_mat = compute_normalization_matrices( points2d )

%-------------------------
% TODO: FILL IN THIS PART

[size_n, ~, size_c] = size(points2d);
norm_mat = zeros(size_n, size_n, size_c);

for i = 1:size_c
    p = points2d(:, :, i);
    p = p(:, ~isnan(p(1,:)));
    [~, N] = size(p);
    x = mean(p(1, :));
    y = mean(p(2, :));
    pc = [x y 1]';
    foo = bsxfun(@minus, p, pc);
    d = sum(diag(sqrt(foo' * foo))) / N;

    norm_mat(:, :, i) = (sqrt(2) / d) * ...
        [1 0 -x; 0 1 -y; 0 0 (d / sqrt(2))];
end