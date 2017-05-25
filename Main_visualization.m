%  Main program for weight visualization
%%
%dataname = strvcat('2regular.mat'); K = 6; n = 1;
%dataname = strvcat('3regular.mat'); K = 6; n = 2; %kregular(20,3);
dataname = strvcat('1PA.mat'); K = 6; n = 2;  %preferentialAttachment(50,1);
%dataname = strvcat('0.1random.mat'); K = 6; n = 2;

%dataname = strvcat('USAir.mat'); K = 6; n = 5;
%dataname = strvcat('Power.mat'); K = 10; n = 2;
%dataname = strvcat('Celegans.mat'); K = 40; n = 5;


close all;
for ith_data = 1:size(dataname, 1)
    % load current dataset to visualize
    global current_dataset;
    current_dataset = dataname(ith_data, :);
    
    load(sprintf('data/%s', current_dataset));
    
    mo = 1;
    switch mo
        case 1  % train a linear model
            
            % sample negative links for train sets (no test here)
            train = triu(net, 1);
            [train_pos, train_neg, ~, ~] = sample_neg(train, []);
            
            % link prototype extraction
            [train_data, train_label] = graph2vector(train_pos, train_neg, net, K);
            train_data = sign(train_data);  % do not encode distance information here
            train_data(:, 1) = zeros(size(train_data, 1), 1);
            addpath('software/liblinear-2.1/matlab');  % need to install liblinear
            train_data = sparse(train_data);
            
            % train
            [~, optim_c] = evalc('liblinear_train(train_label, train_data, ''-s 0 -C -q'');');
            model = liblinear_train(train_label, train_data, sprintf('-s 0 -c %d -q', optim_c(1)));
            weights = model.w;
            
            frequent_patterns(train_data(1: end/2, :), n, 1);
            frequent_patterns(train_data(end/2+1: end, :), n, 0);
            
        case 2  % train an autoencoder
            
            % sample and extract prototypes of only positive links
            train = triu(net, 1);
            [train_pos, train_neg, ~, ~] = sample_neg(train, []);
            [train_data, train_label] = graph2vector(train_pos, [], net, K);
            train_data = sign(train_data);  % do not encode distance information here
            
            % train
            model = trainAutoencoder(train_data', 1);
            %model = trainAutoencoder(train_data', 1, 'EncoderTransferFunction', 'satlin', 'DecoderTransferFunction', 'satlin');
            weights = model.EncoderWeights;
            
            frequent_patterns(train_data, n);
    end
    
    %save(sprintf('tempdata/%s_weights.mat', current_dataset), 'weights');
    weight_visualization(weights);  % weight visualization
    
    green = [0 204 102]/255;
    orange = [255 128 0]/255;
    red = [255 80 80]/255;
    figure('position', [100 100 500 500]);
    
    plot(graph(net), 'Layout', 'force', 'EdgeColor', orange, 'NodeColor', orange, 'LineWidth', 1, 'MarkerSize', 4, 'NodeLabel', []);
    set(gca,'visible', 'off');
    cd figure/;
    evalc(sprintf('export_fig %s_net -pdf -m2 -transparent -c[90,90,90,90]', current_dataset(1: end-4)));
    cd ..;
    
    % visualize the network adjacency matrix
    deg = sum(net, 2);
    [de, degree_order] = sort(deg, 'descend');
    de = full(de);
    net_reorder = net(degree_order, degree_order);
    figure; imagesc(net_reorder);
    colormap(flipud(gray));
    set(gca,'visible', 'off');
    
    % to show the common neighbor properties of the network
    cn = net * net;
    cnd = triu(cn, 1);
    sum_deg = bsxfun(@plus, deg, deg');
    sum_deg = triu(sum_deg, 1);
    [cns, cn_order] = sort(cnd(:), 'descend');
    sum_deg_v = sum_deg(:);
    sum_deg_v = sum_deg_v(cn_order);
    cn_over_sumdeg = full([cns, sum_deg_v]);
    
    % to compute the average sum_degree of all positive links
    tmp = sum_deg .* net;
    avg_sum_deg = sum(sum(tmp)) / nnz(tmp)
    sum_deg_dist = sort(tmp(:), 'descend');
    sum_deg_dist(sum_deg_dist == 0) = [];
    histogram(sum_deg_dist);
    
end




