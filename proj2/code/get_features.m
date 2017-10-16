% Local Feature Stencil Code
% CS 4476 / 6476: Computer Vision, Georgia Tech
% Written by James Hays

% Returns a set of feature descriptors for a given set of interest points. 

% 'image' can be grayscale or color, your choice.
% 'x' and 'y' are nx1 vectors of x and y coordinates of interest points.
%   The local features should be centered at x and y.
% 'feature_width', in pixels, is the local feature width. You can assume
%   that feature_width will be a multiple of 4 (i.e. every cell of your
%   local SIFT-like feature will have an integer width and height).
% If you want to detect and describe features at multiple scales or
% particular orientations you can add input arguments.

% 'features' is the array of computed features. It should have the
%   following size: [length(x) x feature dimensionality] (e.g. 128 for
%   standard SIFT)


function [features] = get_features(image, x, y, feature_width)

% To start with, you might want to simply use normalized patches as your
% local feature. This is very simple to code and works OK. However, to get
% full credit you will need to implement the more effective SIFT descriptor
% (See Szeliski 4.1.2 or the original publications at
% http://www.cs.ubc.ca/~lowe/keypoints/)

% Your implementation does not need to exactly match the SIFT reference.
% Here are the key properties your (baseline) descriptor should have:
%  (1) a 4x4 grid of cells, each feature_width/4. 'cell' in this context
%    nothing to do with the Matlab data structue of cell(). It is simply
%    the terminology used in the feature literature to describe the spatial
%    bins where gradient distributions will be described.
%  (2) each cell should have a histogram of the local distribution of
%    gradients in 8 orientations. Appending these histograms together will
%    give you 4x4 x 8 = 128 dimensions.
%  (3) Each feature vector should be normalized to unit length
%
% You do not need to perform the interpolation in which each gradient
% measurement contributes to multiple orientation bins in multiple cells
% As described in Szeliski, a single gradient measurement creates a
% weighted contribution to the 4 nearest cells and the 2 nearest
% orientation bins within each cell, for 8 total contributions. This type
% of interpolation probably will help, though.

% You do not have to explicitly compute the gradient orientation at each
% pixel (although you are free to do so). You can instead filter with
% oriented filters (e.g. a filter that responds to edges with a specific
% orientation). All of your SIFT-like feature can be constructed entirely
% from filtering fairly quickly in this way.

% You do not need to do the normalize -> threshold -> normalize again
% operation as detailed in Szeliski and the SIFT paper. It can help, though.

% Another simple trick which can help is to raise each element of the final
% feature vector to some power that is less than one.
z = x;
x = y;
y = z;

features = zeros(size(x, 1), 128);
image = double(image);

for index = 1:size(x,1)
    x(index) = round(x(index));
    y(index) = round(y(index));
end 
row = size(image, 1);
column = size(image, 2);

[mag, dir] = imgradient(image);


for index = 1:size(x, 1)
    des = zeros(4 * 4 * 8, 1);
    
    if feature_width/2 + x(index) < row + 1
        if x(index) - feature_width/2 > 0 
            if y(index) - feature_width/2 > 0 
                if y(index) + feature_width/2 < column + 1

                        counter = 0;
                        for qx = -2 : 1
                            for qy = -2 : 1
                                counter = counter + 1;
                                one  = x(index) + qx * feature_width/4;
                                two = y(index) + qy * feature_width/4;
               
                                aDes = hist(dir, one, two, feature_width/4);
                                des(counter * 8 - 7:counter * 8) = aDes;
                            end
                        end
                end
                
            end
        end
    end

    features(index, :) = des;
end
end

function [aDes] = hist(dir, i, j, s)
aDes = zeros(8,1);
for ti = i:s + i - 1
    for tj = j:s + j - 1

        if dir(ti, tj) >= 0 && dir(ti, tj) < 45
            aDes(1) = aDes(1) + 1;
        elseif dir(ti, tj) >= 45 && dir(ti, tj) < 90
            aDes(2) = aDes(2) + 1;
        elseif dir(ti, tj) >= 90 && dir(ti, tj) < 135
            aDes(3) = aDes(3) + 1;
        elseif dir(ti, tj) >= 135 && dir(ti, tj) <= 180
            aDes(4) = aDes(4) + 1;
        elseif dir(ti, tj) < 0 && dir(ti, tj) >= -45
            aDes(5) = aDes(5) + 1;
        elseif dir(ti, tj) < -45 && dir(ti, tj) >= -90
            aDes(6) = aDes(6) + 1;
        elseif dir(ti, tj) < -90 && dir(ti, tj) >= -135
            aDes(7) = aDes(7) + 1;
        elseif dir(ti, tj) < -135 && dir(ti, tj) >= -180
            aDes(8) = aDes(8) + 1;
        end
    end
end
aDes = aDes./norm(aDes);

end
