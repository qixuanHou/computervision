% Local Feature Stencil Code
% CS 4476 / 6476: Computer Vision, Georgia Tech
% Written by James Hays

% 'features1' and 'features2' are the n x feature dimensionality features
%   from the two images.
% If you want to include geometric verification in this stage, you can add
% the x and y locations of the interest points as additional features.
%
% 'matches' is a k x 2 matrix, where k is the number of matches. The first
%   column is an index in features1, the second column is an index
%   in features2. 
% 'Confidences' is a k x 1 matrix with a real valued confidence for every
%   match.
% 'matches' and 'confidences' can empty, e.g. 0x2 and 0x1.
function [matches, confidences] = match_features(features1, features2)

% This function does not need to be symmetric (e.g. it can produce
% different numbers of matches depending on the order of the arguments).

% To start with, simply implement the "ratio test", equation 4.18 in
% section 4.1.3 of Szeliski. For extra credit you can implement various
% forms of spatial verification of matches.

% Placeholder that you can delete. Random matches and confidences


num_features = min(size(features1, 1), size(features2,1));
if num_features == size(features1, 1)
    features = features1;
    matFeatures = features2;
else
    features = features2;
    matFeatures = features1;
end

matches = zeros(num_features, 2);
confidences = zeros(num_features,1);


for f = 1:size(features,1)
    matList = zeros(size(matFeatures, 1), 1);
    for mt = 1:size(matFeatures, 1)
        fea = features(f, :);
        matF = matFeatures(mt, :);
        matList(mt) = sqrt(sum((fea-matF).^2));
    end
    [a, index] = min(matList);
    matList(index) = inf;
    [b, no] = min(matList);
    confidences(f) = a/b;
    matches(f, 1) = f;
    matches(f, 2) = index;
end



% Sort the matches so that the most confident onces are at the top of the
% list. You should probably not delete this, so that the evaluation
% functions can be run on the top matches easily.
[confidences, ind] = sort(confidences, 'ascend');
matches = matches(ind,:);

confidences = confidences(1:100);
matches = matches(1:100, :);
end