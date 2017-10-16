% RANSAC Stencil Code
% CS 4476 / 6476: Computer Vision, Georgia Tech
% Written by Henry Hu

% Find the best fundamental matrix using RANSAC on potentially matching
% points

% 'matches_a' and 'matches_b' are the Nx2 coordinates of the possibly
% matching points from pic_a and pic_b. Each row is a correspondence (e.g.
% row 42 of matches_a is a point that corresponds to row 42 of matches_b.

% 'Best_Fmatrix' is the 3x3 fundamental matrix
% 'inliers_a' and 'inliers_b' are the Mx2 corresponding points (some subset
% of 'matches_a' and 'matches_b') that are inliers with respect to
% Best_Fmatrix.

% For this section, use RANSAC to find the best fundamental matrix by
% randomly sample interest points. You would reuse
% estimate_fundamental_matrix() from part 2 of this assignment.

% If you are trying to produce an uncluttered visualization of epipolar
% lines, you may want to return no more than 30 points for either left or
% right images.

function [ Best_Fmatrix, inliers_a, inliers_b] = ransac_fundamental_matrix(matches_a, matches_b)


%%%%%%%%%%%%%%%%
% Your code here
%%%%%%%%%%%%%%%%
% Your ransac loop should contain a call to 'estimate_fundamental_matrix()'
% that you wrote for part II.

L=size(matches_a,1);
sample =8;
best=0;
itera = 6000;
threshold=0.05;

for K=1:1:itera
    % step 1 - find samples and calculate fundamental matrix
    c=randperm(L);
    rnums = c(1:sample);
    Fmatrix = estimate_fundamental_matrix(matches_a(rnums,:),matches_b(rnums,:));
    % step 2 - calculate the score and decide inliers 
    inliers= [];
    d = zeros(L);
    for j=1:1:L
        ma=[matches_a(j,:) 1];
        mb=[matches_b(j,:) 1];
        d(j)=sum(abs(mb*Fmatrix*ma').^2)^(1/2);
        if d(j)<=threshold
            inliers = cat(1, inliers, j);
        end
    end
    % step 3 - if inliers reach max, record the results
    if length(inliers)>best
        best=length(inliers);
        Best_Fmatrix=Fmatrix;
        inliers_a=matches_a(inliers,:);
        inliers_b=matches_b(inliers,:);
    end
end
disp(best);


end

