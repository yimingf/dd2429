% H = compute_homography(points1, points2)
%
% Method: Determines the mapping H * points1 = points2
% 
% Input:  points1, points2 are of the form (3,n) with 
%         n is the number of points.
%         The points should be normalized for 
%         better performance.
% 
% Output: H 3x3 matrix 
%

function H = compute_homography( points1, points2 )

%-------------------------
% TODO: FILL IN THIS PART

foo = ~isnan(points2(1,:));
points1 = points1(:, foo);
points2 = points2(:, foo);

[size_h, N] = size(points2);
H = zeros(size_h);

alpha = zeros(9, N);
beta = zeros(9, N);

for i = 1:N
    alpha(:, i) = [points2(1, i), points2(2, i), 1, 0, 0, 0, ...
        -points1(1, i) * points2(1, i), -points2(2, i) * points1(1, i), -points1(1, i)];
    beta(:, i) = [0, 0, 0, points2(1, i), points2(2, i), 1, ...
        -points2(1, i) * points1(2, i), -points1(2, i) * points2(2, i), -points1(2, i)];
end

Q = [alpha, beta]';
[U, S, V] = svd(Q);
H = reshape(V(:, end), [3, 3])';
%[V, D] = eig(Q * Q');
%V(:, find(min(eig(D))));
%H = reshape(V(:, find(min(eig(D)))), [3, 3])';
