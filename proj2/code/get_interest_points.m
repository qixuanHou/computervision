% Local Feature Stencil Code
% CS 4476 / 6476: Computer Vision, Georgia Tech
% Written by James Hays

% Returns a set of interest points for the input image

% 'image' can be grayscale or color, your choice.
% 'feature_width', in pixels, is the local feature width. It might be
%   useful in this function in order to (a) suppress boundary interest
%   points (where a feature wouldn't fit entirely in the image, anyway)
%   or (b) scale the image filters being used. Or you can ignore it.

% 'x' and 'y' are nx1 vectors of x and y coordinates of interest points.
% 'confidence' is an nx1 vector indicating the strength of the interest
%   point. You might use this later or not.
% 'scale' and 'orientation' are nx1 vectors indicating the scale and
%   orientation of each interest point. These are OPTIONAL. By default you
%   do not need to make scale and orientation invariant local features.
function [x, y, confidence, scale, orientation] = get_interest_points(image, feature_width)

% Implement the Harris corner detector (See Szeliski 4.1.1) to start with.
% You can create additional interest point detector functions (e.g. MSER)
% for extra credit.

% If you're finding spurious interest point detections near the boundaries,
% it is safe to simply suppress the gradients / corners near the edges of
% the image.

% The lecture slides and textbook are a bit vague on how to do the
% non-maximum suppression once you've thresholded the cornerness score.
% You are free to experiment. Here are some helpful functions:
%  BWLABEL and the newer BWCONNCOMP will find connected components in 
% thresholded binary image. You could, for instance, take the maximum value
% within each component.
%  COLFILT can be used to run a max() operator on each sliding window. You
% could use this to ensure that every interest point is at a local maximum
% of cornerness.

row = size(image, 1);
column = size(image, 2);
image = double(image);

% 1. Compute the horizontal and vertical derivatives of the image Ix and Iy 
% by convolving the original image with derivatives of Gaussians (Section 3.2.3).


[imagex, imagey] = imgradientxy(image); 

% 2. Compute the three images corresponding to the outer products of these gradients. (The matrix A is symmetric, so only three entries are needed.)
imagex2 = imagex .^2;
imagey2 = imagey .^2;
imagexy2 = imagex .* imagey;

% 3. Convolve each of these images with a larger Gaussian.
% large = fspecial('Gaussian', [25 25]);
large = fspecial('Gaussian', [100 100]);

imagexf = imfilter(imagex2, large);
imageyf = imfilter(imagey2, large);
imagexyf = imfilter(imagexy2, large);


Rs = zeros(row, column);
k = 0.04;
% 4. Compute a scalar interest measure using one of the formulas discussed above.
for i=1:row
   for j=1:column
       H = [imagexf(i, j) imagexyf(i, j); imagexyf(i, j) imageyf(i, j)];
       R = det(H) - k * (trace(H) ^ 2);
       Rs(i, j) = R;
   end
end

% 5. Find local maxima above a certain threshold and report them as detected feature point locations.

matr = imregionalmax(Rs, 4);
[value, I] = sort(Rs(matr), 'descend');
nRs = matr .* Rs;
threshold = value(5000);
[x, y] = find(nRs > threshold);

confidence = zeros(size(y));

for index = 1:size(y,1)
    r = x(index);
    c = y(index);
    confidence(index) = Rs(r,c);
end

scale = 0;
orientation = 0;
end
