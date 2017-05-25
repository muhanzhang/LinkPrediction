function [  thisauc] = Katz( train, test, lambda )
%% 计算katz指标并返回AUC值
    sim = inv( sparse(eye(size(train,1))) - lambda * train);   
    % 相似性矩阵的计算
    sim = sim - sparse(eye(size(train,1)));
    [thisauc] = CalcAUC(train,test,sim, 10000);   
    % 评测，计算该指标对应的AUC
end
