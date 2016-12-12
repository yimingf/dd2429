% function F = compute_F_matrix(points1, points2);
%
% Method:   Calculate the F matrix between two views from
%           point correspondences: points2^T * F * points1 = 0
%           We use the normalize 8-point algorithm and 
%           enforce the constraint that the three singular 
%           values are: a,b,0. The data will be normalized here. 
%           Finally we will check how good the epipolar constraints:
%           points2^T * F * points1 = 0 are fullfilled.
% 
%           Requires that the number of cameras is C=2.
% 
% Input:    points2d is a 3xNxC array storing the image points.
%
% Output:   F is a 3x3 matrix where the last singular value is zero.

function F = compute_F_matrix( points2d )


%------------------------------
% TODO: FILL IN THIS PART
p1=points2d(:,:,1);
p2=points2d(:,:,2);
Nc =compute_normalization_matrices(points2d);
[m,n]=size(points2d(:,:,1));
p1=zeros(m,n);
p2=zeros(m,n);
for i=1:n
p1(:,i)=Nc(:,:,1)*points2d(:,i,1);
p2(:,i)=Nc(:,:,2)*points2d(:,i,2);
end
j=1;
N1=~isnan(p1);
N2=~isnan(p2);
for i=1:n
    if (N1(:,i)==ones(3,1))&(N2(:,i)==ones(3,1))
    A(j,:)=[p1(1,i)*p2(1,i),p1(1,i)*p2(2,i),p1(1,i),p1(2,i)*p2(1,i),p1(2,i)*p2(2,i),p1(2,i),p2(1,i),p2(2,i),1];
    j=j+1;
    end
end
[U,S,V]=svd(A);
E_vec=V(:,end);
F=reshape(E_vec,3,3);
E_temp=Nc(:,:,2)'*F*Nc(:,:,1);
[Ud,Sd,Vd]=svd(E_temp);
F=Ud*[Sd(1,1) 0 0;0 Sd(2,2) 0;0 0 0]*Vd';
%for i=1:n
%tol_E(i)=p2(:,i)'*F*p1(:,i);
%end
end

