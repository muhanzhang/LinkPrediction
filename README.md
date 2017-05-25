Weisfeiler-Lehman Neural Machine for Link Prediction
====================================================

Usage
----
The first deep learning approach for link prediction, which extracts links' enclosing subgraphs as input to neural networks to learn their formation mechanisms. For more information, see the following paper:
> M. Zhang and Y. Chen, Weisfeiler-Lehman Neural Machine for Link Prediction, Proc. ACM SIGKDD Conference on Knowledge Discovery and Data Mining (KDD-17).

Run Main.m in MATLAB to do the link prediction experiments.

Requirements
------------

You need to install liblinear for saving .mat data to libsvm format so that Torch can read them.

    cd software/
    wget -O liblinear.tar.gz http://www.csie.ntu.edu.tw/~cjlin/cgi-bin/liblinear.cgi?+http://www.csie.ntu.edu.tw/~cjlin/liblinear+tar.gz
    tar xvzf liblinear.tar.gz
    cd liblinear-2.1/
    make

This will install liblinear. Then, in MATLAB, cd to the "software/liblinear-2.1/matlab/", type "make" to install the MATLAB interface. Please also change the name of "train.mexa64" and "predict.mexa64" to "liblinear_train.mexa64" and "liblinear_predict.mexa64" if you want to train a logistic regression model instead of neural network.

Use the following command to run MATLAB in your linux server. This will replace the system's default libstdc++.so.6 with that of MATLAB's (for successfully loading cunn of Torch)

    LD_PRELOAD="/usr/lib64/libstdc++.so.6" matlab 

Then, in MATLAB, type

    Main

to run the experiments. By default, you will run WLNM on the smallest network, USAir, for 1 time. Modify: numberOfExperiment, dataname, and method in Main.m, in order to run repeated experiments on all datasets to compare all link prediction methods.

You may also modify WLNM.m in order to only store the training and testing data without running Torch, and use your own neural network programs to train and test on them.

To calculate AUC score inside lua, you need to download the metrics package (optional)

    git clone https://github.com/hpenedones/metrics.git
    cd metrics
    loarocks --local make

We use nauty, a graph canonization software to break ties in palette-wl labelings. 
To use nauty, first download nauty26r7.tar.gz into "software/" by running:

    cd software/
    wget http://pallini.di.uniroma1.it/nauty26r7.tar.gz

Then install nauty by:

    tar xvzf nauty26r7.tar.gz
    cd nauty26r7
    ./configure
    make

There are two MATLAB wrappers canon.m, canonical.c in the main folder. If there is no canonical.mex*64 file in the main folder, the program canon.m will compile canonical.c for the first time. 

Please contact Muhan Zhang, muhan@wustl.edu if you encounter any bugs.
2017.2.15
