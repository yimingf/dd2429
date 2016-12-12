% H = compute_rectification_matrix(points1, points2)
%
% Method: Determines the mapping H * points1 = points2
% 
% Input: points1, points2 of the form (4,n) 
%        n has to be at least 5
%
% Output:  H (4,4) matrix 
% 

function H = compute_rectification_matrix( p1, p2 )

%------------------------------
% TODO: FILL IN THIS PART

N = length(p1);

for i = 1:N
    W(i*3 : i*3+2, :) = [p1(:, i)' zeros(1, 8) ...
        -p1(1, i)*p2(1, i) -p1(2, i)*p2(1, i) -p1(3, i)*p2(1, i) -p1(4, i)*p2(1, i); ...
        zeros(1, 4) p1(:, i)' zeros(1, 4) ...
        -p1(1, i)*p2(2, i) -p1(2, i)*p2(2, i) -p1(3, i)*p2(2, i) -p1(4, i)*p2(2, i); ...
        zeros(1, 8) p1(:, i)' ...
        -p1(1, i)*p2(3, i) -p1(2, i)*p2(3, i) -p1(3, i)*p2(3, i) -p1(4, i)*p2(3, i)];
end

[~, ~, V] = svd(W);
H = reshape(V(:,end), 4, 4)';
