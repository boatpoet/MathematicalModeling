function randomVector = trirnd(minVal, topVal, maxVal, varargin);
%TRIRND generates discrete random numbers from a triangular distribution.
%   randomValue = TRIRND(minVal, topVal, maxVal);
%       The distribution is defined by:
%           - a minimum and a maximum value
%           - a "top" value, with the highest probability
%       The distribution is defined with zero probability at minVal-1 and 
%       maxVal+1, and with highest probability at topVal. Hence
%       every value in the range (including the maximum and minimum values)
%       have a non-zero probability to be included, whatever topValue is.
%       The output is a random integer.
%   randomMatrix = TRIRND(minVal, topVal, maxVal, nrow, ncolumns)
%       returns a (nrow x ncolumns) matrix of random integers.
%
% Written by L.Cavin, 01.08.2003, (c) CSE & ETHZ
% This code is free to use and modify for non-commercial purposes.
%
% NOTES:
% * This is a numeric approximation, so use with care in "serious"
%   statistical applications!
% * Two different algorithms are implemented. One is efficient for large
%   number of random points within a small range (maxVal-minVal), while the
%   other is efficient for large range for reasonable number of points. For
%   large ranges, there is a O(n^2) relation with regard to the product of 
%   range*number_of_points. When this product reach about a billion, the
%   runtime reach several minutes.
% * To inspect the resulting distribution, plot a histogram of the
%   resulting random numbers, e.g. "hist(trirnd(1,87,100,10000,1),100)".

% Version History:
% ----------------
% Version 2.0 - 20.10.2004 -- added alternate algorithm for large ranges.
% Version 1.5 - 14.02.2003 -- made similar to Matlab functions (nargin order
%                             and checks).
% Version 1.0 - 01.08.2003 -- initial release.

% check arguments...
if nargin < 3
    error('Requires at least three input arguments.'); 
end
nrows = 1;
ncols = 1;
if nargin > 3
    if nargin > 4
        nrows = varargin{1};
        ncols = varargin{2};
    else
        error('Size information is inconsistent.');
    end
end
if topVal > maxVal || topVal < minVal || minVal > maxVal
    randomVector = ones(nrows, ncols).*NaN;
    return;
end

% go for the randomization
mxprob = maxVal-minVal+1;
if mxprob < 51 || (mxprob < 101 && nrows*ncols > 500) || (mxprob < 501 && nrows*ncols > 8000) || (mxprob < 1001 && nrows*ncols > 110000)
	vector = ones(1,mxprob).*topVal;
	j = (topVal-minVal+1);
	slope = 1/j;
	j = j -1;
	for i = (topVal-1):-1:minVal
        vector = [vector ones(1,floor(mxprob*slope*j)).*i];
        j = j - 1;
	end
	j = (maxVal+1-topVal);
	slope = 1/j;
	j = j -1;
	for i = (topVal+1):maxVal
        vector = [vector ones(1,floor(mxprob*slope*j)).*i];
        j = j - 1;
	end
	randomVector = vector(unidrnd(size(vector,2),nrows*ncols,1));
else
	probs = mxprob:-1*mxprob/(topVal-minVal+1):1;
	probs = [probs(end:-1:2) mxprob:-1*mxprob/(maxVal-topVal+1):1];
	probs = cumsum(probs./sum(probs));
	if nrows*ncols*mxprob > 1000000
        % dealing with large quantities of data, hard on memory
        randomVector = [];
        i = 1;
        while nrows*ncols*mxprob/i > 1000000
            i = i * 10;
        end
        probs = repmat(probs, ceil(nrows*ncols/i), 1);
        for j = 1:i
            rnd = repmat(unifrnd(0, 1, ceil(nrows*ncols/i), 1), 1, mxprob);
            randomVector = [randomVector sum(probs < rnd, 2)+1];
		end
        randomVector = randomVector(1:nrows*ncols);
	else
        probs = repmat(probs, nrows*ncols, 1);
        rnd = repmat(unifrnd(0, 1, nrows*ncols, 1), 1, mxprob);
        randomVector = sum(probs < rnd, 2)+1;
	end
end
% generate desired matrix:
randomVector = reshape(randomVector, nrows, ncols);