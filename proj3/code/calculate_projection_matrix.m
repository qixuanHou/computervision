% Projection Matrix Stencil Code
% CS 4476 / 6476: Computer Vision, Georgia Tech
% Written by Henry Hu, Grady Williams, James Hays

% Returns the projection matrix for a given set of corresponding 2D and
% 3D points. 

% 'Points_2D' is nx2 matrix of 2D coordinate of points on the image
% 'Points_3D' is nx3 matrix of 3D coordinate of points in the world

% 'M' is the 3x4 projection matrix


function M = calculate_projection_matrix( Points_2D, Points_3D )

% To solve for the projection matrix. You need to set up a system of
% equations using the corresponding 2D and 3D points:

%                                                        [M11       [ 0
%                                                         M12         0
%                                                         M13         .
%                                                         M14         .
%[ X1 Y1 Z1 1 0  0  0  0 -u1*X1 -u1*Y1 -u1*Z1 -u1         M21         .
%  0  0  0  0 X1 Y1 Z1 1 -v1*X1 -v1*Y1 -v1*Z1 -v1         M22         .
%  .  .  .  . .  .  .  .    .     .      .          *     M23   =     .
%  Xn Yn Zn 1 0  0  0  0 -un*Xn -un*Yn -un*Zn -un         M24         .
%  0  0  0  0 Xn Yn Zn 1 -vn*Xn -vn*Yn -vn*Zn -vn]        M31         .
%                                                         M32         0
%                                                         M33         0 ]

% Then you can solve this using least squares with the '\' operator or SVD.
% Notice you obtain 2 equations for each corresponding 2D and 3D point
% pair. To solve this, you need at least 6 point pairs.

%%%%%%%%%%%%%%%%
% Your code here
%%%%%%%%%%%%%%%%
% get size of the 2D matrix
[row, ~] = size(Points_2D);

% create zero matrix P and Q to hold values 
A = zeros(row * 2, 12);

% have P and Q ready 
for i = 1 : row
    % [ X1 Y1 Z1 1 0  0  0  0 -u1*X1 -u1*Y1 -u1*Z1]
    A(2*i - 1, 1 : 3) = Points_3D(i, :);
    A(2*i - 1, 4) = 1;
    A(2*i - 1, 9 : 11) = -Points_3D(i, :) .* Points_2D(i, 1);
    A(2*i - 1, 12) = -Points_2D(i, 1);
    % [0  0  0  0 X1 Y1 Z1 1 -v1*X1 -v1*Y1 -v1*Z1]
    A(2*i, 5 : 7) = Points_3D(i, :);
    A(2*i, 8) = 1;
    A(2*i, 9 : 11) = -Points_3D(i, :) * Points_2D(i, 2);
    A(2*i, 12) = -Points_2D(i, 2);

end

[U, S, V] = svd(A); 
M = V(:,end);
M = reshape(M,[],3)';
end

