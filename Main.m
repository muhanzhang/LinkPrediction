%  Main Program. Partly adapted from the codes of 
%  Lu 2011, Link prediction in complex networks: A survey.
%
%  *author: Muhan Zhang, Washington University in St. Louis

%rng(100);
addpath(genpath('utils'));

ratioTrain = 0.9;            
numOfExperiment = 1;        
datapath = 'data/';

%dataname = strvcat('USAir','NS','PB','Yeast','Celegans','Power','Router','Ecoli');
%dataname = strvcat('USAir');

tic;
%method = [1, 2, 3, 4, 5, 6];  % 1: WLNM,  2: common-neighbor-based,  3: path-based, 4: random walk  5: latent-feature-based,  6: stochastic block model
method = [1];
num_in_each_method = [1, 13, 6, 13, 1, 1];  % how many algorithms in each type of method
num_of_methods = sum(num_in_each_method(method));  % the total number of algorithms

auc_for_dataset = [];
for ith_data = 1:size(dataname, 1)                          
    tempcont = ['processing the ', int2str(ith_data), 'th dataset...', dataname(ith_data,:)];
    disp(tempcont);
    thisdatapath = strcat(datapath,dataname(ith_data,:),'.mat');    
    load(thisdatapath);                                 
    aucOfallPredictor = zeros(numOfExperiment, num_of_methods); 
    PredictorsName = [];
    
    % parallelize the repeated experiments
    poolobj = parpool(feature('numcores'));
    parfor ith_experiment = 1:numOfExperiment
        ith_experiment
        if mod(ith_experiment, 10) == 0
                tempcont = strcat(int2str(ith_experiment),'%... ');
                disp(tempcont);
        end
        % divide into train/test
        [train, test] = DivideNet(net,ratioTrain);                  
        train = sparse(train); test = sparse(test);
        train = spones(train + train'); test = spones(test + test');    
        ithAUCvector = []; Predictors = []; % for recording results
        
        % run link prediction methods
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%% Weisfeiler-Lehman Neural Machine (WLNM)
        if ismember(1, method)
        disp('WLNM...');
        tempauc = WLNM(train, test, 10, ith_experiment);                  % WLNM
            Predictors = [Predictors '%WLNM	'];      ithAUCvector = [ithAUCvector tempauc];
        end

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%% Common Neighbor-based methods, 13 methods
        if ismember(2, method)
        disp('CN...');
        tempauc = CN(train, test);                  % Common Neighbor
            Predictors = [Predictors 'CN	'];      ithAUCvector = [ithAUCvector tempauc];
        
        disp('Salton...');
        tempauc = Salton(train, test);              % Salton Index
             Predictors = [Predictors 'Salton	'];  ithAUCvector = [ithAUCvector tempauc];
        
        disp('Jaccard...');
        tempauc = Jaccard(train, test);             % Jaccard Index
             Predictors = [Predictors 'Jaccard	'];  ithAUCvector = [ithAUCvector tempauc];  

        disp('Sorenson...');
        tempauc = Sorenson(train, test);            % Sorenson Index
             Predictors = [Predictors 'Sorens	'];   ithAUCvector = [ithAUCvector tempauc];  
        
        disp('HPI...');
        tempauc = HPI(train, test);                 % Hub Promoted Index
             Predictors = [Predictors 'HPI	'];       ithAUCvector = [ithAUCvector tempauc];  
        
        disp('HDI...');
        tempauc = HDI(train, test);                 % Hub Depressed Index
             Predictors = [Predictors 'HDI	'];       ithAUCvector = [ithAUCvector tempauc];  
        
        disp('LHN...');
        tempauc = LHN(train, test);                 % Leicht-Holme-Newman
             Predictors = [Predictors 'LHN	'];       ithAUCvector = [ithAUCvector tempauc];  
        
        disp('AA...');
        tempauc = AA(train, test);                  % Adar-Adamic Index
             Predictors = [Predictors 'AA	'];       ithAUCvector = [ithAUCvector tempauc];  
        
        disp('RA...');
        tempauc = RA(train, test);                  % Resourse Allocation
             Predictors = [Predictors 'RA	'];       ithAUCvector = [ithAUCvector tempauc];  
       
        disp('PA...');
        tempauc = PA(train, test);                  % Preferential Attachment
             Predictors = [Predictors 'PA	'];       ithAUCvector = [ithAUCvector tempauc];  
        
        disp('LNBCN...');
        tempauc = LNBCN(train, test);               % Local naive bayes method - Common Neighbor
             Predictors = [Predictors 'LNBCN	'];       ithAUCvector = [ithAUCvector tempauc];  
        
        disp('LNBAA...');
        tempauc = LNBAA(train, test);               % Local naive bayes method - Adar-Adamic Index
             Predictors = [Predictors 'LNBAA	'];       ithAUCvector = [ithAUCvector tempauc];  
        
        disp('LNBRA...');
        tempauc = LNBRA(train, test);               % Local naive bayes method - Resource Allocation
             Predictors = [Predictors 'LNBRA	'];       ithAUCvector = [ithAUCvector tempauc];  
        
        end

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Path-based methods, 6 methods
        
        if ismember(3, method)
        disp('LocalPath...');
        tempauc = LocalPath(train, test, 0.0001);   % Local Path Index
             Predictors = [Predictors 'LocalP	'];   ithAUCvector = [ithAUCvector tempauc];  
        
        disp('Katz 0.01...');
        tempauc = Katz(train, test, 0.01);          % Katz Index, beta=0.01
             Predictors = [Predictors 'Katz.01	'];   ithAUCvector = [ithAUCvector tempauc];  
        
        disp('Katz 0.001...');
        tempauc = Katz(train, test, 0.001);         % Katz Index, beta=0.001
             Predictors = [Predictors '~.001	'];       ithAUCvector = [ithAUCvector tempauc];  
        
        disp('LHNII 0.9...');
        tempauc = LHNII(train, test, 0.9);          % Leicht-Holme-Newman II
             Predictors = [Predictors 'LHNII.9	'];    ithAUCvector = [ithAUCvector tempauc];  
        
        disp('LHNII 0.95...');
        tempauc = LHNII(train, test, 0.95);         % Leicht-Holme-Newman II
             Predictors = [Predictors '~.95	'];       ithAUCvector = [ithAUCvector tempauc];  
        
        disp('LHNII 0.99...');
        tempauc = LHNII(train, test, 0.99);         % Leicht-Holme-Newman II
             Predictors = [Predictors '~.99	'];       ithAUCvector = [ithAUCvector tempauc];  
             
        end

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %Random walk-based Methods, 13 methods

        if ismember(4, method)
        disp('ACT...');
        tempauc = ACT(train, test);                 % Average commute time
             Predictors = [Predictors 'ACT	'];       ithAUCvector = [ithAUCvector tempauc];  
        
        disp('CosPlus...');
        tempauc = CosPlus(train, test);             % Cos+ based on Laplacian matrix
             Predictors = [Predictors 'CosPlus	'];   ithAUCvector = [ithAUCvector tempauc];  
        
        disp('RWR 0.85...');
        tempauc = RWR(train, test, 0.85);           % Random walk with restart (PageRank), d=0.85
             Predictors = [Predictors 'RWR.85	'];   ithAUCvector = [ithAUCvector tempauc];  
        
        disp('RWR 0.95...');
        tempauc = RWR(train, test, 0.95);           % Random walk with restart, d=0.95
             Predictors = [Predictors '~.95	'];      ithAUCvector = [ithAUCvector tempauc];  
        
        disp('SimRank 0.6...');
        tempauc = SimRank(train, test, 0.6);        % SimRank
             Predictors = [Predictors 'SimR	'];      ithAUCvector = [ithAUCvector tempauc];  
        
        disp('LRW 3...');
        tempauc = LRW(train, test, 3, 0.85);        % Local random walk, step 3
             Predictors = [Predictors 'LRW_3	'];       ithAUCvector = [ithAUCvector tempauc];  
        
        disp('LRW 4...');
        tempauc = LRW(train, test, 4, 0.85);        % Local random walk, step 4
             Predictors = [Predictors '~_4	'];       ithAUCvector = [ithAUCvector tempauc];  
        
        disp('LRW 5...');
        tempauc = LRW(train, test, 5, 0.85);        % Local random walk, step 5
             Predictors = [Predictors '~_5	'];       ithAUCvector = [ithAUCvector tempauc];  
        
        disp('SRW 3...');
        tempauc = SRW(train, test, 3, 0.85);        % Superposed random walk, step 3
             Predictors = [Predictors 'SRW_3	'];       ithAUCvector = [ithAUCvector tempauc];  
        
        disp('SRW 4...');
        tempauc = SRW(train, test, 4, 0.85);        % Superposed random walk, step 4
             Predictors = [Predictors '~_4	'];       ithAUCvector = [ithAUCvector tempauc];  
        
        disp('SRW 5...');
        tempauc = SRW(train, test, 5, 0.85);        % Superposed random walk, step 5
             Predictors = [Predictors '~_5	'];       ithAUCvector = [ithAUCvector tempauc];  
             
        disp('MFI...');
        tempauc = MFI(train, test);                 % Matrix forest Index
             Predictors = [Predictors 'MFI	'];       ithAUCvector = [ithAUCvector tempauc];  
        
        disp('TS...');
        tempauc = TSCN(train, test, 0.01);          % Transfer similarity - Common Neighbor
             Predictors = [Predictors 'TSCN	'];       ithAUCvector = [ithAUCvector tempauc];  
        
        end
       
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if ismember(5, method)
        % latent feature models
        disp('MF...');
        tempauc = MF(train, test, 5, ith_experiment);                 % matrix factorization
             Predictors = [Predictors 'MF	'];       ithAUCvector = [ithAUCvector tempauc];  
        end
            
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if ismember(6, method)
        % latent feature models
        disp('SBM...');
        tempauc = SBM(train, test, 12);                 % stochastic block models
             Predictors = [Predictors 'SBM	'];       ithAUCvector = [ithAUCvector tempauc];  
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        aucOfallPredictor(ith_experiment, :) = ithAUCvector; PredictorsName = Predictors;
    end
    delete(poolobj)

    %% write the results for this dataset
    avg_auc = mean(aucOfallPredictor,1)
    auc_for_dataset = [auc_for_dataset, avg_auc];
    var_auc = var(aucOfallPredictor, 0, 1);
    respath = strcat(datapath,'result/',dataname(ith_data,:),'_res.txt');         
    dlmwrite(respath,{PredictorsName}, '');
    dlmwrite(respath,[avg_auc; var_auc], '-append','delimiter', '	','precision', 4);
    
end 
toc;
auc_for_dataset'


