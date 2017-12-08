Weisfeiler-Lehman Neural Machine for Link Prediction
====================================================

Usage
----
The first deep learning approach for link prediction (not by embedding), which extracts links' enclosing subgraphs as input to neural networks to learn their formation mechanisms. For more information, see the following paper:
> M. Zhang and Y. Chen, Weisfeiler-Lehman Neural Machine for Link Prediction, Proc. ACM SIGKDD Conference on Knowledge Discovery and Data Mining (KDD-17). [\[Video\]](https://www.youtube.com/watch?v=dRC4T2gABS8&t=43s) [\[PDF\]](http://www.cse.wustl.edu/~muhan/papers/KDD_2017.pdf)

Run Main.m in MATLAB to do the link prediction experiments.

How to run
----------

You need to install liblinear for saving .mat data to libsvm format so that Torch can read them.

    cd software/
    wget -O liblinear.tar.gz http://www.csie.ntu.edu.tw/~cjlin/cgi-bin/liblinear.cgi?+http://www.csie.ntu.edu.tw/~cjlin/liblinear+tar.gz
    tar xvzf liblinear.tar.gz
    cd liblinear-2.1/
    make

This will install liblinear. Then, in MATLAB, cd to "software/liblinear-2.1/matlab/", type "make" to install the MATLAB interface. Please also change the names of "train.mexa64" and "predict.mexa64" to "liblinear_train.mexa64" and "liblinear_predict.mexa64" respectively if you want to train a logistic regression model instead of neural network.

The "WLNM.m" file contains three models: 1) logistic regression, 2) neural network by Torch, and 3) neural network by MATLAB. Please change _model_ in the file according to your need.

If you want to run the Torch neural network (features GPU acceleration) in your Linux server, and your MATLAB cannot succesfully load cunn, please try the following command to start MATLAB. This will replace the MATLAB's libstdc++.so.6 with the system's default one (for successfully loading cunn of Torch inside MATLAB).

    LD_PRELOAD="/usr/lib64/libstdc++.so.6" matlab 

In MATLAB, type

    Main

to run the experiments. By default, you will run WLNM on the smallest network, USAir, for 1 time. Modify: _numberOfExperiment_, _dataname_, and _method_ in "Main.m", in order to run repeated experiments on all datasets, and compare all link prediction methods.

You may also modify "WLNM.m" in order to only store the training and testing data without running Torch, and use your own neural network programs to train and test on them.

Requirements
------------

Torch library _nnsparse_ is required to load data in libsvm format. Install it by:
    
    luarocks install --local nnsparse

MATLAB Toolbox Bioinformatics is required to calculate graph shortest distance in "graph2vector.m".

To calculate AUC score inside lua, you need to download the metrics package (optional)

    git clone https://github.com/hpenedones/metrics.git
    cd metrics
    luarocks --local make

We use nauty, a graph canonization software to break ties in palette-wl labelings. 
This toolbox also contains a useful MATLAB interface for nauty.

To use nauty, first download nauty26r7.tar.gz into "software/" by running:

    cd software/
    wget http://pallini.di.uniroma1.it/nauty26r7.tar.gz

Then install nauty by:

    tar xvzf nauty26r7.tar.gz
    cd nauty26r7
    ./configure
    make

There are two MATLAB wrappers canon.m, canonical.c in the main folder. If there is no canonical.mex file in the main folder, the program canon.m will automatically compile canonical.c for the first time. 

Reference
---------

If you find the code useful, please cite our paper:

    @inproceedings{zhang2017weisfeiler,
      title={Weisfeiler-Lehman Neural Machine for Link Prediction},
      author={Zhang, Muhan and Chen, Yixin},
      booktitle={Proceedings of the 23rd ACM SIGKDD International Conference on Knowledge Discovery and Data Mining},
      pages={575--583},
      year={2017},
      organization={ACM}
    }

Thanks!

Muhan Zhang, muhan@wustl.edu
2/15/2017
