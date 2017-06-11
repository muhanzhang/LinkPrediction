function [auc] = WLNM(train, test, K, ith_experiment)   
%  Usage: the main program for Weisfeiler-Lehman Neural Machine (WLNM)
%  --Input--
%  -train: a sparse matrix of training links (1: link, 0: otherwise)
%  -test: a sparse matrix of testing links (1: link, 0: otherwise)
%  -K: number of vertices in an enclosing subgraph
%  -ith_experiment: exp index, for parallel computing
%  --Output--
%  -auc: the AUC score of WLNM
%
%  *author: Muhan Zhang, Washington University in St. Louis
%%
    if nargin < 3
        K = 20;
    end
    if nargin < 4
        ith_experiment = 1;
    end

    htrain = triu(train, 1);  % half train adjacency matrix
    htest = triu(test, 1);
    
    % sample negative links for train and test sets
    [train_pos, train_neg, test_pos, test_neg] = sample_neg(htrain, htest, 2);
    [train_data, train_label] = graph2vector(train_pos, train_neg, train, K);
    [test_data, test_label] = graph2vector(test_pos, test_neg, train, K);
    
    % train a model
    model = 3;
    switch model
    case 1  % logistic regression
        addpath('software/liblinear-2.1/matlab');  % need to install liblinear
        train_data = sparse(train_data);
        test_data = sparse(test_data);
        [~, optim_c] = evalc('liblinear_train(train_label, train_data, ''-s 0 -C -q'');');
        model = liblinear_train(train_label, train_data, sprintf('-s 0 -c %d -q', optim_c(1)));
        [~, acc, scores] = liblinear_predict(test_label, test_data, model, '-b 1 -q');
        acc
        l1 = find(model.Label == 1);
        scores = scores(:, l1);
    case 2 % train a feedforward neural network in Torch
        addpath('software/liblinear-2.1/matlab');  % need to install liblinear
        train_data = sparse(train_data);
        test_data = sparse(test_data);
        if exist('tempdata') ~= 7
            !mkdir tempdata
        end
        libsvmwrite(sprintf('tempdata/traindata_%d', ith_experiment), train_label, train_data);
        libsvmwrite(sprintf('tempdata/testdata_%d', ith_experiment), test_label, test_data);  % prepare data
        cmd = sprintf('th nDNN.lua -inputdim %d -ith_experiment %d', K * (K - 1) / 2, ith_experiment);
        system(cmd, '-echo'); 
        scores = load(sprintf('tempdata/test_log_scores_%d.asc', ith_experiment));
        delete(sprintf('tempdata/traindata_%d', ith_experiment));  % to delete temporal train and test data
        delete(sprintf('tempdata/testdata_%d', ith_experiment));
        delete(sprintf('tempdata/test_log_scores_%d.asc', ith_experiment));
    case 3 % train a feedforward neural network in MATLAB
        layers = [imageInputLayer([K*(K-1)/2 1], 'Normalization','none')
        fullyConnectedLayer(32)
        reluLayer
        fullyConnectedLayer(32)
        reluLayer
        fullyConnectedLayer(16)
        reluLayer
        fullyConnectedLayer(2)
        softmaxLayer
        classificationLayer];
        opts = trainingOptions('sgdm', 'InitialLearnRate', 0.001, 'MaxEpochs', 100, 'MiniBatchSize', 128,...
            'LearnRateSchedule','piecewise', 'LearnRateDropFactor', 0.5, 'L2Regularization', 0.001,...
            'ExecutionEnvironment', 'cpu');
        net = trainNetwork(reshape(train_data', K*(K-1)/2, 1, 1, size(train_data, 1)), categorical(train_label), layers, opts);
        [~, scores] = classify(net, reshape(test_data', K*(K-1)/2, 1, 1, size(test_data, 1)));
        scores(:, 1) = [];
    end

    % calculate the AUC
    [~, ~, ~, auc] = perfcurve(test_label', scores', 1);
    auc
end
