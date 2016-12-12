% function E = compute_E_matrix( points1, points2, K1, K2 );
%
% Method:   Calculate the E matrix between two views from
%           point correspondences: points2^T * E * points1 = 0
%           we use the normalize 8-point algorithm and 
%           enforce the constraint that the three singular 
%           values are: a,a,0. The data will be normalized here. 
%           Finally we will check how good the epipolar constraints:
%           points2^T * E * points1 = 0 are fullfilled.
% 
%           Requires that the number of cameras is C=2.
% 
% Input:    points2d is a 3xNxC array storing the image points.
%
%           K is a 3x3xC array storing the internal calibration matrix for
%           each camera.
%
% Output:   E is a 3x3 matrix with the singular values (a,a,0).

function E = compute_E_matrix( points2d, K )
%------------------------------
% TODO: FILL IN THIS PART

pa = inv(K(:, :, 1)) * points2d(:, :, 1);
pb = inv(K(:, :, 2)) * points2d(:, :, 2);
[norm_a] = compute_normalization_matrices(pa);
pa = norm_a * pa;
[norm_b] = compute_normalization_matrices(pb);
pb = norm_b * pb;
[~, N] = size(pa);

Q = [pb(1, :) .* pa(1, :); pb(1, :) .* pa(2, :); pb(1, :); ...
     pb(2, :) .* pa(1, :); pb(2, :) .* pa(2, :); pb(2, :); ...
     pa(1, :); pa(2, :); ones(1, N)]';

[~, ~, V] = svd(Q);
E = norm_b' * reshape(V(:, end), [3, 3])' * norm_a;

[U, S, V] = svd(E);
s_correct = 0.5 * (S(1,1) + S(2,2));
E = U * [s_correct 0 0; 0 s_correct 0; 0 0 0] * V'; 