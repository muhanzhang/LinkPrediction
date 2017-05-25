function [train_pos, train_neg, test_pos, test_neg] = sample_neg(train, test, k)
%  Usage: to sample negative links for train and test datasets
%  --Input--
%  -train: half train positive adjacency matrix
%  -test: half test positive adjacency matrix
%  -k: how many times of negative links (w.r.t. pos links) to 
%      sample
%  --Output--
%  column indices for four datasets
%%
if nargin < 3
    k = 1;
end
    
n = size(train, 1);
[i, j] = find(train);
train_pos = [i, j];
train_size = length(i);
[i, j] = find(test);
test_pos = [i, j];
test_size = length(i);

if isempty(test)
    net = train;
else
    net = train + test;
end
assert(max(max(net)) == 1);  % ensure train, test not overlap
neg_net = triu(-(net - 1), 1);
[i, j] = find(neg_net);
neg_links = [i, j];

% sample negative links
nlinks = size(neg_links, 1);
ind = randperm(nlinks);
if 2 * k * (train_size + test_size) <= nlinks
    train_ind = ind(1: k * train_size);
    test_ind = ind(k * train_size + 1: k * train_size + k * test_size);
else  % if negative links not enough, divide them proportionally
    ratio = train_size / (train_size + test_size);
    train_ind = ind(1: floor(ratio * nlinks));
    test_ind = ind(floor(ratio * nlinks) + 1: end);
end
train_neg = neg_links(train_ind, :);
test_neg = neg_links(test_ind, :);

