function [  thisauc ] = SimRank( train, test, lambda)
%% 计算SimRank指标并返回AUC值
    deg = sum(train,1);     
    % 求节点的入度，构成行向量，供调用
    lastsim = sparse(size(train,1), size(train,2)); 
    % 存储前一步的迭代结果，初始化为全0矩阵
    sim = sparse(eye(size(train,1))); 
    ntrain = train.*repmat(max(1./deg,0),size(train,1),1);
    for iter = 1:5
        sim = max(lambda*(ntrain'*sim*ntrain),eye(size(train,1)));
    end
    
    
    
%     % 存储当前步的迭代结果，初始化为单位矩阵
%     while(sum(sum(abs(sim-lastsim)))>0.00001)      %original = 0.0000001
%     % 迭代至稳态的判定条件
%         %sum(sum(abs(sim-lastsim)))
%         lastsim = sim;  sim = sparse(size(train,1), size(train,2));                                           
%         for nodex = 1:size(train,1)-1      
%         %对每一对节点的值进行更新
%             if deg(nodex) == 0
%                 continue;
%             end
%             for nodey = nodex+1:size(train,1)         
%                 
%             %-----将点x的邻居和点y的邻居所组成的所有节点对的前一步迭代结果相加
%                 if deg(nodey) == 0
%                     continue;
%                 end
%                 sim(nodex,nodey) = lambda * sum(sum(lastsim(train(:,nodex)==1,train(:,nodey)==1))) / (deg(nodex)*deg(nodey));
%                 %nodex, nodey
%             end
%         end
%         sim = sim+sim'+ sparse(eye(size(train,1)));
%     end
    thisauc = CalcAUC(train,test,sim, 10000);    
    % 评测，计算该指标对应的AUC
end
