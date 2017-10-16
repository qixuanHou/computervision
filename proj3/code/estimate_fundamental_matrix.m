% Fundamental Matrix Stencil Code
% CS 4476 / 6476: Computer Vision, Georgia Tech
% Written by Henry Hu

% Returns the camera center matrix for a given projection matrix

% 'Points_a' is nx2 matrix of 2D coordinate of points on Image A
% 'Points_b' is nx2 matrix of 2D coordinate of points on Image B
% 'F_matrix' is 3x3 fundamental matrix

% Try to implement this function as efficiently as possible. It will be
% called repeatly for part III of the project

function [ F_matrix ] = estimate_fundamental_matrix(Points_a,Points_b)

%%%%%%%%%%%%%%%%
% Your code here
%%%%%%%%%%%%%%%%

u1=Points_b(:,1);
v1=Points_b(:,2);
u2=Points_a(:,1);
v2=Points_a(:,2);

L=size(u1, 1);

% 8point algorithm
l1=ones(L,1);


% % normalization (extra credits)
% [u2, v2, pA] = Normal_Process(u2, v2, Points_a);
% [u1, v1, pB] = Normal_Process(u1, v1, Points_b);

% construct A matrix
A=[u1.*u2, u1.*v2, u1, v1.*u2, v1.*v2, v1, u2, v2, l1];

% solve Af = 0 using SVD
[U,S,V]=svd(A);
f=V(:,end);
F_matrix = reshape(f,[3 3])';

% % normalization (extra credits)
% F_matrix = pB'*F_matrix*pA;

end

function [ u, v, Ta ] = Normal_Process(u,v,Points_a)
    % Get Average
    avgu=sum(u)/size(Points_a,1);
    avgv=sum(v)/size(Points_a,1);
    % Substract Average
    d=((u-avgu).^2+(v-avgv).^2).^(1/2);
    % Estimate Standard Deviation
    s=std(d);
    % Normalization through Linear Transformations
    Ta=diag([1/s,1/s,1])*[1, 0, -avgu; 0, 1, -avgv; 0, 0, 1];
    PriA=Ta*([Points_a,ones(size(Points_a,1),1)]');
    u=PriA(1,:)';
    v=PriA(2,:)';
end
